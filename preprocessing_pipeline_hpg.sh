#!/bin/bash

#organizes fdirectories and prepares files for preprocessing
#for use on server with slurm sbatch scripts
#for questions please contact desiree.lussier@ufl.edu

echo "This bash script is a complete preprocessing pipeline for the OT Aging study, inlcuding:"
echo "structural segmentation, resting state melodic ica, heider simmel fmri task and diffusion tensor tractography on the UF Hipergator2"
echo "Written by Désirée Lussier for The Social Cognitive and Affective Lab"
echo "Dr Natalie Ebner"
echo "University of Florida"
echo "desiree.lussier@ufl.edu"
echo "http://www.psych.ufl.edu/ebnerlab/"
echo "10 August 2017"

filepath=<filepath_to_data>
scriptdir=<directory_containing_scripts>

#loads mricron module for dcm2niix
module load mricron

#loops through list of subject files
for i in subj01 subj02...
do

#creates folders within subject directory to move data
 mkdir $i
 mkdir $i/T1
 mkdir $i/rsBOLD
 mkdir $i/hsBOLD
 mkdir $i/$i
 echo "directories created for"
 echo $i

#copies needed data from shared folder to working directory
#replace $filepath with the shared directory containing the individual subject folders with the raw data
 cp $filepath/$i/T1/T1.nii $i/T1/
 cp $filepath/$i/RS/rsBOLD.nii $i/rsBOLD/
 cp -r $filepath/$i/DTI/ $i/
 cp $filepath/$i/HS/hsBOLD.nii $i/hsBOLD/
 cp -r $filepath/$i/HS/hs_behavioral/ $i/hsBOLD/
 cp $filepath/$i/MRS/${i}_session_2_mrs_tpj_raw_act.SDAT ../../mrs
 cp $filepath/$i/MRS/${i}_session_2_mrs_tpj_raw_act.SPAR ../../mrs
 cp $filepath/$i/MRS/${i}_session_2_mrs_tpj_raw_ref.SDAT ../../mrs
 cp $filepath/$i/MRS/${i}_session_2_mrs_tpj_raw_ref.SPAR ../../mrs
 cp $i/T1/T1.nii ../../mrs/${i}_session_2_t1.nii 
 echo "data copied for"
 echo $i

#organizes folder in working directory so that additional scripts will run
 mkdir $i/FSL/
 mkdir $i/FSL/T1
 mkdir $i/FSL/melodics/
 mkdir $i/FSL/denoised/
 mkdir $i/DTI/FSL/
 mkdir $i/DTI/FSL/bvals
 mkdir $i/DTI/FSL/bvecs
 mkdir $i/DTI/raw/
 mkdir $i/DTI/nifti/
 mkdir $i/DTI/FSL/
 mv $i/hsBOLD/hs_behavioral/HS_MH_*.txt $i/hsBOLD/hs_behavioral/eprime.txt
 mv $i/DTI/DTI_dicoms/ $i/DTI/raw/DTI_dicoms/
 mv $i/DTI/b0_map_dicoms $i/DTI/raw/b0_map_dicoms/
 cp $i/T1/T1.nii $i/$i/
 echo "subdirectories organized for"
 echo $i

#copies processing and preprocessing scripts in to subject folder
 cp $scriptdir/freesurfer_run.sh $i/
 cp $scriptdir/DTI_preprocessing.sh $i/
 cp $scriptdir/fsl_bet_melodic_feat.sh $i/
 cp $scriptdir/hs_feat.fsf $i/
 cp $scriptdir/rs_melodic.fsf $i/
 cp $scriptdir/HS_timing_write.sh $i/hsBOLD/hs_behavioral/
 echo "scripts copied for"
 echo $i
 
#converts dti dicoms to niftis
 dcm2niix $i/DTI/raw/DTI_dicoms/
 dcm2niix $i/DTI/raw/b0_map_dicoms/

#moves and renames files to set up folder to run DTI preporcessing scripts
 mv $i/DTI/raw/DTI_dicoms/*6_dir*.nii $i/DTI/nifti/6dir.nii
 mv $i/DTI/raw/DTI_dicoms/*64_dir*.nii $i/DTI/nifti/64dir.nii
 mv $i/DTI/raw/DTI_dicoms/*6_dir*.json $i/DTI/nifti/6dir.json
 mv $i/DTI/raw/DTI_dicoms/*64_dir*.json $i/DTI/nifti/64dir.json
 mv $i/DTI/raw/DTI_dicoms/*64_dir*.bval $i/DTI/nifti/64dir.bval
 mv $i/DTI/raw/DTI_dicoms/*64_dir*.bvec $i/DTI/nifti/64dir.bvec  
 mv $i/DTI/raw/b0_map_dicoms/b0_map_dicoms_WIP_B0-MAP-TE3-TE6_*.nii $i/DTI/nifti/b0map.nii
 mv $i/DTI/raw/b0_map_dicoms/b0_map_dicoms_WIP_B0-MAP-TE3-TE6_*.json $i/DTI/nifti/b0map.json
 mv $i/DTI/raw/b0_map_dicoms/b0_map_dicoms_WIP_B0-MAP-TE3-TE6_*e1.nii $i/DTI/nifti/b0map_e1.nii
 mv $i/DTI/raw/b0_map_dicoms/b0_map_dicoms_WIP_B0-MAP-TE3-TE6_*e1.json $i/DTI/nifti/b0map_e1.json
 cp $i/DTI/nifti/64dir.bval $i/DTI/FSL/bvals
 cp $i/DTI/nifti/64dir.bvec $i/DTI/FSL/bvecs
 cp $i/DTI/nifti/64dir.nii $i/DTI/FSL/64dir.nii
 cp $i/DTI/nifti/64dir.nii $i/DTI/FSL/data.nii
 cp $i/DTI/nifti/64dir.json $i/DTI/FSL/64dir.json
 echo "dti dicoms converted to nifti for"
 echo $i

#renames variable in fsl melodic, fsl feat, and freesurfer recon-all processing script to subject number 
 sed -i -e "s/subject/${i}/g" $i/hs_feat.fsf
 sed -i -e "s/subject/${i}/g" $i/rs_melodic.fsf
 sed -i -e "s/subject/${i}/g" $i/freesurfer_run.sh
 echo "correct subject number inserted into scripts for"
 echo $i

#drops down in to subject subdirectories
 cd $i/hsBOLD/hs_behavioral/

#runs script that creates subject specific timing files
  bash HS_timing_write.sh

#moves back up to subject directory containing batch scripts
 cd ../../
 echo "timing files created for"
 echo $i

#runs subject-level preprocessing scripts via sbatch on the hipergator2
   sbatch fsl_bet_melodic_feat.sh
   sbatch freesurfer_run.sh
   sbatch DTI_preprocessing.sh
   echo "sbatch processing started for"
   echo $i

#returns to home folder to continue loop
  cd ../
  echo $i 
  echo "completed, moving on..."

done

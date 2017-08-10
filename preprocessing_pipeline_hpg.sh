#!/bin/bash

#organizes folder and prepares files for preprocessing
#for use on server with slurm sbatch scripts
#for questions please contact dgulliford@ufl.edu

echo "This bash script is a complete preprocessing pipeline for structural segmentation, resting state melodic ica, and diffusion tensor tractography on the UF Hipergator2"
echo "Written by Désirée Lussier for Ebner Labs"
echo "University of Florida"
echo "dgulliford@ufl.edu"
echo "http://www.psych.ufl.edu/ebnerlab/"
echo "10 August 2017"

#loads mricron module for dcm2niix
module load mricron

#loops through list of subject files
for i in subj01 subj02...
do

#creates folders within subject directory to move data
 mkdir $i
 mkdir $i/T1
 mkdir $i/rsBOLD
 mkdir $i/$i

#copies needed data from shared folder to working directory
#replace $filepath with the shared directory containing the individual subject folders with the raw data
 cp $filepath/$i/T1/T1.nii $i/T1/
 cp $filepath/$i/RS/rsBOLD.nii $i/rsBOLD/
 cp -r $filepath/$i/DTI/ $i/

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
 mv $i/DTI/DTI_dicoms/ $i/DTI/raw/DTI_dicoms/
 mv $i/DTI/b0_map_dicoms $i/DTI/raw/b0_map_dicoms/
 cp $i/T1/T1.nii $i/$i/
 echo "direcotries set up and data copied for"
 echo $i

#copies processing and preprocessing scripts in to subject folder
 cp $scriptdir/freesurfer_run.sh $i/
 cp $scriptdir/DTI_preprocessing.sh $i/
 cp $scriptdir/melodic_individual.sh $i/
 echo "scripts set for"
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
 echo "direcotries set up for"
 echo $i

#renames variable in freesurfer recon-all processing script to subject number 
  sed -i -e "s/subject/${i}/g" $i/freesurfer_run.sh

#drops down in to subject folder
  cd $i/

#runs subject-level preprocessing scripts via sbatch on the hipergator2
   sbatch melodic_individual.sh
   sbatch freesurfer_run.sh
   sbatch DTI_preprocessing.sh
   echo "sbatch processing started for"
   echo $i

#returns to home folder to continue loop
  cd ../
  echo $i 
  echo "completed, moving on..."

done

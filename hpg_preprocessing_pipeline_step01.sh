#!/bin/bash

#organizes fdirectories and prepares files for preprocessing
#for use on server with slurm sbatch scripts
#for questions please contact desiree.lussier@ufl.edu

echo "This bash script is step one in preprocessing pipeline for the OT Aging study, inlcuding:"
echo "Written by Desiree Lussier for The Social Cognitive and Affective Lab"
echo "University of Florida"
echo "desiree.lussier@ufl.edu"
echo "http://www.psych.ufl.edu/ebnerlab/"
echo "updated 7 September 2018"

#list subjects, give filepaths to raw data and scripts directory from current folders
#for visit use 01 if baseline visits or 02 if postintervention visits
list=<subjects>
filepath=<filepath_to_raw_data>
scriptdir=<directory_containing_scripts>
visit=<visit_number>

#loads mricron module for dcm2niix
module load mricron

#loops through list of subject files
for a in $list
do

#creates folders within subject directory to move data
	mkdir ${a}${visit}
	mkdir ${a}${visit}/T1
	mkdir ${a}${visit}/rsBOLD
	mkdir ${a}${visit}/hsBOLD
 mkdir ${a}${visit}/b0
 mkdir ${a}${visit}/DTI
	mkdir ${a}${visit}/${a}${visit}

#copies needed data from shared folder to working directory
	cp $filepath/${a}${visit}/T1/T1.nii ${a}${visit}/T1/
	cp $filepath/${a}${visit}/RS/rsBOLD.nii ${a}${visit}/rsBOLD/
 cp $filepath/${a}${visit}/HS/hsBOLD.nii ${a}${visit}/hsBOLD/
	cp -r $filepath/${a}${visit}/DTI/DTI_dicoms/ ${a}${visit}/DTI
 cp -r $filepath/${a}${visit}/DTI/b0_map_dicoms ${a}${visit}/b0_map_dicoms
	cp ${a}${visit}/T1/T1.nii ${a}${visit}/${a}${visit}/

###make sure going to poper directories
#copies processing and preprocessing scripts in to subject folder
#please note that the subject number in freesurfer_run must be modified for each participant
	cp $scriptdir/freesurfer_run.sh ${a}${visit}/
	cp $scriptdir/eddycorrect.sh ${a}${visit}/
	cp $scriptdir/hsFEAT_fsreg.fsf ${a}${visit}/
 cp $scriptdir/rsICA_fsreg.fsf ${a}${visit}/
	cp $scriptdir/freesurfer_subfields.sh ${a}${visit}/
	cp $scriptdir/hsFEAT.sh ${a}${visit}/
 cp $scriptdir/rsICA.sh ${a}${visit}/
	cp $scriptdir/bedpostx.sh ${a}${visit}/
 cp $scriptdir/tracall_prep_config.txt ${a}${visit}/

#converts dti dicoms to niftis
	dcm2niix ${a}${visit}/DTI/DTI_dicoms/
	dcm2niix ${a}${visit}/DTI/b0_map_dicoms/

	#create directories for tracall in tracula folder
		mkdir tracula/${a}${visit}/
	 mkdir tracula/${a}${visit}/scripts/
	 mkdir tracula/${a}${visit}/dmri/
		mkdir tracula/${a}${visit}/dmri/xfms
		mkdir tracula/${a}${visit}/dmri/mni
		mkdir tracula/${a}${visit}/dlabel/
		mkdir tracula/${a}${visit}/dlabel/diff/
		mkdir tracula/${a}${visit}/dlabel/anatorig/
		mkdir tracula/${a}${visit}/dlabel/anat/

		echo " tracula directories created for " ${a}${visit}

#moves and renames files to set up folder to run DTI preporcessing scripts
  mv DTI/${a}${visit}/*64*dir*.nii DTI/${a}${visit}/64dir.nii
  mv DTI/${a}${visit}/*64*dir*.bval DTI/${a}${visit}/64dir.bvals
  mv DTI/${a}${visit}/*64*dir*.bvec DTI/${a}${visit}/64dir.bvecs
  cp ${a}${visit}/DTI/64dir.nii tracula/${a}${visit}/dmri/
  cp ${a}${visit}/DTI/64dir.bvals tracula/${a}${visit}/dmri/
  cp ${a}${visit}/DTI/64dir.bvecs tracula/${a}${visit}/dmri/
  mv tracula/${a}${visit}/dmri/64dir.nii tracula/${a}${visit}/dmri/dwi_orig.nii
  mv tracula/${a}${visit}/dmri/64dir.bvals tracula/${a}${visit}/dmri/dwi_orig_trans.bvals
  mv tracula/${a}${visit}/dmri/64dir.bvecs tracula/${a}${visit}/dmri/dwi_orig_trans.bvecs
	 mv ${a}${visit}/b0/b0_map_dicoms/*b0*.nii ${a}${visit}/b0/b0_map_dicoms/b0map.nii
  cp ${a}${visit}/b0/b0_map_dicoms/b0map.nii tracula/${a}${visit}/dmri/
  mv tracula/${a}${visit}/dmri/64dir.nii tracula/${a}${visit}/dmri/dwi_orig.nii
  mv tracula/${a}${visit}/dmri/64dir.bvals tracula/${a}${visit}/dmri/dwi_orig_trans.bvals
  mv tracula/${a}${visit}/dmri/64dir.bvecs tracula/${a}${visit}/dmri/dwi_orig_trans.bvecs

	#transpose bvecs and bvals
	  awk '{for (i=1; i<=NF; i++) a[i,NR]=$i
	        max=(max<NF?NF:max)}
	        END {for (i=1; i<=max; i++)
	              {for (j=1; j<=NR; j++)
	                  printf "%s%s", a[i,j], (j==NR?RS:FS)
	              }
	        }' tracula/${a}${visit}/dmri/dwi_orig_trans.bvals > tracula/${a}${visit}/dmri/dwi_orig.bvals

	  awk '{for (i=1; i<=NF; i++) a[i,NR]=$i
	        max=(max<NF?NF:max)}
	        END {for (i=1; i<=max; i++)
	              {for (j=1; j<=NR; j++)
	                  printf "%s%s", a[i,j], (j==NR?RS:FS)
	              }
	        }' tracula/${a}${visit}/dmri/dwi_orig_trans.bvecs > tracula/${a}${visit}/dmri/dwi_orig.bvecs

	  echo "bvals and bvecs transposed for " ${a}${visit}

	#reorients dwi to las space
  orientLAS tracula/${a}${visit}/dmri/dwi_orig.nii tracula/${a}${visit}/dmri/dwi_orig_las.nii.gz
	 mv -f tracula/${a}${visit}/dmri/dwi_orig_las.bvecs tracula/${a}${visit}/dmri/bvecs
	 mv -f tracula/${a}${visit}/dmri/dwi_orig_las.bvals tracula/${a}${visit}/dmri/bvals

	 echo "dwi reoriented to las space for " ${a}${visit}
 
 #drops down into tracula subject folder and starts eddy current correct run on slurm
	 cd tracula/${a}${visit}/
    sbatch eddycorrect.sh
  cd ../../
	 echo "eddy current correct run started for " ${a}${visit}

#renames variable in freesurfer recon-all processing script to subject number
 sed -i -e "s/INDV_SUBJECTID/${a}${visit}/g" ${a}${visit}/freesurfer_run.sh
	sed -i -e "s/INDV_SUBJECTID/${a}${visit}/g" ${a}${visit}/hsFEAT_fsreg.fsf
 sed -i -e "s/INDV_SUBJECTID/${a}${visit}/g" ${a}${visit}/rsICA_fsreg.fsf
	sed -i -e "s/INDV_SUBJECTID/${a}${visit}/g" ${a}${visit}/rsICA_fsreg.fsf
	sed -i -e "s/INDV_SUBJECTID/${a}${visit}/g" ${a}${visit}/tracall_prep_config.txt ####use different variable
 echo "correct subject number inserted into scripts for" ${a}${visit}

#drops down in to subject folder and starts freesurfer run
 cd ${a}${visit}/
  sbatch freesurfer_run.sh
 cd ../
 echo "eddy freesurfer run started for " ${a}${visit}

 echo ${a}${visit} "completed, moving on..."

done

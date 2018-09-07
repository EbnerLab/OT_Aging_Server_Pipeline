#!/bin/bash

###things to be added to this file:
##organize freesurfer directory
##timing file creation
##correct for inhomogeneity in MRI field using b0

#list subjects on same line with space between
#append 01 if baseline visit or 02 if postintervention visit at the end of each subject id with no space between id and visit number
list=<subject>

#loads appropriate modules (varies by system)
module load freesurfer/6.0.0
module load fsl/5.0.10

#loops through listed subjects
for a in $list
do

#rotates bvecs to adjust for eddy current
    mv -f tracula/${a}/dmri/bvecs tracula/${a}/dmri/bvecs.norot
    xfmrot tracula/${a}/dmri/dwi.ecclog tracula/${a}/dmri/bvecs.norot tracula/${a}/dmri/bvecs

    echo "bvecs rotated to adjust for eddy current for " $a

#creates low-b image and mask
    mri_convert --frame 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 tracula/${a}/dmri/dwi.nii.gz tracula/${a}/dmri/lowb.nii.gz
    mri_concat --i tracula/${a}/dmri/lowb.nii.gz --mean --o tracula/${a}/dmri/lowb.nii.gz
    bet tracula/${a}/dmri/lowb.nii.gz tracula/${a}/dmri/lowb_brain.nii.gz -m -f 0.3
    mv -f tracula/${a}/dmri/lowb_brain_mask.nii.gz tracula/${a}/dlabel/diff

    echo "low-b image and mask created for " $a

#quantifies motion in dwi data
##check T value
    dmri_motion --dwi tracula/${a}/dmri/dwi_orig.nii --mat tracula/${a}/dmri/dwi.ecclog --bval tracula/${a}/dmri/bvals --T 41.387096 --out tracula/${a}/dmri/dwi_motion.txt

    echo "motion quantified for " $a

  cd ${a}/

    sbatch tracall_prep.sh
    sbatch freesurfer_subfields.sh
    sbatch hsFEAT.sh
    sbatch rsICA.sh

  cd ../

done

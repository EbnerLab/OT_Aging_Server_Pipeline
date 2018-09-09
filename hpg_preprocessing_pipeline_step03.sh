#!/bin/bash

#list subjects on same line with space between
#append 01 if baseline visit or 02 if postintervention visit at the end of each subject id with no space between id and visit number
list=<subjects>

for a in $list
do

  unlink tracula/${a}/data.nii.gz
  unlink tracula/${a}/dmri/nodif_brain_mask.nii.gz
  rm tracula/${a}/bedpostx.sh
  cp bedpostx.sh tracula/${a}
  cp tracula/${a}/dmri/dwi.nii.gz tracula/${a}/dmri/data_cp.nii.gz
  mv tracula/${a}/dmri/data_cp.nii.gz tracula/${a}/dmri/data.nii.gz
  cp tracula/${a}/dlabel/diff/aparc+aseg_mask.bbr.nii.gz tracula/${a}/dmri/aparc+aseg_mask.bbr.nii.gz
  mv tracula/${a}/dmri/aparc+aseg_mask.bbr.nii.gz tracula/${a}/dmri/nodif_brain_mask.nii.gz

  cd tracula/${a}

    sbatch bedpostx.sh

  cd ../../

  echo "bedpostx started for " ${a}

done

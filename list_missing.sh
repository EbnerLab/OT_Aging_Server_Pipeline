#!/bin/bash

#lists missing files for subjects listed
#replace $subjectslist with subject numbers separated by a space

for a in $subjectslist

[[ -f "$a/T1/T1.nii" ]] || echo "$a/T1"
[[ -f "$a/rsBOLD/rsBOLD.nii" ]] || echo "$a/rsBOLD"
[[ -f "$a/FSL/T1/T1_reorient.nii.gz" ]] || echo "$a/T1_reorient"
[[ -f "$a/FSL/T1/T1_brain.nii.gz" ]] || echo "$a/T1_brain"
[[ -f "$a/FSL/melodics/melodic_ICstats" ]] || echo "$a/melodics"
[[ -f "$a/freesurfer/$a/mri/aparc+aseg.mgz" ]] || echo "$a/freesurfer"
[[ -f "$a/DTI/raw/DTI_dicoms/DICOMDIR" ]] || echo "$a/DTI_dicoms"
[[ -f "$a/DTI/raw/b0_map_dicoms/DICOMDIR" ]] || echo "$a/b0_map_dicoms"
[[ -f "$a/DTI/nifti/64dir.nii" ]] || echo "$a/64dir"
[[ -f "$a/DTI/nifti/6dir.nii" ]] || echo "$a/6dir"
[[ -f "$a/DTI/nifti/b0map.nii" ]] || echo "$a/b0map"
[[ -f "$a/DTI/FSL/data.nii" ]] || echo "$a/bedpost_data"
[[ -f "$a/DTI/FSL.bedpostX/xfms/standard2diff.mat" ]] || echo "$a/bedpostx_reg"
[[ -f "$a/DTI/FSL.bedpostX/mean_fsumsamples.nii.gz" ]] || echo "$a/bedpostx"

done

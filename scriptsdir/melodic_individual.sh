#!/bin/bash
#SBATCH --account=[name_of_group_account]
#SBATCH --qos=[name_of_group_account]
#SBATCH --job-name=melodic_ica
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=[email_associated_with_hpg_account]
#SBATCH --ntasks=1
#SBATCH --mem=8gb
#SBATCH --time=12:00:00
#SBATCH --output=melodic_%j.out
pwd; hostname; date

module load fsl/5.0.8

fslreorient2std T1/T1.nii.gz FSL/T1/T1_reorient.nii.gz
bet FSL/T1/T1_reorient.nii.gz FSL/T1/T1_brain.nii.gz -f .1 -B -R
mcflirt -in rsBOLD/rsBOLD.nii -o FSL/melodics/motion_corr -smooth 8.0 -stats
flirt -in FSL/melodics/motion_corr -ref FSL/T1/T1_brain -applyxfm -usesqform -out FSL/melodics/subj_reg
flirt -in FSL/melodics/subj_reg -ref ../../../../../../apps/fsl/5.0.8/fsl/data/standard/MNI152_T1_2mm -applyxfm -usesqform -out FSL/melodics/mni_reg
melodic -i FSL/melodics/mni_reg -o FSL/melodics/ --report

date

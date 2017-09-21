#!/bin/bash
#SBATCH --account=<group>
#SBATCH --qos=<group>
#SBATCH --job-name=bet_melodic_feat
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=<email_associated_with_hipergator_account>
#SBATCH --ntasks=1
#SBATCH --mem=8gb
#SBATCH --time=12:00:00
#SBATCH --output=bet_melodic_feat_%j.out
pwd; hostname; date

module load fsl/5.0.8

fslreorient2std T1/T1.nii.gz FSL/T1/T1_reorient.nii.gz
bet FSL/T1/T1_reorient.nii.gz FSL/T1/T1_brain.nii.gz -f .1 -B -R
feat rs_melodic.fsf
feat hs_feat.fsf
date

#!/bin/bash
#SBATCH --account=<group>
#SBATCH --qos=<group>
#SBATCH --job-name=freesurfer
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=<email_associated_with_hipergator_account>
#SBATCH --ntasks=1
#SBATCH --mem=6gb
#SBATCH --time=12:00:00
#SBATCH --output=freesurfer_%j.out
pwd; hostname; date
 
module load freesurfer/6.0.0

export SUBJECTS_DIR=./

recon-all -s INDV_SUBJECTID -hippocampal-subfields-T1 -brainstem-structures

date

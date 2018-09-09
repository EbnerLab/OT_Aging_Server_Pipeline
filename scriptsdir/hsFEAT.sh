#!/bin/bash
#SBATCH --account=<group>
#SBATCH --qos=<group>
#SBATCH --job-name=bet_melodic_feat
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=<email_associated_with_hipergator_account>
#SBATCH --ntasks=1
#SBATCH --mem=4gb
#SBATCH --time=12:00:00
#SBATCH --output=bet_melodic_feat_%j.out
pwd; hostname; date

module load fsl/5.0.11

feat hsFEAT.fsf
date

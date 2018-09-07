#!/bin/bash
#SBATCH --account=camctrp
#SBATCH --qos=camctrp-b
#SBATCH --job-name=bedpostx
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=dgulliford@ufl.edu
#SBATCH --ntasks=1
#SBATCH --mem=5gb
#SBATCH --time=48:00:00
#SBATCH --output=bedpostx_%j.out
pwd; hostname; date
 
module load freesurfer/6.0.0 
module load fsl/5.0.10
 
	bedpostx dmri/

date

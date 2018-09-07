#!/bin/bash
#SBATCH --account=<group>
#SBATCH --qos=<group>
#SBATCH --job-name=bedpostx
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=<email>
#SBATCH --ntasks=1
#SBATCH --mem=5gb
#SBATCH --time=48:00:00
#SBATCH --output=bedpostx_%j.out
pwd; hostname; date
 
module load freesurfer/6.0.0 
module load fsl/5.0.10
 
	bedpostx dmri/

date

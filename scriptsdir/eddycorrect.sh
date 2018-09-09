#!/bin/bash
#SBATCH --account=<group>
#SBATCH --qos=<group>
#SBATCH --job-name=eddycurrent
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=<email>
#SBATCH --ntasks=1
#SBATCH --mem=4gb
#SBATCH --time=4:00:00
#SBATCH --output=eddycurrent_%j.out
pwd; hostname; date

module load freesurfer/6.0.0 
module load fsl/5.0.10
 
    eddy_correct dmri/dwi_orig_las.nii.gz dmri/dwi.nii.gz 0

date

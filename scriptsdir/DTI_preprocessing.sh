#!/bin/bash
#SBATCH --account=camctrp
#SBATCH --qos=camctrp
#SBATCH --job-name=dti_preprocess
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=dgulliford@ufl.edu
#SBATCH --ntasks=1
#SBATCH --mem=8gb
#SBATCH --time=24:00:00
#SBATCH --output=dti_preprocess_%j.out
pwd; hostname; date
 
module load fsl/5.0.8
 
	eddy_correct DTI/FSL/64dir.nii DTI/FSL/64dir_ecc.nii.gz 0
	bet2 DTI/FSL/64dir_ecc DTI/FSL/nodif_brain -f .3 -m
  dtifit -k DTI/FSL/64dir_ecc -o DTI/FSL/dti -m DTI/FSL/nodif_brain_mask.nii.gz -r DTI/FSL/bvecs -b DTI/FSL/bvals
	bedpostx DTI/FSL/
	flirt -in DTI/FSL/nodif_brain -ref FSL/T1/T1_brain.nii -omat DTI/FSL.bedpostX/xfms/diff2str.mat -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12 -cost mutualinfo
	convert_xfm -omat DTI/FSL.bedpostX/xfms/str2diff.mat -inverse DTI/FSL.bedpostX/xfms/diff2str.mat
	flirt -in FSL/T1/T1_brain.nii -ref ../../../../../../apps/fsl/5.0.8/fsl/data/standard/avg152T1_brain -omat DTI/FSL.bedpostX/xfms/str2standard.mat -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12 -cost corratio
	convert_xfm -omat DTI/FSL.bedpostX/xfms/standard2str.mat -inverse DTI/FSL.bedpostX/xfms/str2standard.mat
	convert_xfm -omat DTI/FSL.bedpostX/xfms/diff2standard.mat -concat DTI/FSL.bedpostX/xfms/str2standard.mat DTI/FSL.bedpostX/xfms/diff2str.mat
	convert_xfm -omat DTI/FSL.bedpostX/xfms/standard2diff.mat -inverse DTI/FSL.bedpostX/xfms/diff2standard.mat

date

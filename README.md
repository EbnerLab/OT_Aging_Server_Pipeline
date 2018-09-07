# OT_Aging_Server_Pipeline
This pipeline was developed by Desiree Lussier-Levesque at the University of Florida for the Social-Cognitive and Affective Development Lab. Please ensure that proper credit is given when using data processed with this pipeline. This is the complete pipeline for resting state fMRI melodic independent component analysis, automated structural segmentation and parcellation, Heider Simmel fMRI task, and 64 direction diffusion tensor tractography preprocessing for the OT Aging study conducted in the Social Cognitive and Affective Lab at the University of Florida. Includes slurm commands and instructions for use on UF's Hipergator2.For questions regarding this pipeline, please contact desiree.lussier@ufl.edu

Directions for running pipeline steps:
For each step in pipeline, which should eb run sequentially, edit the subject list to be run at the beginning of each pipeline file where indicated. The first step will also require the visit number, entered as indicated, and pathway to raw data. Individual subject raw data will need to be organized and named in the following way for the script to run properly:

-<subjectID>/
  -T1/
   -T1.nii
  -RS/
   -rsBOLD.nii
  -HS/
   -hsBOLD.nii
  -DTI_dicoms/
   -DICOM/
   -DICOMDIR
  -b0_map_dicoms/
   -DICOM/
   -DICOMDIR

Do not run the second step of the pipeline for a given participant until all components of the previous step have been completed as some are dependant on the data produced, i.e. the automated segmentation and parcellation with Freesurfer 6.0.0 must be completed prior to the processing of the BOLD data may be completed as it is used for registration.

Prior to running individual pipeline steps, the user must change the slurm scripts to indicate their given account name/email in the slurm preamble. Otherwise, these will not have permission to run on the Hipergator. The slurm scripts and resources available to run them are dependant on the permissions granted to the user. Upon completion or failure of a script submitted to the Hipergator processing cores, the user will receive and email indicating the disposition of the slurm job.

Separate files for higher level analyses and extraction of the run data will must be run separately and after completion of all data processing.

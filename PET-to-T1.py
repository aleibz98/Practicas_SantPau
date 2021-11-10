import shutil
import matplotlib.pyplot as plt
import numpy as np
import os
import argparse
from shutil import copyfile
from shutil import rmtree
from nipype.interfaces.freesurfer import BBRegister
from nipype.interfaces.freesurfer import MRICoreg
from nipype.interfaces.freesurfer import ApplyVolTransform
import ants


# Data structures with possible input values for given parameters
metric_values = {'MeanSquares', 'Correlation', 'MattesMutualInformation', 'Demons', 'JointHistogramMutualInformation', 'ANTsNeighborhoodCorrelation'}
method_values = {'bbregister' 'mri-coreg', 'flair'}
init_values = {'spm', 'fsl', 'header', 'rr'}
dof_values = {6,9,12,'elastic'}

# Arparse command line arguments
parser = argparse.ArgumentParser(description='PET-to-T1')
parser.add_argument('--input_dir', '-d', required=True, help='Subjects directory where the FreeSurfer Subjects are stored')
parser.add_argument('--subj_id', '-s', required=True, help='Subject ID to be searched for in the FreeSurfer Directory')
parser.add_argument('--mov', '-m', required=True)
parser.add_argument('--method', choices=method_values, required=True)
parser.add_argument('--init', choices=init_values, default='header')
parser.add_argument('--metric', choices=metric_values, default=metric_values)
parser.add_argument('--dof', type=int, choices=dof_values, default=6)

# Parse command line arguments
input_dir = parser.parse_args().input_dir
subject_name = parser.parse_args().subj_id
PET_path = parser.parse_args().mov
method = parser.parse_args().method
init = parser.parse_args().init
metrics = parser.parse_args().metric
dof = parser.parse_args().dof

# Set the output filename
output_filename = subject_name + '_' + method + '_' + init

output_path = '/home/student/Practicas/Practicas_SantPau/outs'

# Generate the output filestructure
os.makedirs(output_path,exist_ok=True)
os.makedirs(os.path.join(output_path, subject_name), exist_ok=True)

# Check if the transformation matrix exists
if not os.path.exists( output_path, 'PET-TAU', method, 'transforms', output_filename + '_fwd.mat')):
    # In the event we can't find the transform matrix, we should delete the ANTS directory and regenerate it
    rmtree(os.path.join(output_path, subject_name, 'PET-TAU', method), ignore_errors=True)
    os.makedirs(os.path.join(output_path, subject_name, 'PET-TAU'), exist_ok=True)
    os.makedirs(os.path.join(output_path, subject_name, 'PET-TAU', method))
    os.makedirs(os.path.join(output_path, subject_name, 'PET-TAU', method, 'orig'))
    os.makedirs(os.path.join(output_path, subject_name, 'PET-TAU', method, 'transforms'))
    os.makedirs(os.path.join(output_path, subject_name, 'PET-TAU', method, 'orig-in-t1'))
    os.makedirs(os.path.join(output_path, subject_name, 'PET-TAU', method, 'QC'))
    os.makedirs(os.path.join(output_path, subject_name, 'PET-TAU', method, 'T1-std'))

else:
    print('Transformation matrix found, skipping ANTS registration')


# Save the PET image in orig
shutil.copyfile(PET_path, os.path.join(output_path, subject_name, 'PET-TAU', method, 'orig', subject_name + '_PET.nii.gz'))

# Save the T1 image in orig
T1_path = os.path.join(output_path, subject_name, 'PET-TAU', method, 'orig', subject_name + '_T1.mgz')
shutil.copyfile(os.path.join(input_dir, subject_name, 'mri', 'T1.mgz'), T1_path)

# TODO: Copy the T1-to-std files into T1_std (SOFTLINK)


# Set and run the registration
if method == 'bbregister':
    bbreg = BBRegister()
    bbreg.inputs.subject_id = subject_name
    bbreg.inputs.subjects_dir = input_dir
    bbreg.input.contrast_type = 't1' # We are supposing a t1 contrast
    bbreg.inputs.init = init
    bbreg.inputs.source_file = PET_path
    bbreg.inputs.out_lta_file = os.path.join(output_path, subject_name, 'PET-TAU', method, 'transforms', output_filename + '.lta')
    bbreg.inputs.d
    bbreg.run()

elif method == 'mri-coreg':
    coreg = MRICoreg()
    coreg.inputs.source_file = PET_path
    coreg.inputs.reference_file = T1_path
    coreg.inputs.out_lta_file = os.path.join(output_path, subject_name, 'PET-TAU', method, 'transforms', output_filename + '.lta')
    coreg.run()

elif method == 'flirt':
    pass


# Generate transformation for QC
apply_transform = ApplyVolTransform()
apply_transform.inputs.source_file = PET_path
apply_transform.inputs.lta_file = os.path.join(output_path, subject_name, 'PET-TAU', method, 'transforms', output_filename + '.lta')                        # Fijamos la matriz de transformacion (output de bbregister)
apply_transform.inputs.target_file = T1_path       # Fijamos la imagen fija (T1). Importante: No es la original, es la que genera recon-all.
apply_transform.inputs.transformed_file = os.path.join(output_path, subject_name, 'PET-TAU', method, 'transforms', output_filename + 'PET-to-T1.nii')     # Guardamos la imagen transformada
apply_transform.run()

# Generate transformation for QC
# Load images
T1 = ants.image_read(T1_path)
PETintoT1 = ants.image_read(os.path.join(output_path, subject_name, 'PET-TAU', method, 'transforms', output_filename + 'PET-to-T1.nii'))

# Save first QC image
ants.plot(T1, overlay=PETintoT1, overlay_cmap='hot', overlay_alpha=0.5, filename=os.path.join(output_path, subject_name, 'PET-TAU', method, 'QC', output_filename + '_reg_image.png'))

# Get CSF
mask = ants.get_mask(T1)
segs = ants.kmeans_segmentation(T1, k=3, kmask=mask)
mask_CSF = ants.threshold_image(PETintoT1, 0.05) # Podemos jugar un poco con el threshold
ants.plot(PETintoT1, overlay=mask_CSF, overlay_cmap='jet', overlay_alpha=1, filename=os.path.join(output_path, subject_name, 'PET-TAU', method, 'QC', output_filename + '_QC.png'))

# Use ANTsPy to generate the metrics and save the results
metric_val = dict()
for metric in metrics:
    if metric not in metric_values:
        # Metric not found, skip
        print('Metric ' + metric + ' not found, skipping')
        continue
    metric_val[metric] = ants.image_similarity(fixed_image=T1, moving_image=PETintoT1, metric_type=metric)

# Save the metric values
metric_file = open(os.path.join(output_path, subject_name, 'PET-TAU', method, 'QC', output_filename + '_metrics'), 'w')
metric_file.write('Metric\tValue\n')
for metric in metric_val:
    metric_file.write(metric + '\t' + str(metric_val[metric]) + '\n')
metric_file.close()



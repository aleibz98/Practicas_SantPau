import ants
import matplotlib.pyplot as plt
import numpy as np
import os
import sys
import argparse
import re
from shutil import copyfile
from shutil import rmtree

# Data structures with possible input values for given parameters
metric_values = {'MeanSquares', 'Correlation', 'MattesMutualInformation', 'Demons', 'JointHistogramMutualInformation', 'ANTsNeighborhoodCorrelation'}
method_values = {'Translation', 'Rigid', 'Similarity', 'QuickRigid', 'DenseRigid', 'BOLDRigid',
                    'Affine', 'AffineFast', 'BOLDAffine', 'TRSAA', 'ElasticSyN', 'SyN', 'SyNRA',
                    'SyNOnly', 'SyNCC', 'SyNabp', 'SyNBold', 'SyNBoldAff', 'SyNAggro', 'TVMSQ', 'TVMSQC'}
init_values = {'Buena suerte para econtrarlos jaja'}

# Argparse command line arguments
parser = argparse.ArgumentParser(description='T1-to-Std_ANTS')
parser.add_argument('--t1', required=True)
parser.add_argument('--metric', nargs='+', choices=metric_values, default=metric_values)
parser.add_argument('--method', choices=method_values, default='SyNCC') 
parser.add_argument('--brain', action='store_true', default=False)
parser.add_argument('--init', default='', choices=init_values)

# Setup variables and directories
#FS_path = '/usr/pubsw/packages/fsl/fsl-6.0.5/data/standard'
FS_env = os.environ.get('FREESURFER_HOME')
FS_path = os.path.join(FS_env,'/data/standard')
StdTemplate_path = os.path.join(FS_path, 'MNI152_T1_2mm.nii.gz') #Must be a MNI152 template (FS dir)
StdBrainTemplate_path = os.path.join(FS_path, 'MNI152_T1_2mm_brain.nii.gz') #Must be a MNI152 template (FS dir)

# Parse agments
T1_path = parser.parse_args().t1
metrics = parser.parse_args().metric
method = parser.parse_args().method
brain = parser.parse_args().brain
init = parser.parse_args().init

# Get subject name
tmp = re.split('/|_', T1_path)
subject_name = [elem for elem in tmp if 'sub-' in elem][0]

# Output filename
if brain:
    output_filename = subject_name + '_brain_' + method
else:
    output_filename = subject_name + '_' + method

output_path = os.environ.get('OUT_PATH')
#output_path = '/home/student/Practicas/Practicas_SantPau/outs'

# Generate the output filestructure
os.makedirs(output_path,exist_ok=True)
os.makedirs(os.path.join(output_path, subject_name), exist_ok=True)

# Check if the transformation matrix exists
if not os.path.exists(os.path.join(output_path, subject_name, 'T1', 'ANTS', 'transforms', output_filename + '_fwd.mat')):
    # In the event we can't find the transform matrix, we should delete the ANTS directory and regenerate it
    rmtree(os.path.join(output_path, subject_name, 'T1', 'ANTS'), ignore_errors=True)
    os.makedirs(os.path.join(output_path, subject_name, 'T1'), exist_ok=True)   
    os.makedirs(os.path.join(output_path, subject_name, 'T1', 'ANTS'))
    os.makedirs(os.path.join(output_path, subject_name, 'T1', 'ANTS', 'orig'))
    os.makedirs(os.path.join(output_path, subject_name, 'T1', 'ANTS', 'transforms'))
    os.makedirs(os.path.join(output_path, subject_name, 'T1', 'ANTS', 'orig-in-std'))
    os.makedirs(os.path.join(output_path, subject_name, 'T1', 'ANTS', 'QC'))
    os.makedirs(os.path.join(output_path, subject_name, 'T1', 'ANTS', 'atlas'))
else:
    print('Transformation matrix found, skipping ANTS registration')
    sys.exit(0) #TODO: Hacemos el sys.exit(0) directamente o que?

# Load the necessary files
T1 = ants.image_read(T1_path)

# Save the T1 image
T1.to_file(os.path.join(output_path, subject_name, 'T1', 'ANTS', 'orig', 'T1.nii.gz'))


if brain:
    StdTemplate = ants.image_read(StdBrainTemplate_path)
else:
    StdTemplate = ants.image_read(StdTemplate_path)

# Perform registration
registered_image = ants.registration(
    fixed=StdTemplate, 
    moving=T1, 
    type_of_transform=method
    )

# Registration plot
ants.plot(StdTemplate, overlay=registered_image['warpedmovout'], overlay_cmap='hot', overlay_alpha=0.5, filename=os.path.join(output_path, subject_name, 'T1', 'ANTS', 'QC', output_filename + '_reg_image.png'))

#Save registration files
registered_image['warpedmovout'].to_file(os.path.join(output_path, subject_name, 'T1', 'ANTS', 'orig-in-std', output_filename + '_reg.nii.gz'))

if len(registered_image['fwdtransforms']) == 1: # Non-elastic transformation
    copyfile(registered_image['fwdtransforms'][0], os.path.join(output_path, subject_name, 'T1', 'ANTS', 'transforms', output_filename + '_fwd.mat'))
    copyfile(registered_image['invtransforms'][0], os.path.join(output_path, subject_name, 'T1', 'ANTS', 'transforms', output_filename + '_inv.mat'))
else: # Elastic transformation
    copyfile(registered_image['fwdtransforms'][0], os.path.join(output_path, subject_name, 'T1', 'ANTS', 'transforms', output_filename + '_fwd.nii.gz'))
    copyfile(registered_image['invtransforms'][0], os.path.join(output_path, subject_name, 'T1', 'ANTS', 'transforms', output_filename + '_inv.nii.gz'))
    copyfile(registered_image['fwdtransforms'][1], os.path.join(output_path, subject_name, 'T1', 'ANTS', 'transforms', output_filename + '_fwd.mat'))
    copyfile(registered_image['invtransforms'][1], os.path.join(output_path, subject_name, 'T1', 'ANTS', 'transforms', output_filename + '_inv.mat'))


# Get CSF
mask = ants.get_mask(StdTemplate)
segs = ants.kmeans_segmentation(StdTemplate, k=3, kmask=mask)
mask_CSF = ants.threshold_image(segs['probabilityimages'][0], 0.05) # Podemos jugar un poco con el threshold
ants.plot(registered_image['warpedmovout'], overlay=mask_CSF, overlay_cmap='jet', overlay_alpha=1, filename=os.path.join(output_path, subject_name, 'T1', 'ANTS', 'QC', output_filename + '_QC.png'))

# Compute the metrics and save them
metric_val = dict()
for metric in metrics:
    if metric not in metric_values:
        # Metric not found, skip
        print('Metric ' + metric + ' not found, skipping')
        continue
    metric_val[metric] = ants.image_similarity(fixed_image=StdTemplate, moving_image=registered_image['warpedmovout'], metric_type=metric)

# Save the metric values
metric_file = open(os.path.join(output_path, subject_name, 'T1', 'ANTS', 'QC', output_filename + '_metrics'), 'w')
metric_file.write('Metric\tValue\n')
for metric in metric_val:
    metric_file.write(metric + '\t' + str(metric_val[metric]) + '\n')
metric_file.close()

# Copiaremos el atlas del sujeto fsl a la carpeta de outputs para facilitar procesos posteriores
atlas_src = os.path.join(os.environ.get('SUBJECTS_DIR'), [elem for elem in os.listdir(os.environ.get('SUBJECTS_DIR')) if subject_name in elem][0], 'mri', 'aparc+aseg.mgz')
atlas_dst = os.path.join(output_path, subject_name, 'T1', 'ANTS' 'atlas', 'atlas.mgz')
copyfile(atlas_src, atlas_dst)


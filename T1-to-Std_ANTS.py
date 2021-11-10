import ants
import matplotlib.pyplot as plt
import numpy as np
import os
import argparse
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
# Argmuemnt metric should accept more than one value
parser.add_argument('--metric', nargs='+', choices=metric_values, default=metric_values)
parser.add_argument('--method', choices=[], default='SyN') 
parser.add_argument('--brain', action='store_true', default=False)
parser.add_argument('--init', default='', choices=init_values)

# Setup variables and directories
FS_path = '/usr/pubsw/packages/fsl/fsl-6.0.5/data/standard'
StdTemplate_path = os.path.join(FS_path, 'MNI152_T1_2mm.nii.gz') #Must be a MNI152 template (FS dir)
StdBrainTemplate_path = os.path.join(FS_path, 'MNI152_T1_2mm_brain.nii.gz') #Must be a MNI152 template (FS dir)

# Parse agments
T1_path = parser.parse_args().t1
metrics = parser.parse_args().metric
method = parser.parse_args().method
brain = parser.parse_args().brain
init = parser.parse_args().init

# Get subject name
tmp = T1_path.split('/')
subject_name = [elem for elem in tmp if 'sub-' in elem][0]


# Output filename
if brain:
    output_filename = subject_name + '_brain_' + '_' + method
else:
    output_filename = subject_name + '_' + '_' + method

output_path = '/home/student/Practicas/Practicas_SantPau/outs'

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
    os.makedirs(os.path.join(output_path, subject_name, 'T1', 'ANTS', 'std'))
    os.makedirs(os.path.join(output_path, subject_name, 'T1', 'ANTS', 'QC'))

else:
    print('Transformation matrix found, skipping ANTS registration')



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
registered_image['warpedmovout'].to_file(os.path.join(output_path, subject_name, 'T1', 'ANTS', 'std', output_filename + '_reg.nii.gz'))

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
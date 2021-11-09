import ants
import matplotlib.pyplot as plt
import numpy as np
import os
import argparse

# Data structures with possible input values for given parameters
metric_values = {'MeanSquares', 'Correlation', 'MattesMutualInformation', 'Demons', 'JointHistogramMutualInformation', 'ANTsNeighborhoodCorrelation'}
method_values = {'Translation', 'Rigid', 'Similarity', 'QuickRigid', 'DenseRigid', 'BOLDRigid',
                    'Affine', 'AffineFast', 'BOLDAffine', 'TRSAA', 'ElasticSyN', 'SyN', 'SyNRA',
                    'SyNOnly', 'SyNCC', 'SyNabp', 'SyNBold', 'SyNBoldAff', 'SyNAggro', 'TVMSQ', 'TVMSQC'}
init_values = {'Buena suerte para econtrarlos jaja'}

# Argparse command line arguments
parser = argparse.ArgumentParser(description='T1-to-Std_ANTS')
parser.add_argument('--t1', required=True)
parser.add_argument('--metric', choices=metric_values, default='all')
parser.add_argument('--method', choices=[], default='SyN') 
parser.add_argument('--brain', action='store_true', default=False)
parser.add_argument('--init', default='rr', choices=init_values)

# Setup variables and directories
FS_path = '/usr/pubsw/packages/fsl/fsl-6.0.5/data/standard'
StdTemplate_path = os.path.join(FS_path, 'MNI152_T1_2mm.nii.gz') #Must be a MNI152 template (FS dir)
StdBrainTemplate_path = os.path.join(FS_path, 'MNI152_T1_2mm_brain.nii.gz') #Must be a MNI152 template (FS dir)

# Parse agments
T1_path = parser.parse_args().t1
metric = parser.parse_args().metric
method = parser.parse_args().method
brain = parser.parse_args().brain
init = parser.parse_args().init

# Get subject name
#subject_name = [x for x in re.split('/|_|.',T1_path) if 'sub-' in x][0]
tmp = T1_path.split('/')
subject_name = [elem for elem in tmp if 'sub-' in elem][0]


# Output filename
if brain:
    output_filename = subject_name + '_brain_' + metric + '_' + method
else:
    output_filename = subject_name + '_' + metric + '_' + method

output_path = '/home/student/Practicas/Practicas_SantPau/outs'

# Generate the output filestructure
# TODO: Check if the output directory exists
# TODO: Check if the subject directory exists
# TODO: Check if the transformation matrix exists
os.makedirs(os.path.join(output_path, subject_name))
os.makedirs(os.path.join(output_path, subject_name, 'T1'))
os.makedirs(os.path.join(output_path, subject_name, 'T1', 'ANTS'))
os.makedirs(os.path.join(output_path, subject_name, 'T1', 'ANTS', 'orig'))
os.makedirs(os.path.join(output_path, subject_name, 'T1', 'ANTS', 'transforms'))
os.makedirs(os.path.join(output_path, subject_name, 'T1', 'ANTS', 'std'))
os.makedirs(os.path.join(output_path, subject_name, 'T1', 'ANTS', 'QC'))


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

#TODO: We can't assume that the transform will be elastic
os.popen('cp ' + registered_image['fwdtransforms'][0] + ' ' + os.path.join(output_path, subject_name, 'T1', 'ANTS', 'transforms', output_filename + '_fwd.nii.gz'))
os.popen('cp ' + registered_image['fwdtransforms'][1] + ' ' + os.path.join(output_path, subject_name, 'T1', 'ANTS', 'transforms', output_filename + '_fwd.mat'))

os.popen('cp ' + registered_image['invtransforms'][0] + ' ' + os.path.join(output_path, subject_name, 'T1', 'ANTS', 'transforms', output_filename + '_inv.nii.gz'))
os.popen('cp ' + registered_image['invtransforms'][1] + ' ' + os.path.join(output_path, subject_name, 'T1', 'ANTS', 'transforms', output_filename + '_inv.mat'))


# Get CSF
mask = ants.get_mask(StdTemplate)
segs = ants.kmeans_segmentation(StdTemplate, k=3, kmask=mask)
mask_CSF = ants.threshold_image(segs['probabilityimages'][0], 0.05) # Podemos jugar un poco con el threshold
ants.plot(registered_image['warpedmovout'], overlay=mask_CSF, overlay_cmap='jet', overlay_alpha=1, filename=os.path.join(output_path, subject_name, 'T1', 'ANTS', 'QC', output_filename + '_QC.png'))


possible_metrics = {'MeanSquares', 'Correlation', 'MattesMutualInformation', 'Demons', 'JointHistogramMutualInformation', 'ANTsNeighborhoodCorrelation'}
metric_val = dict()
for metric in possible_metrics:
    metric_val[metric] = ants.image_similarity(fixed_image=StdTemplate, moving_image=registered_image['warpedmovout'], metric_type=metric)

# Save the metric values
metric_file = open(os.path.join(output_path, subject_name, 'T1', 'ANTS', 'QC', output_filename + '_metrics'), 'w')
metric_file.write('Metric\tValue\n')
for metric in metric_val:
    metric_file.write(metric + '\t' + str(metric_val[metric]) + '\n')
metric_file.close()
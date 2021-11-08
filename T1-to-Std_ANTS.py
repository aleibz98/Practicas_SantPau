import ants
import matplotlib.pyplot as plt
import numpy as np
import os
import argparse

# Argparse command line arguments
parser = argparse.ArgumentParser(description='T1-to-Std_ANTS')
parser.add_argument('--t1', )
parser.add_argument('--metric', )
parser.add_argument('--method', )
parser.add_argument('--brain', action='store_true')

# Setup variables and directories
FS_path = '/usr/pubsw/packages/fsl/fsl-6.0.5/data/standard'
StdTemplate_path = os.path.join(FS_path, 'MNI152_T1_2mm.nii.gz') #Must be a MNI152 template (FS dir)
StdBrainTemplate_path = os.path.join(FS_path, 'MNI152_T1_2mm_brain.nii.gz') #Must be a MNI152 template (FS dir)

# Parse agments
T1_path = parser.parse_args().subjdir
metric = parser.parse_args().metric
method = parser.parse_args().method
brain = parser.parse_args().brain

# Load the necessary files
T1 = ants.image_read(T1_path)

if brain:
    StdTemplateBrain = ants.image_read(StdBrainTemplate_path)
else:
    StdTemplate = ants.image_read(StdTemplate_path)

# Perform registration
registered_image = ants.registration(
    fixed=StdTemplate, 
    moving=T1, 
    type_of_transform=method
    )

# Registration plot
ants.plot(StdTemplate, overlay=registered_image['warpedmovout'], overlay_cmap='hot', overlay_alpha=0.5)
plt.show()

# Get CSF
mask = ants.get_mask(StdTemplate)
segs = ants.kmeans_segmentation(StdTemplate, k=3, kmask=mask)
mask_CSF = ants.threshold_image(segs['probabilityimages'][0], 0.05) # Podemos jugar un poco con el threshold
ants.plot(registered_image['warpedmovout'], overlay=mask_CSF, overlay_cmap='jet', overlay_alpha=1)
plt.show()

possible_metrics = {'MeanSquares', 'Correlation', 'MattesMutualInformation', 'Demons', 'JointHistogramMutualInformation', 'ANTsNeighborhoodCorrelation'}
metric_val = dict()
for metric in possible_metrics:
    metric_val[metric] = ants.image_similarity(fixed_image=StdTemplate, moving_image=registered_image['warpedmovout'], metric_type=metric)

print(metric_val)
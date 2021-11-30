import shutil
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import os
import argparse
from shutil import copyfile
from shutil import rmtree
from nipype.interfaces.freesurfer import ApplyVolTransform
import ants

# llamada ejemplo bbregister: python PET-to-T1.py --method bbregister --dof 6 --init rr -m /home/student/Practicas/Practicas_SantPau/primeras_pruebas_freesurfer/data/co-registre_PET-TAU/sub-003S6257/sub-003S6257_ses-m00_AV1451.nii -s sub-003S6257 -d /home/student/Practicas/Practicas_SantPau/primeras_pruebas_freesurfer/data/out_recon-all
# llamada ejemplo mri-coreg: python PET-to-T1.py --method mri-coreg --dof 6 -m /home/student/Practicas/Practicas_SantPau/primeras_pruebas_freesurfer/data/co-registre_PET-TAU/sub-003S6257/sub-003S6257_ses-m00_AV1451.nii -s sub-003S6257 -d /home/student/Practicas/Practicas_SantPau/primeras_pruebas_freesurfer/data/out_recon-all

# Data structures with possible input values for given parameters
metric_values = {'MeanSquares', 'Correlation', 'MattesMutualInformation', 'Demons', 'JointHistogramMutualInformation', 'ANTsNeighborhoodCorrelation'}
method_values = {'bbregister', 'mri-coreg', 'flair'}
init_values = {'spm', 'fsl', 'coreg', 'rr'}
dof_values = {'6' ,'9' ,'12'}

# Arparse command line arguments
parser = argparse.ArgumentParser(description='PET-to-T1')
parser.add_argument('--input_dir', '-d', required=True, help='Subjects directory where the FreeSurfer Subjects are stored')
parser.add_argument('--subj_id', '-s', required=True, help='Subject ID to be searched for in the FreeSurfer Directory')
parser.add_argument('--mov', '-m', required=True)
parser.add_argument('--method', choices=method_values, required=True)
parser.add_argument('--init', choices=init_values, default='header')
parser.add_argument('--metric', choices=metric_values, default=metric_values)
parser.add_argument('--dof', choices=dof_values, default=6)

# Parse command line arguments
input_dir = parser.parse_args().input_dir
subject_name = parser.parse_args().subj_id
PET_path = parser.parse_args().mov
method = parser.parse_args().method
init = parser.parse_args().init
metrics = parser.parse_args().metric
dof = parser.parse_args().dof

# Set the output filename and other variables
if method == 'bbregister':
    output_filename = subject_name + '_' + method + '_' + init + '_' + dof + 'dof'
elif method == 'mri-coreg':
    output_filename = subject_name + '_' + method + '_' + dof + 'dof'
elif method == 'flair':
    output_filename = subject_name + '_' + method
else:
    print('Method not recognized')

output_path = '/home/student/Practicas/Practicas_SantPau/outs'
os.environ['SUBJECTS_DIR'] = input_dir

# Generate the output filestructure
os.makedirs(output_path,exist_ok=True)
os.makedirs(os.path.join(output_path, subject_name), exist_ok=True)

# Check if the transformation matrix exists
if not os.path.exists(os.path.join(output_path, 'PET-TAU', method, 'transforms', output_filename + '_fwd.mat')):
    # In the event we can't find the transform matrix, we should delete the ANTS directory and regenerate it
    #rmtree(os.path.join(output_path, subject_name, 'PET-TAU', method), ignore_errors=True)
    os.makedirs(os.path.join(output_path, subject_name, 'PET-TAU'), exist_ok=True)
    os.makedirs(os.path.join(output_path, subject_name, 'PET-TAU', method), exist_ok=True)
    os.makedirs(os.path.join(output_path, subject_name, 'PET-TAU', 'orig'), exist_ok=True)
    os.makedirs(os.path.join(output_path, subject_name, 'PET-TAU', method, 'transforms'), exist_ok=True)
    os.makedirs(os.path.join(output_path, subject_name, 'PET-TAU', method, 'PET-to-T1std'), exist_ok=True)
    os.makedirs(os.path.join(output_path, subject_name, 'PET-TAU', method, 'QC'), exist_ok=True)
    os.makedirs(os.path.join(output_path, subject_name, 'PET-TAU', method, 'stats'), exist_ok=True)

else:
    print('Transformation matrix found, skipping ANTS registration')


# Save the PET image in orig
shutil.copyfile(PET_path, os.path.join(output_path, subject_name, 'PET-TAU', 'orig', subject_name + '_PET.nii.gz'))

# Save the T1 image in orig
T1_path = os.path.join(output_path, subject_name, 'PET-TAU', 'orig', subject_name + '_T1.mgz')
shutil.copyfile(os.path.join(input_dir, subject_name, 'mri', 'T1.mgz'), T1_path)

src = os.path.join(output_path, subject_name, 'T1', 'ANTS')
dst = os.path.join(output_path, subject_name, 'PET-TAU', 'T1-std')
try:
    os.symlink(src, dst, target_is_directory=True)
except FileExistsError:
    pass

call = ''
# Set and run the registration
if method == 'bbregister':
    out_lta = os.path.join(output_path, subject_name, 'PET-TAU', method, 'transforms', output_filename + '.lta')
    call = 'bbregister --s ' + subject_name + ' --mov ' + PET_path + ' --lta ' + out_lta + ' --t1 ' + '--init-' + init + ' --' + dof
    print(call)

elif method == 'mri-coreg':
    out_lta = os.path.join(output_path, subject_name, 'PET-TAU', method, 'transforms', output_filename + '.lta')
    call = 'mri_coreg --mov ' + PET_path + ' --lta ' + out_lta + ' --ref ' + T1_path + ' --dof ' + dof
    print(call)

elif method == 'flirt':
    pass

# Execute call
os.system(call) #TODO: cambiar por subprocess

# Generate transformation for QC
apply_transform = ApplyVolTransform()
apply_transform.inputs.source_file = PET_path
apply_transform.inputs.lta_file = os.path.join(output_path, subject_name, 'PET-TAU', method, 'transforms', output_filename + '.lta')                        # Fijamos la matriz de transformacion (output de bbregister)
apply_transform.inputs.target_file = T1_path       # Fijamos la imagen fija (T1). Importante: No es la original, es la que genera recon-all.
apply_transform.inputs.transformed_file = os.path.join(output_path, subject_name, 'PET-TAU', method, 'transforms', output_filename + '_PET-to-T1.nii')     # Guardamos la imagen transformada
apply_transform.run()

# Generate transformation for QC
# Load images
T1 = ants.image_read(T1_path)
PETintoT1 = ants.image_read(os.path.join(output_path, subject_name, 'PET-TAU', method, 'transforms', output_filename + '_PET-to-T1.nii'))

# Save first QC image
thresholded_PET = ants.threshold_image(PETintoT1, 1500)
ants.plot(T1, overlay=thresholded_PET, overlay_cmap='jet', overlay_alpha=0.5, filename=os.path.join(output_path, subject_name, 'PET-TAU', method, 'QC', output_filename + '_reg_image.png'))

# Get CSF
#ants.plot(PETintoT1, overlay=mask_CSF, overlay_cmap='jet', overlay_alpha=1, filename=os.path.join(output_path, subject_name, 'PET-TAU', method, 'QC', output_filename + '_QC.png'))


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



# Cargar el atlas FSL
# Copiar el atlas a orig
#/home/student/Practicas/Practicas_SantPau/primeras_pruebas_freesurfer/data/FTD-FPD109/mri/aparc+aseg.mgz
atlas_path = ""
atlas = ants.image_read(atlas_path)

# Añadir como parametro que ROIs se quieren usar
ROIs = []

# Crear la máscara de las ROIS en la imagen PET
def get_ROI(atlas, list_ROIs):
    ROI = [ (x in list_ROIs) for x in atlas.reshape(-1)]
    ROI = np.array(ROI)
    return ROI.reshape(atlas.shape)

ROI_mask = get_ROI(atlas, ROIs)

df_intensities = pd.DataFrame(atlas.reshape(-1), columns=['tags'])
df_intensities['PET_intensities'] = PETintoT1.reshape(-1)
df_intensities['mask'] = ROI_mask.reshape(-1)

# Computar la media de las ROIS
mean_ROI_intensity = df_intensities["mask" == True].mean()

# Normalizar la imagen PET con la media de las ROIS
df_intensities['scaled_PET_intensities'] = df_intensities['PET_intensities'] / mean_ROI_intensity

# Guardar las imágenes normalizadas
normalised_PET = df_intensities['scaled_PET_intensities'].values.reshape(PETintoT1.shape)
ants.image_write(normalised_PET, os.path.join(output_path, subject_name, 'PET-TAU', method, 'transforms', output_filename + '_PET_to_T1_scaled.nii.gz'))

# Generar la imagen de QC con la PET escalada
thresholded_PET = ants.threshold_image(normalised_PET, 1)
ants.plot(T1, overlay=thresholded_PET, overlay_cmap='jet', overlay_alpha=0.5, filename=os.path.join(output_path, subject_name, 'PET-TAU', method, 'QC', output_filename + '_reg_image_scaled.png'))

# Guardar en un csv los valores de las intensidades de las ROIs
df_intensities.to_csv(os.path.join(output_path, subject_name, 'PET-TAU', method, 'stats', output_filename + '_stats.csv'))
with open('media_intensidades_roi.csv', 'w') as out:
    df_intensities.groupby('tags').mean().to_csv(out)

#LO DEBERIA IR PROBANDO CON UN ipynb
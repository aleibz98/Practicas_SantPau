import shutil
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import os
import sys
import argparse
from shutil import copyfile
from shutil import rmtree
from nipype.interfaces.freesurfer import ApplyVolTransform
import ants

# llamada ejemplo bbregister: python PET-to-T1.py --method bbregister --dof 6 --init rr -m /home/student/Practicas/Practicas_SantPau/primeras_pruebas_freesurfer/data/co-registre_PET-TAU/sub-003S6257/sub-003S6257_ses-m00_AV1451.nii -s sub-003S6257 -d /home/student/Practicas/Practicas_SantPau/primeras_pruebas_freesurfer/data/out_recon-all
# llamada ejemplo mri-coreg: python PET-to-T1.py --method mri-coreg --dof 6 -m /home/student/Practicas/Practicas_SantPau/primeras_pruebas_freesurfer/data/co-registre_PET-TAU/sub-003S6257/sub-003S6257_ses-m00_AV1451.nii -s sub-003S6257 -d /home/student/Practicas/Practicas_SantPau/primeras_pruebas_freesurfer/data/out_recon-all

# Data structures with possible input values for given parameters
metric_values = {'MeanSquares', 'Correlation', 'MattesMutualInformation', 'Demons', 'JointHistogramMutualInformation', 'ANTsNeighborhoodCorrelation'}
method_values = {'bbregister', 'mri-coreg', 'flair'} #añadir vvregister
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

#output_path = '/home/student/Practicas/Practicas_SantPau/outs'
output_path = os.environ.get('OUT_PATH')
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
    sys.exit(0)


# Save the PET image in orig
shutil.copyfile(PET_path, os.path.join(output_path, subject_name, 'PET-TAU', 'orig', subject_name + '_PET.nii.gz'))

# Save the T1 image in orig
T1_path = os.path.join(output_path, subject_name, 'PET-TAU', 'orig', subject_name + '_T1.mgz')
shutil.copyfile(os.path.join(input_dir, [elem for elem in os.listdir(input_dir) if subject_name in elem][0], 'mri', 'T1.mgz'), T1_path)

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
    call = ['bbregister', 
            '--s', subject_name, 
            '--mov', PET_path, 
            '--lta', out_lta, 
            '--t1', 
            '--init-' + init, 
            '--' + dof]

    call = 'samrun -c \"' + " ".join(call) + '\"' 

elif method == 'mri-coreg':
    out_lta = os.path.join(output_path, subject_name, 'PET-TAU', method, 'transforms', output_filename + '.lta')
    call = ['mri_coreg',
            '--mov', PET_path,
            '--lta', out_lta,
            '--ref', T1_path,
            '--dof', dof]
    
    call = 'samrun -c \"' + " ".join(call) + '\"' 

elif method == 'flirt':
    pass

elif method == 'vvregister':
    pass

# Execute call
os.system(call)

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
# Path del atlas dentro del sujeto fsl
atlas_path = os.path.join(output_path, subject_name, 'T1', 'ANTS' 'atlas', 'atlas.mgz')
atlas = ants.image_read(atlas_path)

# Añadir como parametro que ROIs se quieren usar para el atlas Desikan
ROIs = [6,47] # 6: Cerebellum, 47: Cerebellum

# Crear la máscara de las ROIS en la imagen PET
def get_ROI(atlas, list_of_ROIs):
    mask = [ (x in list_of_ROIs) for x in atlas.numpy().reshape(-1)]
    mask = np.array(mask).reshape(atlas.shape)
    return mask

ROI_mask = get_ROI(atlas, ROIs)
df_intensities = pd.DataFrame(atlas.numpy().flatten(), columns=["tags"])
df_intensities["PET_intensities"] = PETintoT1.numpy().flatten()
df_intensities["ROIs_mask"] = ROI_mask.flatten()

# Computar la media de las ROIS
mean_ROI_intensity = df_intensities.groupby("ROIs_mask").mean()
mean_ROI_intensity = mean_ROI_intensity.reset_index()
mean_ROI_intensity = mean_ROI_intensity["PET_intensities"][1]

# Normalizar la imagen PET con la media de las ROIS
df_intensities["scaled_PET_intensity"] = df_intensities["PET_intensities"] / mean_ROI_intensity
scaled_PET = ants.from_numpy(df_intensities["scaled_PET_intensity"].values.reshape(atlas.shape), spacing=PETintoT1.spacing, direction=PETintoT1.direction, origin=PETintoT1.origin)

# Guardar las imágenes normalizadas
scaled_PET_path = os.path.join(output_path, subject_name, 'PET-TAU', method, 'transforms', output_filename + 'PET-to-T1_scaled.nii')
scaled_PET.save(scaled_PET_path)

# Generar la imagen de QC con la PET escalada
thresholded_PET = ants.threshold_image(scaled_PET, 1)
ants.plot(T1, overlay=thresholded_PET, overlay_cmap='jet', overlay_alpha=0.5, filename=os.path.join(output_path, subject_name, 'PET-TAU', method, 'QC', output_filename + '_reg_image_scaled.png'))

# Guardar en un csv los valores de las intensidades de las ROIs
df_intensities.drop('ROIs_mask', axis=1, inplace=True)
with open(os.path.join(output_path, subject_name, 'PET-TAU', method, 'stats', output_filename + '_stats.csv'), "w") as f:
    df_intensities.groupby("tags").mean().to_csv(f)


# Vamos a hacer en este mismo script las concatenaciones de PET to T1 y T1 to Std

# Crear jerarquia de directorios dentro de PET-TAU > method > PET-to-T1Std
os.makedirs(os.path.join(output_path, subject_name, 
                        'PET-TAU', method, 'PET-to-T1std', 
                        'QC'), exist_ok=True)
os.makedirs(os.path.join(output_path, subject_name, 
                        'PET-TAU', method, 'PET-to-T1std', 
                        'transforms'), exist_ok=True)

# Cargamos las matrices de transformación
# PET-to-T1
tmp = os.path.join(output_path, subject_name, 'PET-TAU', method, 'transforms', output_filename + '.lta')

# Como trabajamos con varias librerias, tenemos que transformar la matriz con el script lta_convert de freesurfer
call = ['lta_convert', 
        '--inlta', tmp, 
        '--outitk', os.path.join(output_path, subject_name, 
                                'PET-TAU', method, 'transforms', 
                                output_filename + '_PET-to-T1.mat'),
        '--src', PET_path,
        '--trg', T1_path]

call = 'samrun -c \"' + " ".join(call) + '\"' 
os.system(call)

PET_to_T1_mat = os.path.join(output_path, subject_name, 
                            'PET-TAU', method, 'transforms', 
                            output_filename + '_PET-to-T1.mat')


# T1-to-Std
T1_to_Std_mat = ""
T1_to_Std_gradmap = ""
tmp = os.path.join(output_path, subject_name, 'PET-TAU', 'T1-std', 'transforms')
if len(os.listdir(tmp)) == 2:
    T1_to_Std_mat = os.listdir(tmp).filter(lambda x: 'fwd' in x)[0]
elif len(os.listdir(tmp)) == 4:
    T1_to_Std_mat = os.listdir(tmp).filter(lambda x: 'fwd.mat' in x)[0]
    T1_to_Std_gradmap = os.listdir(tmp).filter(lambda x: 'fwd.nii.gz' in x)[0]
elif len(os.listdir(tmp)) == 0:
    print('No T1-to-Std transforms found, SHIT')


# Cargar la imagen T1 std template
FS_env = os.environ.get('FREESURFER_HOME')
FS_path = os.path.join(FS_env,'/data/standard')
StdTemplate_path = os.path.join(FS_path, 'MNI152_T1_2mm.nii.gz') #Must be a MNI152 template (FS dir)
StdTemplate = ants.image_read(StdTemplate_path)

PET = ants.image_read(PET_path)

# Transformar la imagen PET a la imagen T1-std
# TODO: tener en cuenta de que no tiene que haber necesariamente un mapa de gradiente
# PET Normal
call = ['antsApplyTransform',
        '-i', PET_path,
        '-o', os.path.join(output_path, subject_name, 'PET-TAU', method, 'PET-to-T1std', output_filename + '_PET-to-T1std.nii.gz'),
        '-r', StdTemplate_path,
        '-t', [T1_to_Std_gradmap, T1_to_Std_mat, PET_to_T1_mat]]

call = 'samrun -c \"' + " ".join(call) + '\"' 
os.system(call)

# PET escalado - en este caso usamos el PET que ya tenemos escalado en espacio T1 subject
call = call = ['antsApplyTransform',
        '-i', scaled_PET_path,
        '-o', os.path.join(output_path, subject_name, 'PET-TAU', method, 'PET-to-T1std', output_filename + '_PET-to-T1std_scaled.nii.gz'),
        '-r', StdTemplate_path,
        '-t', [T1_to_Std_gradmap, T1_to_Std_mat]]

call = 'samrun -c \"' + " ".join(call) + '\"' 
os.system(call)

PETintoStd = ants.image_read(os.path.join(output_path, subject_name, 'PET-TAU', method, 'PET-to-T1std', output_filename + '_PET-to-T1std.nii.gz'))
scaled_PETintoStd = ants.image_read(os.path.join(output_path, subject_name, 'PET-TAU', method, 'PET-to-T1std', output_filename + '_PET-to-T1std_scaled.nii.gz'))

# Escalar la imagen PET en el espacio de la imagen T1-std
centiloid_path = os.path.join('/home/aalarcon/TFG/scripts/voi_CerebGry_2mm.nii') # Determinar donde guardaré el centiloid
centiloid_mask = ants.image_read(centiloid_path)

# Calculamos la media del centilod
mean_ROI_intensity_std = [x for x,y in zip(PETintoStd, centiloid_mask) if y == 1].average()


# Normalizar la imagen PET con la media de las ROIS
scaled_PET_inStd = PETintoStd.flatten() / mean_ROI_intensity_std
scaled_PET_inStd = ants.from_numpy(scaled_PETintoStd.reshape(StdTemplate.shape), spacing=StdTemplate.spacing, direction=StdTemplate.direction, origin=StdTemplate.origin)

# Guardar las imágenes normalizadas
scaled_PET_inStd_path = os.path.join(output_path, subject_name, 'PET-TAU', method, 'PET-to-T1std', 'transforms', output_filename + 'PET-to-Std_scaled_in_std.nii')
scaled_PET_inStd.save(scaled_PET_inStd_path)

# Generamos las imágenes de QC
# PET escalado en T1 subject
thresholded_PET = ants.threshold_image(scaled_PETintoStd, 1)
ants.plot(StdTemplate, overlay=thresholded_PET, overlay_cmap='jet', overlay_alpha=0.5, filename=os.path.join(output_path, subject_name, 'PET-TAU', method, 'PET-to-T1std', 'QC', output_filename + '_reg_image_scaled_in_T1space.png'))

# PET escalado en Std
thresholded_PET = ants.threshold_image(scaled_PET_inStd, 1)
ants.plot(StdTemplate, overlay=thresholded_PET, overlay_cmap='jet', overlay_alpha=0.5, filename=os.path.join(output_path, subject_name, 'PET-TAU', method, 'PET-to-T1std', 'QC', output_filename + '_reg_image_scaled_in_Std.png'))

# Use ANTsPy to generate the metrics and save the results
metric_val = dict()
for metric in metrics:
    if metric not in metric_values:
        # Metric not found, skip
        print('Metric ' + metric + ' not found, skipping')
        continue
    metric_val[metric] = ants.image_similarity(fixed_image=StdTemplate, moving_image=PETintoStd, metric_type=metric)

# Save the metric values
metric_file = open(os.path.join(output_path, subject_name, 'PET-TAU', method, 'PET-to-T1std', 'QC', output_filename + '_metrics'), 'w')
metric_file.write('Metric\tValue\n')
for metric in metric_val:
    metric_file.write(metric + '\t' + str(metric_val[metric]) + '\n')
metric_file.close()
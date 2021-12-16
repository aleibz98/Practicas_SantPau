# imports
import os
import subprocess

# context settings: environment variables
os.environ['SUBJECTS_DIR'] = "/home/aalarcon/TFG/freesurfers"     # directorio donde están todos los inputs (fsl subjects)
PET_dir = "/home/aalarcon/TFG/tau-pet-raw"                        # directorio donde están todos los pet
os.makedirs("/home/aalarcon/TFG/outs", exist_ok=True)         					  # directorio donde se guardarán los outputs
os.environ['OUT_PATH'] = os.path.join("/home/aalarcon/TFG/outs")  # directorio donde se guardarán los outputs
os.environ['SCRIPTS_PATH'] = "/home/aalarcon/TFG/scripts"        # directorio donde están todos los scripts

# data scructures with possible values for parameters
#methods = ['bbregister', 'mri-coreg', 'flair'] # Añadir vvregister
#dofs = ['6' ,'9' ,'12']
#inits = ['spm', 'fsl', 'coreg', 'rr']
methods = ['bbregister']
dofs = ['6']
inits = ['rr']

# list all subjects
#subjects = os.listdir(os.environ.get('SUBJECTS_DIR'))
subjects = os.listdir(os.environ.get('SUBJECTS_DIR'))[0:1]

# get all necessary paths
input_dir = os.environ.get('SUBJECTS_DIR')

# generate all T1-to-Std calls
for subject in subjects:
    t1_path = os.path.join(input_dir, subject, 'mri', 'T1.mgz')
    call = ["python", os.path.join(os.environ.get('SCRIPTS_PATH'), "T1-to-Std_ANTS.py"), 
            "--t1", t1_path, 
            "--method", "SyNCC"]

    call = 'samrun -c \"' + " ".join(call) + '\"' 
    os.system(call)

# async wait?

# generate all PET-to-T1 calls
for s,m,d,i in [(a,b,c,d) for a in subjects for b in methods for c in dofs for d in inits]:
    subject_name = [elem for elem in s.split('_') if 'sub-' in elem][0]
    PET_file = [elem for elem in os.listdir(PET_dir) if subject_name in elem][0]
    PET_path = os.path.join(PET_dir, PET_file)
    call = ["python", os.path.join(os.environ.get('SCRIPTS_PATH'), "PET-to-T1.py"),
            "-d", input_dir,
            "-s", subject_name,
            "-m", PET_path,
            "--method", m,
            "--init", i,
            "--dof", d]
    
    call = 'samrun -c \"' + " ".join(call) + '\"' 
    os.system(call)
# imports
import os

# context settings: environment variables

#TODO: completar los paths del cluster
os.environ('SUBJECTS_DIR') = ""     # directorio donde están todos los inputs (fsl subjects)
os.mkdir(os.getcwd() + "/outputs")
os.environ('OUT_PATH') = os.path.join(os.getcwd(), "outputs")

# data scructures
methods = ['bbregister', 'mri-coreg', 'flair'] # Añadir vvregister
dofs = ['6' ,'9' ,'12']
inits = ['spm', 'fsl', 'coreg', 'rr']

# list all subjects
subjects = os.listdir(os.environ.get('SUBJECTS_DIR'))

# get all necessary paths
input_dir = os.environ.get('SUBJECTS_DIR')

# generate all T1-to-Std calls
for subject in subjects:
    t1_path = os.path.join("")
    PET_path = os.path.join("")
    call = ["samrun", "-c", "python", "T1-to-Std_ANTS.py", 
            "--t1", t1_path, 
            "--method", "SyNCC"]
    os.subprocess.call(call)

# async wait?

# generate all PET-to-T1 calls
for s,m,d,i in subjects, methods, dofs, inits:
    call = ["samrun", "-c", "python", "PET-to-T1_ANTS.py",
            "-d", input_dir,
            "-s", s,
            "-m", PET_path,
            "--method", m,
            "--init", i,
            "--dof", d]
    os.subprocess.call(call)
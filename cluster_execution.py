# imports
import os

# context settings

# list all subjects
subjects = os.listdir("")

# get all necessary paths
t1_path = os.path.join("")

# generate all T1-to-Std calls
for subject in subjects:
    call = "python T1-to-Std_ANTS.py -t1 " + t1_path + " --method SyNCC" 
    os.subprocess.call(call)

# generate all PET-to-T1 calls


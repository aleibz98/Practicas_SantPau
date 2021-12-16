import os
import shutil

# This script will focus on collecting all the QC files generated during the registration processes in order to easily perform QC analysis.

outs_path = "/home/aalarcon/TFG/outs/"
methods = ['bbregister', 'mri-coreg', 'vvregister', 'flair']

os.makedirs('/home/aalarcon/TFG/QC-collector/', exist_ok=True)
for subject in os.listdir(outs_path):
    if subject.startswith("sub-"):
        for method in os.listdir(os.path.join(outs_path, subject, 'PET-TAU')):
            if method in methods:
                for doc in os.listdir(os.path.join(outs_path, subject, 'PET-TAU', method)):
                    if doc.endswith(".png"):
                        shutil.copy(os.path.join(outs_path, subject, 'PET-TAU', method, doc),
                                    os.path.join('/home/aalarcon/TFG/QC-collector/', doc))


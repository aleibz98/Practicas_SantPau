import os
import shutil

# This script will focus on collecting all the QC files generated during the registration processes in order to easily perform QC analysis.

outs_path = "/home/aalarcon/TFG/outs/"
methods = ['bbregister', 'mri-coreg', 'vvregister', 'flair']

if True:
    os.makedirs('/home/aalarcon/TFG/QC-collector/QC', exist_ok=True)
    os.makedirs('/home/aalarcon/TFG/QC-collector/REG_IMAGE', exist_ok=True)
    for subject in os.listdir(outs_path):
        if subject.startswith("sub-"):
            src1 = os.path.join(outs_path, subject, 'T1/ANTS', 'QC', '*QC.png')
            dst1 = os.path.join('/home/aalarcon/TFG/QC-collector/QC', subject+'_QC.png')
            src2 = os.path.join(outs_path, subject, 'T1/ANTS', 'QC', '*reg_image.png')
            dst2 = os.path.join('/home/aalarcon/TFG/QC-collector/REG_IMAGE',subject+'_reg_image.png')
            try:
                os.symlink(src1, dst1)
                os.symlink(src2, dst2)
            except FileExistsError:
                print("File already exists")

if False:
    os.makedirs('/home/aalarcon/TFG/QC-collector/', exist_ok=True)
    for subject in os.listdir(outs_path):
        if subject.startswith("sub-"):
            for method in os.listdir(os.path.join(outs_path, subject, 'PET-TAU')):
                if method in methods:
                    for doc in os.listdir(os.path.join(outs_path, subject, 'PET-TAU', method)):
                        if doc.endswith(".png"):
                            src = os.path.join(outs_path, subject, 'PET-TAU', method, doc)
                            dst = os.path.join('/home/aalarcon/TFG/QC-collector/', doc)
                            try:
                                os.symlink(src, dst)
                            except FileExistsError:
                                print("File already exists")

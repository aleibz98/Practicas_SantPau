# Imports y mierdas
import argparse
import numpy as np
import matplotlib.pyplot as plt
import ants
import os

# Declaración de argumentos


# Parsing
### Nos hace falta algun argumento a parte del sujeto?
parser = argparse.ArgumentParser(description='PET-to-Std')
parser.add_argument('-s', '--subject', type=str, help='Subject ID')

"""
Suponemos que ya se han ejecutado los scripts T1-to-Std.py y PET-to-T1.py
"""

# Creactión de la jerarquia de carpetas dentro de PET-TAU, method, PET-to-T1std


# Acceso a las imagenes necesarias - PET, PET_scaled y T1_std
PET_path = ""
PET_scaled_path = ""
T1_std_path = ""

# Acceso a las matrices de transformacion
PET-to-T1_matrix = ""
T1-to-Std_matrix = ""

# Concatenación de las transformaciones
PET-to-Std_matrix = ""

# Aplicación de la transformacion


# Guardado de la imagen resultante (PET-to-std y PET_scaled-to-std)


# 


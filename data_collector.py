import csv
import os

# Este script está programado para coger los datos de los archivos metrics del registro en espacio subjeto, pero tal vez
# lo deberíamos modificar para que los cogiera de las métricas del espacio estándar.

outs_path = "/home/aalarcon/TFG/outs/"
methods = ['bbregister', 'mri-coreg', 'vvregister', 'flair']    
metrics = ['MeanSquares', 'Correlation', 'MattesMutualInformation', 'Demons', 'JointHistogramMutualInformation', 'ANTsNeighborhoodCorrelation']

header = []
header_SUVR = ['SUVR_std', 'SUVR_subj']

list = []
list2 = []
for subject in os.listdir(outs_path):
    if subject.startswith("sub-"):
        dict = {'Subject': subject}
        dict_SUVR = {'Subject': subject}
        for method in os.listdir(os.path.join(outs_path, subject, 'PET-TAU')):
            if method in methods:
                for doc in os.listdir(os.path.join(outs_path, subject, 'PET-TAU', method, 'PET-to-T1std', 'QC')):
                    if doc.contains("metric"):
                        permutation = doc.split('_')[1:-1]
                        with open(os.path.join(outs_path, subject, 'PET-TAU', method, 'PET-to-T1std', 'QC', doc), 'r') as f:
                            reader = csv.reader(f, delimiter='\t')
                            for row in reader[1:]: # Skip the header
                                dict[permutation + '_' + row[0]] = row[1]

                for doc in os.listdir(os.path.join(outs_path, subject, 'PET-TAU', method, 'PET-to-T1std', 'stats')):
                    if doc.contains("results"):
                        permutation = doc.split('_')[1:-1]
                        with open(os.path.join(outs_path, subject, 'PET-TAU', method, 'PET-to-T1std', 'stats', doc), 'r') as f:
                            reader = csv.reader(f, delimiter='\t')
                            for row,h in zip(reader[1:], header_SUVR):
                                dict[permutation + '_' + h] = row[1]        
        
        list.append(dict)
        list2.append(dict_SUVR)
        
        if len(header) < len(dict.keys()):
            # Por si acaso hay una nueva métrica que no está en el diccionario, nos quedamremos con el diccionario con más métricas
            header = dict.keys()
                    
                  
# Create the csv file and set the header
with open('/home/aalarcon/TFG/image_similarity_dataset.csv', 'w') as f:
    writer = csv.DictWriter(f, fieldnames=header)
    writer.writeheader()
    writer.writerows(list)

with open('/home/aalarcon/TFG/SUVR_dataset.csv', 'w') as f:
    writer = csv.DictWriter(f, fieldnames=header_SUVR)
    writer.writeheader()
    writer.writerows(list2)
  

import csv
import os

# Este script está programado para coger los datos de los archivos metrics del registro en espacio subjeto, pero tal vez
# lo deberíamos modificar para que los cogiera de las métricas del espacio estándar.

outs_path = "/home/aalarcon/TFG/outs/"
methods = ['bbregister', 'mri-coreg', 'vvregister', 'flair']

# Set the header
header = ['Subject', 'Method', 'Init', 'DOFs', 'MeanSquares', 'Correlation', 'MattesMutualInformation', 'Demons', 'JointHistogramMutualInformation', 'ANTsNeighborhoodCorrelation']

list = []
for subject in os.listdir(outs_path):
    if subject.startswith("sub-"):
        for method in os.listdir(os.path.join(outs_path, subject, 'PET-TAU')):
            if method in methods:
                for doc in os.listdir(os.path.join(outs_path, subject, 'PET-TAU', method)):
                    if doc.contains("metric"):
                        dict = {}
                        dict['Subject'] = subject
                        dict['Method'] = method
                        dict['Init'] = doc.split('_')[2]
                        dict['DOFs'] = doc.split('_')[3]                
                        with open(os.path.join(outs_path, subject, 'PET-TAU', method, doc), 'r') as f:
                            reader = csv.reader(f, delimiter='\t')
                            for row in reader[1:]: # Skip the header
                                dict[row[0]] = row[1]
                        list.append(dict)

# Create the csv file and set the header
with open(os.path.join(outs_path, 'data_collector.csv'), 'w') as f:
    writer = csv.DictWriter(f, fieldnames=header)
    writer.writeheader()
    writer.writerows(list)
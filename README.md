# Practicas_SantPau
Repositorio con el contenido desarrollado durante las practicas de neurociencia en el grupo de investigación IIB Sant Pau de Barcelona.

El proyecto consta de dos objetivos principales:
1. Determinar la mejor configuración de parámetros para el registro de imágenes tauPET con T1-MRI.
2. Análisis de las diferencias entre el cálculo de métricas en el espacio sujeto vs. espacio estándar.

El contenido de este repositorio se puede dividir en tres partes:
  
  Introducción y tutoriales
   Ya que el campo de la neurociencia es un sector muy específico, es necesaria la introducción de conceptos del campo, librerías específicas y metodologías.

  Pipeline de ejecución de procesos de registro de neuroimagen:
    En esta parte, se generan los scripts en python necesarios para realizar pipeline completo necesario para llevar a cabo el proceso de registro de imágenes cerebrales. Este proceso consiste en la transformación de volúmenes generando una alineación que permita una extracción de información precisa, minimizando el error. Además, se guardan las métricas necesariaas para la parte analítica así como imégenes que servirán para el control de la calidad de las ejecuciones. Estos scripts se han adaptado para su ejecución en un cluster reduciendo el tiempo de ejecución de 20 a 2 días.

  Recolección de los datos obtenidos y análisis estadístico:
    Una vez se han realizado todas las ejecuciones necesárias, se preocede a la recolección de las métricas y de las imágenes de control de calidad. Posteriormente, se tranforman los datos para facilitar su gestión y finalmente se procede a la realización de 5 estudios.
    
    Estudio 1: Determinar las 10 mejores configuraciones de parámetros según 2 de las métricas  que se han calculado.
    
    Estudio 2: Determinar si las calidades de registro de las 10 mejores configuraciones son estadísticamente diferentes.
    
    Estudio 3: Determinar si las calidades de registro de las 10 mejores configuraciones son estadísticamente diferentes entre los distintos grupos de diagnóstico.
    
    Estudio 4: Determinar si existen diferencias estadísticas entre calcular el SUVr (Standard Uptake Value ratio) en el espacio sujeto (antes de las transformaciones) vs en el espacio estándar (después de las transformaciones) y determinar cual es mejor.
    
    Estudio 5: Creación de un modelo de regresión binaria para clasificación Alzheimer vs. Control a partir del SUVr y co-variables significativas.

🌍 Random Forest-Based Land Cover Classification using LISS-IV Remote Sensing Data

This project demonstrates Random Forest-based land cover classification using LISS-IV remote sensing data. The methodology includes DN to TOA reflectance conversion, feature extraction, and classification using machine learning (Random Forest) in R.

📌 Overview:
  This repository presents a Random Forest (RF) classification workflow for LISS-IV satellite imagery, focusing on land cover classification. The workflow includes feature extraction, model training, classification, and accuracy assessment using machine learning techniques in R.

  The LISS-IV sensor, onboard Resourcesat-2A, provides high-resolution multispectral imagery, making it ideal for applications in urban planning, agriculture, forestry, and water resource management.

🖥 Language Used: R

🛠 Features
✔️ Preprocessing of FCC & NDVI Raster Data from LISS-IV
✔️ Automated Training Sample Extraction from Shapefiles
✔️ Feature Engineering & Data Preparation
✔️ Random Forest Model Training & Saving
✔️ Land Cover Classification & Thematic Mapping
✔️ Accuracy Assessment using Confusion Matrix

📚 Libraries Used
This project is implemented in R using the following packages:

📦 terra – Raster & vector data handling
📦 sf – Handling shapefiles
📦 lubridate – Date-time processing
📦 dplyr – Data manipulation
📦 readr – Reading CSV files
📦 randomForest – Machine learning model
📦 caret – Model evaluation
📦 ggplot2 – Data visualization
📦 RColorBrewer – Color schemes for mapping


📌 Workflow Steps
🔹 1. Data Acquisition
Satellite images are obtained from the Bhoonidhi ISRO portal, specifically LISS-IV multispectral data.
🔗 Download Link: Bhoonidhi ISRO (https://bhoonidhi.nrsc.gov.in/bhoonidhi/login.html)

🔹 2. Data Preparation & Feature Extraction
Import False Color Composite (FCC) raster and NDVI layers.
Load training sample shapefiles for four land cover classes:
  🏙 Built-up (Urban Areas) – Red
  🌾 Range – Gray
  🌳 Tree Cover – Green
  💧 Water Bodies – Blue
Extract spectral features:
  NIR (Near-Infrared)
  Red Band
  Green Band
  NDVI (Vegetation Index)
  
🔹 3. Model Training using Random Forest
  Convert extracted features into a structured dataset (CSV format).
  Define predictor variables (NIR, Red, Green, NDVI) and response (Class).
  Train Random Forest Classifier with 100 trees using the randomForest package.
  Save the trained model as RandomForest_Model.rds.

🔹 4. Classification & Thematic Mapping
  Apply the trained RF model to classify LISS-IV imagery.
  Generate a classified raster map with four distinct classes.
  Save the classified raster as a GeoTIFF format for GIS applications.
  
🔹 5. Accuracy Assessment
  Generate a Confusion Matrix to evaluate model performance.
  Compute Overall Accuracy and class-wise accuracy metrics.

🎯 Conclusion:
  This project demonstrates an efficient and scalable approach for land cover classification using LISS-IV data and machine learning techniques. The Random Forest algorithm provides high accuracy and adaptability for various applications in urban expansion studies, agricultural monitoring, and environmental research.

 # Folder structure 
 
 ``` 
 Data_Science_Project/ 
 │ 
 ├── data/ 
 │   ├── external 
 │   ├── intermediate 
 │   ├── processed 
 │   └── raw 
 ├── README.md 
 ├── docs 
 ├── notebooks 
 ├── reports 
 ├── src 
 │   ├── preparation 
 │   ├── processing 
 │   └── visualizations 
 └── requirements.txt 
 ``` 
 
- README.md: This file typically contains an overview of the project, its purpose, how to set it up, and any other relevant information for developers or users. 

- docs: This directory can contain project documentation such as a data dictionary, project plan, or any other explanatory materials. 
 
- data: Contains all data used in the project, with subdirectories for different stages of data processing: external for data from third-party sources, intermediate for temporary files generated during processing, processed for cleaned and transformed data, and raw for the original, immutable data dump. 
 
- notebooks: Contains Jupyter notebooks used for exploratory data analysis, data visualization, or any other analysis tasks. 
 
- reports: Contains any generated analysis reports or results summaries. 
 
- src: This directory contains the source code for the project, with subdirectories for different stages of data preparation (preparation), data processing (processing), and visualization (visualizations). 
 
- requirements.txt: Specifies the project dependencies for reproducing the analysis environment. 

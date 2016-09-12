This collection of scripts was written for classification of Alzheimer's disease based on structural MRI data acquired from ADNI. 
There are several folders with scripts, all need to be in the path:
- DataPreparation folder contains the script that deals with data gathering and preparation. 
Data is first processed in Freesurfer http://freesurfer.net/ . This script gathers the ROIs specified by the user, calculates
the shape descriptors and outputs a data and label structures used in the classification.
- CalculatingDescriptors folder contains the projection calculation, moments and entropy calculation and some utils scripts.
- FullPipeline folder contains the scripts that run the full classification pipeline from loading the data and labels , 
through normalization of the feature vectors, classification and results evaluation. TenMethodsPipeline is the main script.
In also contains the GenerateFigures script that contains different cells, each targeted for a different type of visualization. 
These scripts use functions in the FigureUtils folder. 

For the SVM classifier learner, I used the LibLinear library freely available from http://www.csie.ntu.edu.tw/~cjlin/liblinear/.
It has a Matlab interface, configuration with Matlab is fairly easy and explained on the website.



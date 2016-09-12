% cd 'C:\MyWork\Stanford\data\ten_methods\output\PaperData'
cd 'C:\MyWork\Stanford\Documents\ad_paper_data_figures\PaperData';
load AllTrainingTestingDataNew.mat

roi_name = {'17_Left-Hippocampus',...
    '53_Right-Hippocampus',...
    '5_Left-Inf-Lat-Vent',...
    '44_Right-Inf-Lat-Vent',...
    '43_Right-Lateral-Ventricle',...
    '14_3rd-Ventricle',...
    '18_Left-Amygdala',...
    '54_Right-Amygdala',...
    '2_Left-Cerebral-White-Matter',...
    '41_Right-Cerebral-White-Matter'};
for i=1:10
    for j=1:length(AllTrainingData{i})
        AllTrainingData{i}(j).IsTraining = 1;
    end
end
for i=1:10
    for j=1:length(AllTestingData{i})
        AllTestingData{i}(j).IsTraining = 0;
    end
end
for i=1:10
    AllROIs{i} = [AllTrainingData{i}, AllTestingData{i}];
end

[ data,labels,test_train ] = TenMethodsPrepareDataForClassification( AllROIs);
max_data = max(abs(data));
data = abs(data)./(ones(size(data,1),1)*max_data);

outlierSelection;
TenMethodsClassify;
GenerateFigures;




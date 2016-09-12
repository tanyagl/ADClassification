% cd 'C:\MyWork\Stanford\data\ten_methods\output\PaperData'
cd 'C:\MyWork\Stanford\Documents\ad_paper_data_figures\PaperData';
load AllTrainingTestingDataNew.mat
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
data = data./(ones(size(data,1),1)*max_data);

outlierSelection;
TenMethodsClassify;
GenerateFigures;




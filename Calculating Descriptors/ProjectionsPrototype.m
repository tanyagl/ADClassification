%  
% go over all segments and create Training Data by calling function CreateSegmentData()
numSegments = length(regions); 
TrainingData = []; % TrainingData = zeros(numBrains*numSegments,1200);
labels = []; % labels = zeros(numBrains*numSegments,1);
empty_regions = [];
for region = 1:length(regions)
    if (region == 9)
        stop = 1;
    end
    segmentData = CreateSegmentData(brainList, sparseIndicatorsList, region);
    if(~isempty(segmentData))
        [n,m]= size(segmentData);
        TrainingData = [TrainingData; segmentData];
        labels = [labels;region*ones(n,1)];
    else
     empty_regions = [empty_regions, region];    
    end
end
% 
% % data created thus far is saved in :
% % load allData
% % load TrainingDataRealPrj
% %%

%%
dimData = [];
featuresData = [];
labelsData = [];
prjData = [];
for i=1:length(TrainingData) %number of segments 
    dimData = [dimData; TrainingData(i,1).dim];
    prjDataTmp = [];
    prjDataTmp1 = [];
    featuresDataTmp = [];
    featuresDataTmp1 = [];
    [num_prjs,num_brains] = size(TrainingData(i,1).features);
    for k = 1:num_brains
        for j = 1:num_prjs %num projections
            featuresDataTmp = [featuresDataTmp,(TrainingData(i,1).features{j,k})'];
            prjDataTmp = [prjDataTmp,reshape(TrainingData(i,1).map_norm{j,k},1,100)];
        end %here featuresDataTmp is a 1x60 vector that contains the feature vector per one segment of one brain
        featuresDataTmp1 = [featuresDataTmp1;featuresDataTmp]; %each row is a different brain
        prjDataTmp1 = [prjDataTmp1;prjDataTmp];
        featuresDataTmp = [];
        prjDataTmp = [];
    end
    featuresData = [featuresData;featuresDataTmp1];
    prjData = [prjData;prjDataTmp1];
end
clear featuresDataTmp featuresDataTmp1 prjDataTmp prjDataTmp1;

dimData_norm(:,1) = dimData(:,1)/max(dimData(:,1));
dimData_norm(:,2) = dimData(:,2)/max(dimData(:,2));
dimData_norm(:,3) = dimData(:,3)/max(dimData(:,3));
%%
%creating training and testing data: first create an indices vector in the
%following way: we have 10 instances of every segment, 8(say) examples of
%these instances will be used for training and the rest for testing.
% we need to generate an indices vector that will have random entries
% within the decade: i*(1:10)(where i = 1:35), and then take first 8 for training and the rest for
% testing.
for i = 1:length(TrainingData)
    a = randperm(10);
    ind = 10*(i-1)+1:10*i;
    randInd(10*(i-1)+1:10*i) = ind(a);% this is the permutation vector for training/testing data
end
randInd = randInd';
%% train one-vs-all SVM classifiers for all segments
% labelSet = unique(labels); % creates a vector of all unique labels
numInst = numBrains;
%numLabels = max(labels);
%# split to training/testing examples
idx = randInd;%randperm(numInst);
numTrain = 0.8*numInst; 
numTest = numInst - numTrain;
% prepare training and testing data
% first try using the projection maps
%randData = dimData_norm(randInd,:);
%randData = featuresData(randInd,:);
randData = prjData(randInd,:);

for i=1:length(labels)
    labelsData((i-1)*num_brains+1:i*num_brains) = labels(i);
end
labelsData = labelsData';
randLabels = labelsData(randInd);
trainInd = [];
testInd = [];
for i = 1:length(TrainingData)
    trainInd = [trainInd; randInd(10*(i-1)+1:10*(i-1)+numTrain)];
    testInd = [testInd; randInd(10*(i-1)+numTrain+1:10*i)];
end
trainData = randData(trainInd,:);
testData = randData(testInd,:);
trainLabels = randLabels(trainInd);
testLabels = randLabels(testInd);

%now permute these vectors
a = randperm(length(trainInd));
trainData1 = trainData(a,:);
trainLabels1 = trainLabels(a);

a = randperm(length(testInd));
testData1 = testData(a,:);
testLabels1 = testLabels(a);
%%
model = ovrtrain(trainLabels1, trainData1(:,1:100),'-t 0 -c 10000 -g 0.001 -b 1'); 

 [pred, ac, decv] = ovrpredict(testLabels1, testData1(:,1:100), model);
 
 prob = zeros(numTest,length(labelSet));
for k=1:length(labelSet)
    [~,~,p] = svmpredict_libsvm(double(testLabel==k), testData, model.models{k}, '-b 1');
    prob(:,k) = p(:,model.models{k}.Label==1);    %# probability of class==k
end

%# predict the class with the highest probability
[~,pred] = max(prob,[],2);
acc = sum(pred == testLabel) ./ numel(testLabel)    %# accuracy
C = confusionmat(testLabel, pred)    ;


%%
Class = knnclassify(testData1, trainData1, trainLabels1, 1);
compare = [Class,testLabels1];
length(find(compare(:,1) - compare(:,2)))

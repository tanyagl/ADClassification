function [ new_data,new_labels,new_test_train ] = TenMethodsPrepareDataForClassification( AllROIs)
numROIs = length(AllROIs);
numSubjects = length(AllROIs{1});
data = zeros(numSubjects,1);
for roi_num = 1:numROIs
    if(roi_num < 9)
        cur_data{roi_num} = UpdateFeatures(AllROIs{roi_num});
    else
        cur_data{roi_num} = AllROIs{roi_num};
    end
end

for sbj_num = 1:numSubjects
    num_features = 0;
    
    for roi_num = 1:numROIs
        if(roi_num < 9)
            cur_features = [length(cur_data{roi_num}(sbj_num).coords),cur_data{roi_num}(sbj_num).features'];
            data(sbj_num,num_features+1:length(cur_features)+num_features) = cur_features;
            num_features = num_features + length(cur_features);
        else
            cur_features = length(cur_data{roi_num}(sbj_num).coords);
            data(sbj_num,num_features+1:length(cur_features)+num_features) = cur_features;
            num_features = num_features + length(cur_features);
        end
        labels(sbj_num) = cur_data{roi_num}(sbj_num).label;
        test_train(sbj_num) = cur_data{roi_num}(sbj_num).IsTraining;
        
    end
end
%rearrange
new_data = [];
new_labels = [];
new_test_train = [];
num_labels = length(unique(labels));
for label = 0:num_labels-1
    new_data = [new_data;data(labels == label,:)];
    new_labels = [new_labels;ones(size(data(labels == label,:),1),1)*label];
    new_test_train = [new_test_train;test_train(labels == label)'];
end

end



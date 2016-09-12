function [ data,labels ] = PrepareDataForClassification( AllROIs,choose02only )
numROIs = length(AllROIs);
numSubjects = length(AllROIs{1});
data = zeros(numSubjects,1);
if(choose02only)
    cnt = 1;
    for sbj_num = 1:numSubjects
        num_features = 0;
        if (AllROIs{1}(sbj_num).label.diagnosis == 1)
            continue;
        end
        for roi_num = 1:numROIs
            if(roi_num < 7)
                cur_data = UpdateFeatures(AllROIs{roi_num}(sbj_num));
            else
                cur_data = AllROIs{roi_num}(sbj_num);
            end
            if(roi_num < 7)
                cur_features = [length(cur_data.coords),cur_data.features'];
                data(cnt,num_features+1:length(cur_features)+num_features) = cur_features;
                num_features = num_features + length(cur_features);
            else
                cur_features = length(cur_data.coords);
                data(cnt,num_features+1:length(cur_features)+num_features) = cur_features;
                num_features = num_features + length(cur_features);
            end
            labels(cnt) = cur_data.label.diagnosis;
        end
        cnt = cnt+1;
        
    end
else
    cnt = 1;
    for sbj_num = 1:numSubjects
        num_features = 0;
        for roi_num = 1:numROIs
            if(roi_num < 7)
                cur_data = UpdateFeatures(AllROIs{roi_num}(sbj_num));
            else
                cur_data = AllROIs{roi_num}(sbj_num);
            end
            if(roi_num < 7)
                cur_features = [length(cur_data.coords),cur_data.features'];
                data(cnt,num_features+1:length(cur_features)+num_features) = cur_features;
                num_features = num_features + length(cur_features);
            else
                cur_features = length(cur_data.coords);
                data(cnt,num_features+1:length(cur_features)+num_features) = cur_features;
                num_features = num_features + length(cur_features);
            end
            labels(cnt) = cur_data.label.diagnosis;
        end
        cnt = cnt+1;
        
    end
end
labels = labels';
data = data(1:cnt-1,:);
[i,~] = find(data>ones(size(data,1),1)*(median(data)+2.5*std(data)));
outlier_indices = unique(i);
data(outlier_indices,:) = [];
labels(outlier_indices) = [];
max_data = max(abs(data));
data = data./(ones(size(data,1),1)*max_data);

end


% data0 = data(labels==0,:);
% %data1 = data(labels==1,:);
%
% data2 = data(labels==2,:);
% figure;plot3(data0(:,1),data0(:,2),data0(:,3),'*r');hold on;plot3(data2(:,1),data2(:,2),data2(:,3),'b*');
%

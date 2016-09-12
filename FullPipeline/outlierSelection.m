outlier_indices = [];
data1 = data;
labels1 = labels;
test_train1 = test_train;
for label = 0:3
    start = find(labels==label,1,'first');
    last = find(labels==label,1,'last');
    [i,~] = find(data > ones(size(data,1),1)*(median(data(labels == label,:))+3.5*std(data(labels == label,:))));
    [j,~] = find(data <ones(size(data,1),1)*(median(data(labels == label,:))-3.5*std(data(labels == label,:))));
    i=i(i<last & i>start);
    j=j(j<last & j>start);
    
    outlier_indices = [outlier_indices,unique([i;j])'];
end
data1(outlier_indices,:) = [];
labels1(outlier_indices) = [];
test_train1(outlier_indices) = [];
max_data = max(abs(data1));
data1 = data1./(ones(size(data1,1),1)*max_data);

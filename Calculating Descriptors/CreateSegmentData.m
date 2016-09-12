function SegmentData = CreateSegmentData(brainList, sparseIndicatorsList, segment)
SegmentData = [];

ind = 1;
for i=1:length(brainList)
    %-------------------------------------------
    %first calculate PCA and rotate segment according to its eigenvectors
    segmentData = getSegmentData(brainList, sparseIndicatorsList, i, 1, segment);
    if(isempty(segmentData.vertices))
        continue;
    else
        %calculate PCA
        %first, standartize the data by subtracting the mean (centroid)
        normalized_coords = segmentData.coords - repmat(segmentData.centroid,[length(segmentData.coords) 1]);
        %normalized_coords = %normalized_coords./repmat(std(normalized_coords),[length(segmentData.coords) 1]);
        [V,score, eigv] = princomp(normalized_coords);
        coords = (score'*10000)'; %multiplying by 10000 to get values suitable for pixel location map - any better ideas? 
        %----------------------------------
        % now calculate the projections
        R = calcRotationMatrix(0,0,0);
        prj{1,ind} =  calcProjection(coords,R,1,2);
       
            prj{2,ind} =  calcProjection(coords,R,1,3);
            prj{3,ind} =  calcProjection(coords,R,2,3);
%             R = calcRotationMatrix(45,0,0);
%             prj{4,ind} =  calcProjection(coords,R,1,2); 
%             prj{5,ind} =  calcProjection(coords,R,1,3);
%             prj{6,ind} =  calcProjection(coords,R,2,3);
%             R = calcRotationMatrix(0,45,0);
%             prj{7,ind} =  calcProjection(coords,R,1,2); 
%             prj{8,ind} =  calcProjection(coords,R,1,3);
%             prj{9,ind} =  calcProjection(coords,R,2,3);
%             R = calcRotationMatrix(0,0,45);
%             prj{10,ind} =  calcProjection(coords,R,1,2); 
%             prj{11,ind} =  calcProjection(coords,R,1,3);
%             prj{12,ind} =  calcProjection(coords,R,2,3);
%             ind = ind + 1;
        end
   
    
end
%%
if(exist('prj'))
    cnt = 0;
 % take only principal dimensions(so from one rotation only)  for i = 1:3:size(prj,1)
        cnt = cnt+1;
        for j = 1:size(prj,2)
            dim(j,:) = [size(prj{1,j}{1}) size(prj{2,j}{1},2)];
        end
  %  end
end
%% 
% create prj_vec, calculate alpha shape, V is volume, S is structure with boundary
if(exist('prj'))
    [num_prj,num_brains] = size(prj);
    for i = 1:num_brains
        [k,l] = size(prj{1,i}{1}); % largest dimension is in the direction of the 1st principal axis - 1st projection
        max_dim = max(k,l); % all other dimensions are normalized according to this dimension
        for j = 1:num_prj
            [n,m]= find(prj{j,i}{1});
            prj_vec{j,i} = [n/max_dim,m/max_dim];
            [V(j,i),S{j,i}] = alphavol(prj_vec{j,i},0.1);
        end
    end
end

%% create a binary map for the projection
% can think of it as distribution matrix
if(exist('prj'))
    step = 0.1;

    for prj_num = 1:num_prj
        for num_brain = 1:num_brains
            m = zeros(10,10);
            for i=0:9
                for j=0:9
                    dim1_range = [i*step (i+1)*step];%all vertices with x within this range will be projected onto one pixel
                    dim2_range = [j*step (j+1)*step];
                    m(i+1,j+1) = numel(find((prj_vec{prj_num,num_brain}(:,1) > dim1_range(1)) & (prj_vec{prj_num,num_brain}(:,1) < dim1_range(2)) &...
                                            (prj_vec{prj_num,num_brain}(:,2) > dim2_range(1)) & (prj_vec{prj_num,num_brain}(:,2) < dim2_range(2))));
                end
            end
            map{prj_num,num_brain} = m;%reshape(m,100,1);
        end
    end
end


%% Calculate moments for the maps
% first, normalize map such that the sum of all entries is 1.
%then calculate moments
if(exist('prj'))
    for prj_num = 1:num_prj
        for num_brain = 1:num_brains
            cur_map = map{prj_num,num_brain};
            total = sum(sum(cur_map));
            map_norm{prj_num,num_brain} = cur_map./total;
            cur_map = map_norm{prj_num,num_brain};
            features{prj_num,num_brain} = [CalculateMoment(cur_map,1,1);CalculateMoment(cur_map,1,2);CalculateMoment(cur_map,2,1);CalculateMoment(cur_map,2,2);entropy(cur_map)];
        end
    end
end


%% prepare training data for SVM
% if(exist('map','var'))
%     %SVMStruct = svmtrain(Training,Group)
%     %Training = Matrix of training data, where each row corresponds to an observation or replicate, and each column corresponds to a feature or variable
%     binary_map = zeros(num_brains, num_prj*100);
%     for prj_num = 1:num_prj
%         for num_brain = 1:num_brains
%             binary_map1(num_brain, (prj_num-1)*100+1:prj_num*100) = reshape(map{prj_num,num_brain},100,1);
%             map_norm1(num_brain, (prj_num-1)*100+1:prj_num*100) = reshape(map_norm{prj_num,num_brain},100,1);
%         end
%     end
% end
%%
if(exist('prj'))
    SegmentData.prj = prj;  
    SegmentData.prj_vec = prj_vec;
    SegmentData.area = V;
    SegmentData.circumLine = S;
    SegmentData.binary_map = map;
    SegmentData.map_norm = map_norm;
    SegmentData.dim = dim;
    SegmentData.features = features;
end


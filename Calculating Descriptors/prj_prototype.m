function SegmentData = CreateSegmentData(brainList, sparseIndicatorsList, segment)
% clear prj;
% clear prj_vec;
% segment = 30;%segment number 
for i=1:length(brainList)
    R = calcRotationMatrix(0,0,0);
    prj{1,i} =  calcProjection(brainList,sparseIndicatorsList,i,1,segment,R,1,2); 
    prj{2,i} =  calcProjection(brainList,sparseIndicatorsList,i,1,segment,R,1,3);
    prj{3,i} =  calcProjection(brainList,sparseIndicatorsList,i,1,segment,R,2,3);
    R = calcRotationMatrix(45,0,0);
    prj{4,i} =  calcProjection(brainList,sparseIndicatorsList,i,1,segment,R,1,2); 
    prj{5,i} =  calcProjection(brainList,sparseIndicatorsList,i,1,segment,R,1,3);
    prj{6,i} =  calcProjection(brainList,sparseIndicatorsList,i,1,segment,R,2,3);
    R = calcRotationMatrix(0,45,0);
    prj{7,i} =  calcProjection(brainList,sparseIndicatorsList,i,1,segment,R,1,2); 
    prj{8,i} =  calcProjection(brainList,sparseIndicatorsList,i,1,segment,R,1,3);
    prj{9,i} =  calcProjection(brainList,sparseIndicatorsList,i,1,segment,R,2,3);
    R = calcRotationMatrix(0,0,45);
    prj{10,i} =  calcProjection(brainList,sparseIndicatorsList,i,1,segment,R,1,2); 
    prj{11,i} =  calcProjection(brainList,sparseIndicatorsList,i,1,segment,R,1,3);
    prj{12,i} =  calcProjection(brainList,sparseIndicatorsList,i,1,segment,R,2,3);
end
%%
%% note we're not using the actual size/volume/sircumference of the segment at all
% create prj_vec, calculate alpha shape, V is volume, S is structure with boundary
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
%% 
% %visualize the data with all projections as 2D images
% % figure;subplot(4,2,1);imagesc(prj{1,1});colormap(gray);
% % subplot(4,2,2);imagesc(prj{1,2});colormap(gray);
% % subplot(4,2,3);imagesc(prj{1,3});colormap(gray);
% % subplot(4,2,4);imagesc(prj{1,4});colormap(gray);
% % subplot(4,2,5);imagesc(prj{1,5});colormap(gray);
% % subplot(4,2,6);imagesc(prj{1,6});colormap(gray);
% % 
% %prj_before = prj;
%%
% %another way to view this data
% for a=1:size(prj,1)
%     
%     figure;axis equal;
% %     subplot(121);axis equal;
% %     for k = 1:length(brainList)
% %         [i,j] = find(prj_before{a,k});
% %         hold all;plot(i,j,'*');title(['Projection ',num2str(a),' before PCA alignment']);
% %     end
% %     hold off;
% %     subplot(122);
%     for k = 1:length(brainList)
%         [i,j] = find(prj{a,k}{1});
%         hold all;plot(i,j,'*');title(['Projection ',num2str(a),' after PCA alignment']);
%     end
%     hold off;
% end

%%
% % %yet another visualization with the alpha shape
% for prj_num = 1:num_prj
%     figure; axis equal;
%     xlim([0.0 1.0]); ylim([0.0 1.0]);
%     for i = 1:num_brains
%         locX = prj_vec{prj_num,i}(:,1); %x coordinate
%         loc_x = locX(S{prj_num,i}.bnd);
%         locY = prj_vec{prj_num,i}(:,2); %y coordiante
%         loc_y = locY(S{prj_num,i}.bnd);
%         hold all; plot(loc_x,loc_y,'linewidth',2);
%     end
%     hold off;
% end

%% create a binary map for the projection
step = 0.1;

for prj_num = 1:num_prj
    for num_brain = 1:num_brains
        m = zeros(10,10);
        for i=0:9
            for j=0:9
                dim1_range = [i*step (i+1)*step];%all vertices with x within this range will be projected onto one pixel
                dim2_range = [j*step (j+1)*step];
                k = find((prj_vec{prj_num,num_brain}(:,1) > dim1_range(1)) & (prj_vec{prj_num,num_brain}(:,1) < dim1_range(2)));
                l = find((prj_vec{prj_num,num_brain}(:,2) > dim2_range(1)) & (prj_vec{prj_num,num_brain}(:,2) < dim2_range(2)));
                if(intersect(k,l))
                    m(i+1,j+1) = 1;
                end
            end
        end
        map{prj_num,num_brain} = reshape(m,100,1);
    end
end

%% prepare training data for SVM
%SVMStruct = svmtrain(Training,Group)
%Training = Matrix of training data, where each row corresponds to an observation or replicate, and each column corresponds to a feature or variable
SegmentData = zeros(num_brains, num_prj*100);
for prj_num = 1:num_prj
    for num_brain = 1:num_brains
        SegmentData(num_brain, (prj_num-1)*100+1:prj_num*100) = map{prj_num,num_brain};
    end
end
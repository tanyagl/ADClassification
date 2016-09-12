if(~exist(TrainingData,'var'))
    load TrainingData;
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
% view projections as point cloud. Different colors for different brains
% segment = 10;
% SegmentData =  TrainingData(segment);%CreateSegmentData(brainList,sparseIndicatorsList,segment);
figure;
suptitle(['All projections of segment number ',num2str(segment),'; Different colors represent different brains']);
for a=1:size(SegmentData.prj,1)
    k=1;
    for k = 1:size(SegmentData.prj,2)
        [i,j] = find(SegmentData.prj{a,k}{1});
        subplot(2,size(SegmentData.prj,1)/2,a);
        hold all;plot(i,j,'*');title(['Projection ',num2str(a)]); 
    end
    hold off; axis equal
end
%%
figure
[i,j,val] = find(SegmentData.prj{1,1}{2});
plot3(i,j,val,'*'); 

%%
segment = 1;
figure
for brain = 1:numBrains
    prj = reshape(TrainingData(segment).binary_map(brain,501:600),10,10);
    subplot(2,numBrains/2,brain);
    imagesc(prj);colormap gray;colorbar;axis equal
    set(gca,'YTickLabel',[])
    set(gca,'XTickLabel',[])
end

%%
% view projections as alpha-shape circumference. Different colors for
% different brains
segment = 11;
SegmentData =  TrainingData(segment);%CreateSegmentData(brainList,sparseIndicatorsList,segment);
figure;axis equal
suptitle(['All alpha shapes of segment number ',num2str(segment),'; Different colors represent different brains']);
for prj_num = 1:size(SegmentData.prj,1)
    xlim([0.0 1.0]); ylim([0.0 1.0]);
    for i = 1:size(SegmentData.prj,2)
        locX = SegmentData.prj_vec{prj_num,i}(:,1); %x coordinate
        loc_x = locX(SegmentData.circumLine{prj_num,i}.bnd);
        locY = SegmentData.prj_vec{prj_num,i}(:,2); %y coordiante
        loc_y = locY(SegmentData.circumLine{prj_num,i}.bnd);
        subplot(2,size(SegmentData.prj,1)/2,prj_num);
        hold all; plot(loc_x,loc_y,'linewidth',2);axis equal
    end
    hold off;axis equal
end
axis equal

%% visualize the binary maps of projections
%same segment, same projection, different brains
prj = 1; %choose number between 1 and 12
segment = 11; %choose number between 1 and length(labelSet) (some segments don't have vertices, so they are not in the TrainingData)
figure;
suptitle(['SAME segment projected on the SAME plane in DIFFERENT brains; segment number = 11', '; projection plane = ',num2str(prj) ])
for i=1:numBrains
    %map2 =
    %reshape(TrainingData(numBrains*(i-1)+1,(prj-1)*100+1:prj*100),10,10);%same brain, same projection, different segments
  %  map = reshape(TrainingData(segment).binary_map(i,(prj-1)*100+1:prj*100),10,10);%same segment, same projection, different brains
    %    map = reshape(TrainingData((segment-1)*numBrains+i,(prj-1)*100+1:prj*100),10,10);%same segment, same projection, different brains
    subplot(2,numBrains/2,i);axis equal %
    map = TrainingData(segment).map_norm{prj,i};
%     if (i==1) map = fliplr(map);
%     elseif(i==6 || i==7 || i==10 || i==8)
%         map = fliplr(map);
%     end
    imagesc(map);colormap gray
     set(gca,'YTickLabel',[])
    set(gca,'XTickLabel',[])
end
%% visualize the binary maps of projections 
%same brain, same projection, different segments
labelSet = unique(labels); % creates a vector of all unique labels
num_segments = length(labelSet);
prj = 1; %choose number between 1 and 12
segment = 1; %choose number between 1 and 35 (some segments don't have vertices, so they are not in the TrainingData)
num_brain = 3; %choose a number between 1 and 10 (this is for the map2 option below)
figure;
suptitle(['DIFFERENT segments projected on the SAME plane in ONE brain; projection plane = ',num2str(prj), '; brain = ',num2str(num_brain)])

for i=1:num_segments
%   map =
%   reshape(TrainingData((num_brain+(i-1)*numBrains),(prj-1)*100+1:prj*100),10,10);%same brain, same projection, different segments
    map = (cell2mat(TrainingData(i).map_norm(prj,num_brain)));%same brain, same projection, different segments
    subplot(5,length(labelSet)/5,i);axis equal %
    imagesc(map);colormap gray
    set(gca,'YTickLabel',[])
    set(gca,'XTickLabel',[])
end
%%
% dimensions in plot3. assign different color to every segment

figure;
X = dimData_norm(:,1);
Y = dimData_norm(:,2);
Z = dimData_norm(:,3);
colors = distinguishable_colors(35);
%colors_active = hsv(length(X)/10);
C = zeros(length(X),3);
for i = 1:length(X)/10
    value = colors(i,:);
    C(10*(i-1)+1:10*i,:)  = repmat(value,10,1);
end
scatter3( X, Y, Z,16,C,'filled')
title('Segment dimensions (different colors represent different segments)')
for i=1:length(dimData_norm)/numBrains
    hold all;plot3(dimData_norm((i-1)*10 + 1:i*10,1),dimData_norm((i-1)*10 + 1:i*10,2),dimData_norm((i-1)*10 + 1:i*10,3),'*'); 
end


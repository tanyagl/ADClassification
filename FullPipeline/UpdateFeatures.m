% all_sbj_rois = Ventricle3;
% for i=1:length(all_sbj_rois)   
%  all_sbj_rois(i).surface_coords =  GetSurfaceCoords(all_sbj_rois(i).coords);
%   all_sbj_rois(i).normalized_surface_coords = all_sbj_rois(i).surface_coords - repmat(calcCentroid(all_sbj_rois(i).surface_coords),[length(all_sbj_rois(i).surface_coords) 1]);
%     [ all_sbj_rois(i).PCAed_surface_coords,~,~ ] = nipals(all_sbj_rois(i).normalized_surface_coords,3);
% 
% end
% 
%     colors = distinguishable_colors(length(all_sbj_rois));
%     figure;title('subject rois clustered according to diagnosis label')
% for i=1:length(all_sbj_rois)
%      sbj_name = all_sbj_rois(i).name;
%     
%         switch all_sbj_rois(i).label.diagnosis
%             case 0
%                 color = colors(1,:);
%             case 1
%                 color = colors(2,:);
%             case 2
%                 color = colors(3,:);
%         end
%         plot3(all_sbj_rois(i).PCAed_surface_coords(:,1),all_sbj_rois(i).PCAed_surface_coords(:,2),all_sbj_rois(i).PCAed_surface_coords(:,3),'.','color',color);hold on;legend('NC','MCI','AD');
% end
% % 
% % dt = DelaunayTri(all_sbj_rois(i).PCAed_surface_coords);
% % tetramesh(dt,all_sbj_rois(i).PCAed_surface_coords);
% % 
% % [tri Xb]= freeBoundary(dt); 
% % 
% % 
% % 
% % 
% % 
% % 
% % 
% % figure 
% % trisurf(tri,Xb(:,1),Xb(:,2),Xb(:,3), 'FaceColor', 'cyan', 'faceAlpha', 0.8);
% % 
% % 
% 
% %%%%
% %%
% path2NC = 'C:\MyWork\Stanford\data\CADDEMENTIA\output\NC\';
% path2MCI = 'C:\MyWork\Stanford\data\CADDEMENTIA\output\MCI\';
% path2AD = 'C:\MyWork\Stanford\data\CADDEMENTIA\output\AD\';
% cnt0=1;cnt1=1;cnt2=1;
% for i=1:length(all_sbj_rois)
%     switch all_sbj_rois(i).label.diagnosis
%         case 0
%             filename = fullfile(path2NC,['Lhippo',num2str(cnt0),'.vtk']);
%             cnt0 = cnt0+1;
%             VTKPolyDataWriter(all_sbj_rois(i).PCAed_surface_coords,filename);
%         case 1
%             filename = fullfile(path2MCI,['Lhippo',num2str(cnt1),'.vtk']);
%             cnt1 = cnt1+1;
%             VTKPolyDataWriter(all_sbj_rois(i).PCAed_surface_coords,filename);
%         case 2
%             filename = fullfile(path2AD,['Lhippo',num2str(cnt2),'.vtk']);
%             cnt2 = cnt2+1;
%             VTKPolyDataWriter(all_sbj_rois(i).PCAed_surface_coords,filename);
%     end
% end
% 
% %

%% Visualize projections of the different structures for NC/MCI/AD (summed
%% up and normalized

function updated_roi = UpdateFeatures(input_roi)
updated_roi = input_roi;
clear cur_prj prj0 prj1 prj2
%figure;suptitle('Canonical view of CSF');set(gcf,'color','w');
max_sizeX = -1;
max_sizeY = -1;
for i=1:length(input_roi)
    if isempty (input_roi(i).prj)
        stop = 1;
    end
    max_sizeX = max(size(input_roi(1,i).prj.p12{1},1),max_sizeX);
    max_sizeY = max(size(input_roi(1,i).prj.p12{1},2),max_sizeY);
end
if ~mod(max_sizeX,2)
    max_sizeX = max_sizeX + 1; %round to nearest odd number
end
if ~mod(max_sizeY,2)
    max_sizeY = max_sizeY + 1;
end
cnt0=0;cnt1=0;cnt2 = 0;cnt3=0;s0=0;s1=0;s2=0;s3=0;
sum0=zeros(max_sizeX,max_sizeY);sum1=zeros(max_sizeX,max_sizeY);sum2 = zeros(max_sizeX,max_sizeY);sum3 = zeros(max_sizeX,max_sizeY);
for i=1:length(input_roi)
    input_roi(i).features = [];
    switch input_roi(i).label
        case 0
            cur_prj = input_roi(1,i).prj.p12{1};cnt0=cnt0+1;
            [n,m] = size(cur_prj);
            addx = 0;addy = 0;
            if ~mod(n,2)
                addx = 1; %round to nearest odd number
            end
            if ~mod(m,2)
                addy = 1;
            end
            cur_prj = padarray(cur_prj,[addx,addy],0,'pre');
            [n,m] = size(cur_prj);
            
            startX = (max_sizeX-n)/2;
            startY = (max_sizeY-m)/2;
            cur_prj = padarray(cur_prj,[startX startY],0,'both');
            sum0 = sum0+cur_prj;
            s0(cnt0) = sum(sum(sum0));
            prj0(cnt0,:) = reshape(cur_prj,1,max_sizeX*max_sizeY);
            updated_roi(i).features = [CalculateMoment(cur_prj,1,1);CalculateMoment(cur_prj,1,2);CalculateMoment(cur_prj,2,2);entropy(cur_prj)];

        case 1
            cur_prj = input_roi(1,i).prj.p12{1};cnt1=cnt1+1;
            [n,m] = size(cur_prj);
            addx = 0;addy = 0;
            if ~mod(n,2)
                addx = 1; %round to nearest odd number
            end
            if ~mod(m,2)
                addy = 1;
            end
            cur_prj = padarray(cur_prj,[addx,addy],0,'pre');
            [n,m] = size(cur_prj);
            
            startX = (max_sizeX-n)/2;
            startY = (max_sizeY-m)/2;
            cur_prj = padarray(cur_prj,[startX startY],0,'both');
            sum1 = sum1+ cur_prj;

            s1(cnt1) = sum(sum(sum1));
            prj1(cnt1,:) = reshape(cur_prj,1,max_sizeX*max_sizeY);
            updated_roi(i).features = [CalculateMoment(cur_prj,1,1);CalculateMoment(cur_prj,1,2);CalculateMoment(cur_prj,2,2);entropy(cur_prj)];


        case 2
            cur_prj = input_roi(1,i).prj.p12{1};cnt2=cnt2+1;
            [n,m] = size(cur_prj);
            addx = 0;addy = 0;
            if ~mod(n,2)
                addx = 1; %round to nearest odd number
            end
            if ~mod(m,2)
                addy = 1;
            end
            cur_prj = padarray(cur_prj,[addx,addy],0,'pre');
            [n,m] = size(cur_prj);
            
            startX = (max_sizeX-n)/2;
            startY = (max_sizeY-m)/2;
            cur_prj = padarray(cur_prj,[startX startY],0,'both');
            sum2 = sum2+cur_prj;
            s2(cnt2) = sum(sum(sum2));
            prj2(cnt2,:) = reshape(cur_prj,1,max_sizeX*max_sizeY);
            updated_roi(i).features = [CalculateMoment(cur_prj,1,1);CalculateMoment(cur_prj,1,2);CalculateMoment(cur_prj,2,2);entropy(cur_prj)];
            
        case 3
            cur_prj = input_roi(1,i).prj.p12{1};cnt3=cnt3+1;
            [n,m] = size(cur_prj);
            addx = 0;addy = 0;
            if ~mod(n,2)
                addx = 1; %round to nearest odd number
            end
            if ~mod(m,2)
                addy = 1;
            end
            cur_prj = padarray(cur_prj,[addx,addy],0,'pre');
            [n,m] = size(cur_prj);
            
            startX = (max_sizeX-n)/2;
            startY = (max_sizeY-m)/2;
            cur_prj = padarray(cur_prj,[startX startY],0,'both');
            sum3 = sum3+cur_prj;
            s3(cnt3) = sum(sum(sum3));
            prj3(cnt3,:) = reshape(cur_prj,1,max_sizeX*max_sizeY);
            updated_roi(i).features = [CalculateMoment(cur_prj,1,1);CalculateMoment(cur_prj,1,2);CalculateMoment(cur_prj,2,2);entropy(cur_prj)];
    end
end

% 
% for i= 1: length(all_sbj_rois)
%     features(i,:) = updated_roi(i).features;
%    % all_sbj_rois(i).features = all_sbj_rois(i).features./max_features;
% end
% 
%  [i,~] = find(features>ones(length(features),1)*(median(features)+1.5*std(features)));
%     features(i,:) = [];
%     labels(i) = [];
% 
% % sum0 = sum0./cnt0;
% sum1 = sum1./cnt1;
% sum2 = sum2./cnt2;
% max_val = max([max(max(sum0)),max(max(sum1)),max(max(sum2))]);
% subplot(1,3,1);imagesc(sum0,[0 max_val]);colormap gray;axis equal;
% title('NC');xlim([0 max_sizeY]);ylim([0 max_sizeX]);set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
% 
% subplot(1,3,2);imagesc(sum1,[0 max_val]);colormap gray;axis equal;
% title('MCI');xlim([0 max_sizeY]);ylim([0 max_sizeX]);set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
% 
% subplot(1,3,3);imagesc(sum2,[0 max_val]);colormap gray;axis equal;
% title('AD');xlim([0 max_sizeY]);ylim([0 max_sizeX]);set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
% % %% Visualize
% % [num_subjects,num_features] = size(data);
% % k = 5;
% % l = num_features/k;
% % x0 = ones(size(data(labels == 0,:),1),1);
% % x1 = ones(size(data(labels == 1,:),1),1);
% % x2 = ones(size(data(labels == 2,:),1),1);
% % 
% % for i=1:num_features
% %     subplot(k,l,i);plot(0*x0,data_new(labels==0,i),'*','color',colors(8,:));hold on; set(gca, 'XTick', [],'YTick', []);
% % plot(0.5*x1,data_new(labels ==1,i),'*b');
% % plot(1*x2,data_new(labels ==2,i),'*r'); xlim([-0.5,1.5]);ylim([min(data_new(:,i)) max(data_new(:,i))]);hold off
% % 
% % end
% [num_subjects,num_features] = size(cur_features0);
% k = 2;
% l = num_features/k;
% x0 = ones(size(data(labels == 0,:),1),1);
% x1 = ones(size(data(labels == 1,:),1),1);
% x2 = ones(size(data(labels == 2,:),1),1);
% 
% for i=1:num_features
%     subplot(k,l,i);plot(0*x0,data_new(labels==0,i),'*','color',colors(8,:));hold on; set(gca, 'XTick', [],'YTick', []);
% plot(0.5*x1,data_new(labels ==1,i),'*b');
% plot(1*x2,data_new(labels ==2,i),'*r'); xlim([-0.5,1.5]);ylim([min(data_new(:,i)) max(data_new(:,i))]);hold off
% 
% end
% max_features = max([abs(cur_features0);abs(cur_features1);abs(cur_features2)]);
% cur_features00 = cur_features0./max_features;
% figure;
% subplot(321);plot(0*ones(12,1),cur_features0(:,1),'.g');hold on;plot(1*ones(11,1),cur_features1(:,1),'.b');hold on;plot(2*ones(11,1),cur_features2(:,1),'.r')
% subplot(322);plot(0*ones(12,1),cur_features0(:,2),'.g');hold on;plot(1*ones(11,1),cur_features1(:,2),'.b');hold on;plot(2*ones(11,1),cur_features2(:,2),'.r')
% subplot(323);plot(0*ones(12,1),cur_features0(:,3),'.g');hold on;plot(1*ones(11,1),cur_features1(:,3),'.b');hold on;plot(2*ones(11,1),cur_features2(:,3),'.r')
% subplot(324);plot(0*ones(12,1),cur_features0(:,4),'.g');hold on;plot(1*ones(11,1),cur_features1(:,4),'.b');hold on;plot(2*ones(11,1),cur_features2(:,4),'.r')
% subplot(325);plot(0*ones(12,1),cur_features0(:,5),'.g');hold on;plot(1*ones(11,1),cur_features1(:,5),'.b');hold on;plot(2*ones(11,1),cur_features2(:,5),'.r')
% [mean(cur_features0(:,2)),mean(cur_features1(:,2)),mean(cur_features2(:,2))]
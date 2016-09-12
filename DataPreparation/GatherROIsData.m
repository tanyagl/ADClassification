work_dir = '/home/tanyagl/data/subjects/ADNI/ten_methods';
%this function creates ROIs of different regions in the brain from
%aparc_aseg.mgz file created by FreeSurfer
% Set directory
fsDir = getenv('SUBJECTS_DIR');
dialog_title = 'select your data directory';
cur_dir = uigetdir(work_dir,dialog_title);
sprintf ('%s\n',cur_dir)
subject_list = getSubjectListInDir(cur_dir);
all_rois = [];
roi_name = {'17_Left-Hippocampus',...
    '53_Right-Hippocampus',...
    '5_Left-Inf-Lat-Vent',...
    '44_Right-Inf-Lat-Vent',...
    '43_Right-Lateral-Ventricle',...
    '14_3rd-Ventricle',...
    '2_Left-Cerebral-White-Matter',...
    '41_Right-Cerebral-White-Matter'};
label = 0; % 0 = CN; 1 = AD; 2 = MCIc; 3 = MCInc;
R = calcRotationMatrix(0,0,0);
for roi_num = 1:length(roi_name)
    all_sbj_rois = [];
    for sbj_num = 1:length(subject_list)
        rois_folder = fullfile(cur_dir,subject_list(sbj_num).name,'ROIs');
        roi_file = strcat(roi_name(roi_num),'.mat');
        path2roi = fullfile(rois_folder,cellstr(roi_file));
        if(~exist(path2roi{1},'file'))
            stop_here = 1;
        end
        roi = load(path2roi{1});
        all_sbj_rois(sbj_num).sbj_name = subject_list(sbj_num).name;
        all_sbj_rois(sbj_num).coords = roi.roi.coords;
        all_sbj_rois(sbj_num).roi_name = roi_file;
        all_sbj_rois(sbj_num).label = label;
        %(sbj_num).surface_coords =  GetSurfaceCoords(all_sbj_rois(sbj_num).coords);
        
        fprintf('now calculating %d for %s  \n',roi_num, subject_list(sbj_num).name)
        if(roi_num <= 6)
            
        all_sbj_rois(sbj_num).normalized_coords = all_sbj_rois(sbj_num).coords - repmat(calcCentroid(all_sbj_rois(sbj_num).coords),[length(all_sbj_rois(sbj_num).coords) 1]);
        [ all_sbj_rois(sbj_num).PCAed_coords,~,~ ] = nipals(all_sbj_rois(sbj_num).normalized_coords,3);
        
        all_sbj_rois(sbj_num).prj.p12 =  calcProjection(all_sbj_rois(sbj_num).PCAed_coords,R,1,2);
        all_sbj_rois(sbj_num).prj.p13 =  calcProjection(all_sbj_rois(sbj_num).PCAed_coords,R,1,3);
        all_sbj_rois(sbj_num).prj.p23 =  calcProjection(all_sbj_rois(sbj_num).PCAed_coords,R,2,3);
        
        max_dim = max(size(all_sbj_rois(sbj_num).prj.p12{1,1})); % all other dimensions are normalized according to this dimension
        [n,m]= find(all_sbj_rois(sbj_num).prj.p12{1,1});
        all_sbj_rois(sbj_num).prj_vec.p12 = [n/max_dim,m/max_dim];
        
        max_dim = max(size(all_sbj_rois(sbj_num).prj.p13{1,1})); % all other dimensions are normalized according to this dimension
        [n,m]= find(all_sbj_rois(sbj_num).prj.p13{1,1});
        all_sbj_rois(sbj_num).prj_vec.p13 = [n/max_dim,m/max_dim];
        
        
        max_dim = max(size(all_sbj_rois(sbj_num).prj.p23{1,1})); % all other dimensions are normalized according to this dimension
        [n,m]= find(all_sbj_rois(sbj_num).prj.p23{1,1});
        all_sbj_rois(sbj_num).prj_vec.p23 = [n/max_dim,m/max_dim];
        
        
        %% create a binary map for the projection
        % can think of it as distribution matrix
        img_size = 20;
        step = 1/img_size;
        m = zeros(img_size,img_size);
        for k=0:img_size-1
            for l=0:img_size-1
                dim1_range = [k*step (k+1)*step];%all vertices with x within this range will be projected onto one pixel
                dim2_range = [l*step (l+1)*step];
                m(k+1,l+1) = numel(find((all_sbj_rois(sbj_num).prj_vec.p12(:,1) > dim1_range(1)) & (all_sbj_rois(sbj_num).prj_vec.p12(:,1) < dim1_range(2)) &...
                    (all_sbj_rois(sbj_num).prj_vec.p12(:,2) > dim2_range(1)) & (all_sbj_rois(sbj_num).prj_vec.p12(:,2) < dim2_range(2))));
            end
        end
        all_sbj_rois(sbj_num).map.p12 = m;%reshape(m,100,1);
        
        
        % Calculate moments for the maps
        % first, normalize map such that the sum of all entries is 1.
        %then calculate moments
        
        cur_map = all_sbj_rois(sbj_num).map.p12;
        total = sum(sum(cur_map));
        all_sbj_rois(sbj_num).map_norm.p12 = cur_map./total;
        all_sbj_rois(sbj_num).features.p12 = [CalculateMoment(all_sbj_rois(sbj_num).map_norm.p12,1,1);CalculateMoment(all_sbj_rois(sbj_num).map_norm.p12,1,2);CalculateMoment(all_sbj_rois(sbj_num).map_norm.p12,2,1);CalculateMoment(all_sbj_rois(sbj_num).map_norm.p12,2,2);entropy(all_sbj_rois(sbj_num).map_norm.p12)];
        
        
        %% create a binary map for the projection
        % can think of it as distribution matrix
        img_size = 20;
        step = 1/img_size;
        m = zeros(img_size,img_size);
        for k=0:img_size-1
            for l=0:img_size-1
                dim1_range = [k*step (k+1)*step];%all vertices with x within this range will be projected onto one pixel
                dim2_range = [l*step (l+1)*step];
                m(k+1,l+1) = numel(find((all_sbj_rois(sbj_num).prj_vec.p13(:,1) > dim1_range(1)) & (all_sbj_rois(sbj_num).prj_vec.p13(:,1) < dim1_range(2)) &...
                    (all_sbj_rois(sbj_num).prj_vec.p13(:,2) > dim2_range(1)) & (all_sbj_rois(sbj_num).prj_vec.p13(:,2) < dim2_range(2))));
            end
        end
        all_sbj_rois(sbj_num).map.p13 = m;%reshape(m,100,1);
        
        
        % Calculate moments for the maps
        % first, normalize map such that the sum of all entries is 1.
        %then calculate moments
        
        cur_map = all_sbj_rois(sbj_num).map.p13;
        total = sum(sum(cur_map));
        all_sbj_rois(sbj_num).map_norm.p13 = cur_map./total;
        all_sbj_rois(sbj_num).features.p13 = [CalculateMoment(all_sbj_rois(sbj_num).map_norm.p13,1,1);CalculateMoment(all_sbj_rois(sbj_num).map_norm.p13,1,2);CalculateMoment(all_sbj_rois(sbj_num).map_norm.p13,2,1);CalculateMoment(all_sbj_rois(sbj_num).map_norm.p13,2,2);entropy(all_sbj_rois(sbj_num).map_norm.p13)];
        
        %% create a binary map for the projection
        % can think of it as distribution matrix
        img_size = 20;
        step = 1/img_size;
        m = zeros(img_size,img_size);
        for k=0:img_size-1
            for l=0:img_size-1
                dim1_range = [k*step (k+1)*step];%all vertices with x within this range will be projected onto one pixel
                dim2_range = [l*step (l+1)*step];
                m(k+1,l+1) = numel(find((all_sbj_rois(sbj_num).prj_vec.p23(:,1) > dim1_range(1)) & (all_sbj_rois(sbj_num).prj_vec.p23(:,1) < dim1_range(2)) &...
                    (all_sbj_rois(sbj_num).prj_vec.p23(:,2) > dim2_range(1)) & (all_sbj_rois(sbj_num).prj_vec.p23(:,2) < dim2_range(2))));
            end
        end
        all_sbj_rois(sbj_num).map.p23 = m;%reshape(m,100,1);
        
        
        % Calculate moments for the maps
        % first, normalize map such that the sum of all entries is 1.
        %then calculate moments
        
        cur_map = all_sbj_rois(sbj_num).map.p23;
        total = sum(sum(cur_map));
        all_sbj_rois(sbj_num).map_norm.p23 = cur_map./total;
        all_sbj_rois(sbj_num).features.p23 = [CalculateMoment(all_sbj_rois(sbj_num).map_norm.p23,1,1);CalculateMoment(all_sbj_rois(sbj_num).map_norm.p23,1,2);CalculateMoment(all_sbj_rois(sbj_num).map_norm.p23,2,1);CalculateMoment(all_sbj_rois(sbj_num).map_norm.p23,2,2);entropy(all_sbj_rois(sbj_num).map_norm.p23)];
        
        
        %% get dimensions of the roi
        all_sbj_rois(sbj_num).dim =sort(unique( [size(all_sbj_rois(sbj_num).prj.p12{1}) size(all_sbj_rois(sbj_num).prj.p23{1})]),'descend');
        
        end
    end
    %copy the structure to the bigger structure
    all_rois{roi_num} = all_sbj_rois;
    save(fullfile(cur_dir,'all_rois.mat'),'all_rois');

    
end

% if(plot_data)
%     colors = distinguishable_colors(length(all_sbj_rois));
%     figure;title('subject rois clustered according to diagnosis label')
% end
% for i=1:length(all_sbj_rois)
%     sbj_name = all_sbj_rois(i).name;
%     for j = 1:length(ID)
%         if strcmp(ID(j),sbj_name)
%             all_sbj_rois(i).label.diagnosis = output(j);
%             all_sbj_rois(i).label.gender = Sex(j);
%             all_sbj_rois(i).label.age = Age(j);
%             break;
%         end
%     end
%     if(plot_data)
%         switch all_sbj_rois(i).label.diagnosis
%             case 0
%                 color = colors(1,:);
%             case 1
%                 color = colors(2,:);
%             case 2
%                 color = colors(3,:);
%         end
%         plot3(all_sbj_rois(i).PCAed_coords(:,1),all_sbj_rois(i).PCAed_coords(:,2),all_sbj_rois(i).PCAed_coords(:,3),'.','color',color);hold on;legend('0','1','2');
%     end
% end
% if plot_data
%     figure;title('subject rois clustered according to gender label')
%     for i=1:length(all_sbj_rois)
%         switch all_sbj_rois(i).label.gender
%             case 0
%                 color = colors(1,:);
%             case 1
%                 color = colors(2,:);
%         end
%         plot3(all_sbj_rois(i).PCAed_coords(:,1),all_sbj_rois(i).PCAed_coords(:,2),all_sbj_rois(i).PCAed_coords(:,3),'.','color',color);hold on;legend('0','1')
%     end
%     
%     figure;title('roi projection in different subjects and the corresponding labels');
%     cnt0=0;cnt1=0;cnt2=0;
%     
%     max_sizeX = -1;
%     max_sizeY = -1;
%     for i=1:length(all_sbj_rois)
%         max_sizeX = max(size(all_sbj_rois(i).prj.p12{1},1),max_sizeX);
%         max_sizeY = max(size(all_sbj_rois(i).prj.p12{1},2),max_sizeY);
%     end
%     if ~mod(max_sizeX,2)
%         max_sizeX = max_sizeX + 1; %round to nearest odd number
%     end
%     if ~mod(max_sizeY,2)
%         max_sizeY = max_sizeY + 1;
%     end
%     
%     sum0=zeros(max_sizeX,max_sizeY);sum1=zeros(max_sizeX,max_sizeY);sum2 = zeros(max_sizeX,max_sizeY);
%     for i=1:length(all_sbj_rois)
%         switch all_sbj_rois(i).label.diagnosis
%             case 0
%                 cur_prj = all_sbj_rois(1,i).prj.p12{1};cnt0=cnt0+1;
%                 [n,m] = size(cur_prj);
%                 addx = 0;addy = 0;
%                 if ~mod(n,2)
%                     addx = 1; %round to nearest odd number
%                 end
%                 if ~mod(m,2)
%                     addy = 1;
%                 end
%                 cur_prj = padarray(cur_prj,[addx,addy],0,'pre');
%                 [n,m] = size(cur_prj);
%                 
%                 startX = (max_sizeX-n)/2;
%                 startY = (max_sizeY-m)/2;
%                 sum0(startX+1:startX+n,startY+1:startY+m) = cur_prj;
%                 
%                 
%             case 1
%                 cur_prj = all_sbj_rois(1,i).prj.p12{1};cnt1=cnt1+1;
%                 [n,m] = size(cur_prj);
%                 addx = 0;addy = 0;
%                 if ~mod(n,2)
%                     addx = 1; %round to nearest odd number
%                 end
%                 if ~mod(m,2)
%                     addy = 1;
%                 end
%                 cur_prj = padarray(cur_prj,[addx,addy],0,'pre');
%                 [n,m] = size(cur_prj);
%                 
%                 startX = (max_sizeX-n)/2;
%                 startY = (max_sizeY-m)/2;
%                 sum1(startX+1:startX+n,startY+1:startY+m) = cur_prj;
%                 
%             case 2
%                 cur_prj = all_sbj_rois(1,i).prj.p12{1};cnt2=cnt2+1;
%                 [n,m] = size(cur_prj);
%                 addx = 0;addy = 0;
%                 if ~mod(n,2)
%                     addx = 1; %round to nearest odd number
%                 end
%                 if ~mod(m,2)
%                     addy = 1;
%                 end
%                 cur_prj = padarray(cur_prj,[addx,addy],0,'pre');
%                 [n,m] = size(cur_prj);
%                 
%                 startX = (max_sizeX-n)/2;
%                 startY = (max_sizeY-m)/2;
%                 sum2(startX+1:startX+n,startY+1:startY+m) = cur_prj;
%                 
%         end
%     end
%     sum0 = sum0./cnt0;
%     sum1 = sum1./cnt1;
%     sum2 = sum2./cnt2;
%     max(max(sum2))
%     subplot(131);imagesc(sum0,[0 1.5]);colormap gray;axis equal;
%     subplot(132);imagesc(sum1,[0 1.5]);colormap gray;axis equal;
%     
%     subplot(133);imagesc(sum2,[0 1.5]);colormap gray;axis equal;
%     
% end

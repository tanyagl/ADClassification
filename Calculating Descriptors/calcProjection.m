function prj_data = calcProjection(coords,R, dim1, dim2)
%calculate projection on the segment onto dim1-dim2 plane; 
%dim values:1-x,2-y,3-z
% R is the rotation matrix for the axes

% segmentData = getSegmentData(brainList, sparseIndicatorsList, whichBrain, whichSide, whichSegment);
% if(isempty(segmentData.vertices))
%     prj_data = [];
% else
%     %first, get the coords of all vertices that belong to the segment
%     % vertices = getSegmentVertices(sparseIndicatorsList, whichBrain, whichSide, whichSegment);
%     % coords = getSegmentVerticesCoords(brainList,whichBrain, vertices);
%     % triangles = getSegmentTriangles(brainList, whichBrain, vertices);
%     %multiplying by 10000 to get values suitable for pixel location map - any
%     %better ideas? (will bin into pixels)
% 
%     %calculate PCA
%     %first, standartize the data by subtracting the mean (centroid) and
%     %dividing by std
%     coords = segmentData.coords;
%     normalized_coords = coords - repmat((R*segmentData.centroid')',[length(coords) 1]);
%     %normalized_coords = normalized_coords./repmat(std(normalized_coords),[length(segmentData.coords) 1]);
% 
%     [V,score, eigv] = princomp(normalized_coords);
    coords = (R*coords')';
    if(isempty(coords))
        stop_here = 1;
    end

    % coords = segmentData.coords;
    % coords = (R*coords'*10000)';

    % next, find the size of the "canvas": [xmin,xmax] X [zmin,zmax]
    max_coord = max(coords);
    min_coord = min(coords);

    %project onto xz plane:
    % ds_factor = ceil(max(abs(ceil(max_coord(1)) - floor(min_coord(1))), abs(ceil(max_coord(3)) - floor(min_coord(3))))/128);%downsampling factor - binning of the canvas. needs to be an odd number
    % 
    % xz_projection = zeros(128,128);
    prj_map = zeros(abs(ceil(max_coord(dim1)) - floor(min_coord(dim1))), abs(ceil(max_coord(dim2)) - floor(min_coord(dim2))));
    prj_map_thickness = prj_map;
    dim3 = setdiff([1 2 3],[dim1 dim2]);
    for i = 1:length(coords)
        %for each location in the dim1-dim2 plane find the height along dim3 direction
        %(may contain multiple "segments" due to folding of the mesh
        pixel_loc = floor(coords(i,:));
    %     x_range = [pixel_loc(1)-floor(ds_factor/2) pixel_loc(1)+floor(ds_factor/2)];%all vertices with x within this range will be projected onto one pixel
    %     z_range = [pixel_loc(3)-floor(ds_factor/2) pixel_loc(3)+floor(ds_factor/2)];
        dim1_range = [pixel_loc(dim1) pixel_loc(dim1)+1];%all vertices with dim1 within this range will be projected onto one pixel
        dim2_range = [pixel_loc(dim2) pixel_loc(dim2)+1];

        k = find((coords(:,dim1) > dim1_range(1)) & (coords(:,dim1) < dim1_range(2)));
        m = find((coords(:,dim2) > dim2_range(1)) & (coords(:,dim2) < dim2_range(2)));
        prj = intersect(k,m); %index of vertex projected onto that pixel
        coords_on_prj = [min(max(pixel_loc(dim1) - floor(min_coord(dim1)),1),size(prj_map,1)),min(max(pixel_loc(dim2) - floor(min_coord(dim2)),1),size(prj_map,2))];

        prj_map(coords_on_prj(1),coords_on_prj(2)) = prj_map(coords_on_prj(1),coords_on_prj(2)) + 1;
        prj_map_thickness(coords_on_prj(1),coords_on_prj(2)) = prj_map(coords_on_prj(1),coords_on_prj(2)) + abs(pixel_loc(dim3));

    end
    i = 2;
    prj_data{1} = prj_map;
    prj_data{2} = prj_map_thickness;
end

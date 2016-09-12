function segmentData = getSegmentData(brainList, sparseIndicatorsList, whichBrain, whichSide, whichSegment)
segmentData = {};
segmentData.vertices = getSegmentVertices(sparseIndicatorsList, whichBrain, whichSide, whichSegment);
if(~isempty(segmentData.vertices))
    segmentData.coords = getSegmentVerticesCoords(brainList,whichBrain, segmentData.vertices);
    segmentData.triangles = getSegmentTriangles(brainList, whichBrain, segmentData.vertices);

    %calc segment Centroid:
    nominator = 0;
    denominator = 0;

    for face = 1:length(segmentData.triangles)
        face_vertices = segmentData.triangles(face,:);
        [~,indices] = intersect(segmentData.vertices, face_vertices);

        face_vertices_coords = segmentData.coords(indices,:);
        if(size(face_vertices_coords,1)==3)%add to centroid calculation only if all three vertices of the face are in the segment
            % compute individual vector  s
            v12 = bsxfun(@minus, face_vertices_coords(2,:), face_vertices_coords(1,:));
            v13 = bsxfun(@minus, face_vertices_coords(3,:), face_vertices_coords(1,:));

            % compute area from cross product
            face_area = norm(cross(v12,v13),2); %actually twice the area of a triangle
            face_avg = sum(face_vertices_coords,1)/3; 
            nominator = nominator + face_area*face_avg;
            denominator = denominator + face_area;
        end
    end
    segmentData.centroid = nominator/denominator;
end
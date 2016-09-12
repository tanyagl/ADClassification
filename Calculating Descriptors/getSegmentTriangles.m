function segment_triangles = getSegmentTriangles(brainList, whichBrain, vertices)
all_triangles = brainList{1,whichBrain}.triangles;
%all_triangles is organized such that all faces that start from a specific
%vertex are written in one location. So in terms of complexity - we can go
%over vertices list (couple of hundred per segment) and copy all faces that
%belong to that vertex.
a = 1;
face_in_segment = zeros(length(all_triangles),1);
for k = 1:length(vertices)
   [i,j] = find(all_triangles == vertices(k));
   face_in_segment(i) = face_in_segment(i)+1;%increase counter of vertices in segment for that particular face
end
segment_triangles = all_triangles(face_in_segment > 1,:);
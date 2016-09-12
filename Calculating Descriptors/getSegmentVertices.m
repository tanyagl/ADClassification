function vertices = getSegmentVertices(sparseIndicatorsList, whichBrain, whichSide, whichSegment)
% get a list of all *vertices* that belong to a *whichSegment* in the
% *whichSide* of the *whichBrain* 
[vertex_no, segment] = find(sparseIndicatorsList{whichBrain}{whichSide} == 1) ;%only taking the vertices that belong to one segment only;
vertices = vertex_no(segment==whichSegment);


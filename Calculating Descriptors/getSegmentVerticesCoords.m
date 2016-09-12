function coords = getSegmentVerticesCoords(brainList, whichBrain, vertices)
coords = [];
coords = [coords; brainList{whichBrain}.vertices(vertices,:)];
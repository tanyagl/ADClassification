AD17normalized_coords = LHippoAD.coords - repmat(calcCentroid(LHippoAD.coords),[length(LHippoAD.coords) 1]);
[ AD17PCAed_coords,~,~ ] = nipals(AD17normalized_coords,3);
R = calcRotationMatrix(0,0,0);

AD17p12 =  calcProjection(AD17PCAed_coords,R,1,2);
AD17p13 =  calcProjection(AD17PCAed_coords,R,1,3);
AD17p23 =  calcProjection(AD17PCAed_coords,R,2,3);

NC17normalized_coords = LHippoNC.coords - repmat(calcCentroid(LHippoNC.coords),[length(LHippoNC.coords) 1]);
[ NC17PCAed_coords,~,~ ] = nipals(NC17normalized_coords,3);
NC17p12 =  calcProjection(NC17PCAed_coords,R,1,2);
NC17p13 =  calcProjection(NC17PCAed_coords,R,1,3);
NC17p23 =  calcProjection(NC17PCAed_coords,R,2,3);
AD17p12{1} = padarray(flipud(AD17p12{1}),[3,1],0,'post');

figure;suptitle('projection of Left Hippocampus of NC (left) and AD (right)');
subplot(121);imagesc(NC17p12{1});colormap bone;set(gca, 'XTick', [],'YTick', [], 'YTickLabel',[], 'XTickLabel', []);
subplot(122);imagesc(AD17p12{1});colormap bone;set(gca, 'XTick', [],'YTick', [], 'YTickLabel',[], 'XTickLabel', []);

NC5normalized_coords = LiLVentNC.coords - repmat(calcCentroid(LiLVentNC.coords),[length(LiLVentNC.coords) 1]);
[ NC5PCAed_coords,~,~ ] = nipals(NC5normalized_coords,3);
NC5p12 =  calcProjection(NC5PCAed_coords,R,1,2);
NC5p13 =  calcProjection(NC5PCAed_coords,R,1,3);
NC5p23 =  calcProjection(NC5PCAed_coords,R,2,3);

AD5normalized_coords = LiLVentAD.coords - repmat(calcCentroid(LiLVentAD.coords),[length(LiLVentAD.coords) 1]);
[ AD5PCAed_coords,~,~ ] = nipals(AD5normalized_coords,3);
AD5p12 =  calcProjection(AD5PCAed_coords,R,1,2);
AD5p13 =  calcProjection(AD5PCAed_coords,R,1,3);
AD5p23 =  calcProjection(AD5PCAed_coords,R,2,3);


figure;suptitle('projection of Left Inferior Lateral Ventricle of NC (left) and AD (right)');subplot(121);imagesc(NC5p12{1});colormap bone;
set(gca, 'XTick', [],'YTick', [], 'YTickLabel',[], 'XTickLabel', []);
subplot(122);imagesc(AD5p12{1});colormap bone;
set(gca, 'XTick', [],'YTick', [], 'YTickLabel',[], 'XTickLabel', []);

figure;plot3(NC5PCAed_coords(:,1),NC5PCAed_coords(:,2),NC5PCAed_coords(:,3),'.')
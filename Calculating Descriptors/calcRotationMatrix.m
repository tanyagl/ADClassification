%calculate rotation matrices
function R = calcRotationMatrix(thetaX,thetaY,thetaZ)
%theta should be given in degrees!
Rx = [1 0 0;0 cosd(thetaX) -sind(thetaX);0 sind(thetaX) cosd(thetaX)];
Ry = [cosd(thetaY) 0 sind(thetaY);0 1 0;-sind(thetaY) 0 cosd(thetaY)];
Rz = [cosd(thetaZ) -sind(thetaZ) 0;sind(thetaZ) cosd(thetaZ) 0; 0 0 1];
R = Rx*Ry*Rz;

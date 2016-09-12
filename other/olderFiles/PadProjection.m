function [prj,sum] = PadProjection(cur_prj, max_sizeX, max_sizeY,sum)
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
sum = sum+cur_prj;
prj = reshape(cur_prj,1,max_sizeX*max_sizeY);
image_dir = 'C:\MyWork\Stanford\Documents\fascicle_fmaps\figures\subjects';
files = dir(image_dir);
for file_num = 3:length(files)
M = imread(fullfile(image_dir,files(file_num).name));
if (size(M,1)> 850 && size(M,2) > 1000)
M_new = M(50:849,170:999,:);
else
    M_new = M;
end
imwrite(M_new, fullfile(image_dir,'cropped',files(file_num).name));
end
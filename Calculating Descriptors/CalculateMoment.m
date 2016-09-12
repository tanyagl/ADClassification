function moment_mn = CalculateMoment(matrix, m, n)
%calculate rows and column averages
row_avg = 0;
col_avg = 0;
moment_mn = 0;
[rows,cols] = size(matrix);
for i=1:rows
    for j=1:cols
        row_avg  = row_avg + i*matrix(i,j);
        col_avg  = col_avg + j*matrix(i,j);
    end
end

for i=1:rows
    for j=1:cols
        moment_mn = moment_mn + ((i-row_avg)^m)*((j-col_avg)^n)*matrix(i,j);
    end
end
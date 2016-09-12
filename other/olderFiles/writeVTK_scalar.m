function writeVTK_scalar(filename,x,y,z,varargin)
% writeVTK_scalar   Write 3D scalar data to a VTK
%
% syntax: writeVTK_scalar(filename,x,y,z,'field1',field1,...,'fieldn',fieldn), where
%    x,y,z are 1D coordinate data vectors of size NX, NY, NZ, respectively
%    'fieldn', and fieldn are an arbitary number of names and NX x NY x NZ
%        fields to be written to the VTK. The name 'fieldn' is what is seen
%        by paraview and doesn't have to match the variable's name in
%        Matlab.


% parse some input

% if nargin < 6
%     error('syntax: writeVTK_scalar(filename,x,y,z,''field1'',field1,...,''fieldn'',fieldn)')
% end

if ~ischar(filename)
    error('First argument should be a string.')
end

if any(filename(end-3:end) ~= '.vtk')
    filename = [filename '.vtk'];
end

if (~isnumeric(x) || ~isnumeric(y) || ~isnumeric(z) ...
        || ~isvector(x) || ~isvector(y) || ~isvector(z))
    error('Coordinate data need to be numeric vectors.');
end

NX = length(x);
NY = length(y);
NZ = length(z);

nr_of_elements=NX*NY*NZ;

if (mod(length(varargin),2) == 0)
    nFields = length(varargin)/2;
    
    for n = 1:nFields
        if ~ischar(varargin{2*n-1})
            error('Key number %d is not a string.',n);
        end
        if ~isnumeric(varargin{2*n})
            error('Value number %d is not numeric.',n);
        end
        
        sz = size(varargin{2*n});
        if length(sz) ~=2 && length(sz) ~= 3
            error('Value number %d is not 2D or 3D.',n);
        end
            
        if prod(sz) ~= nr_of_elements
            error('Value number %d is %dx%dx%d, but should be %dx%dx%d.',...
                n,sz,NX,NY,NZ);
        end
    end
else
    error('syntax: writeVTK_scalar(filename,x,y,z,''field1'',field1,...,''fieldn'',fieldn)')
end
%%

fid = fopen(filename, 'w'); 

%ASCII file header
fprintf(fid, '# vtk DataFile Version 3.0\n');
fprintf(fid, 'VTK from Matlab\n');
fprintf(fid, 'BINARY\n');
fprintf(fid, 'DATASET RECTILINEAR_GRID\n');
fprintf(fid, 'DIMENSIONS %d %d %d\n',NX,NY,NZ);

fprintf(fid, 'X_COORDINATES %d float\n',NX);
fwrite(fid,x,'float','b');

fprintf(fid, '\nY_COORDINATES %d float\n',NY);
fwrite(fid,y,'float','b');

fprintf(fid, '\nZ_COORDINATES %d float\n',NZ);
fwrite(fid,z,'float','b');

fprintf(fid, '\nPOINT_DATA %d\n',nr_of_elements);

% write out the scalar data
for n = 1:nFields
    fprintf(fid,'\nSCALARS %s float\n',varargin{2*n-1});
    fprintf(fid, 'LOOKUP_TABLE default\n');
    fwrite(fid,varargin{2*n},'float','b');
end

fclose(fid);
function GenerateMatFileFromEZ4U(arg1,arg2,arg3,arg4,arg5)
%function varargout = GenerateMatFileFromEZ4U(arg1,arg2,arg3,arg4,arg5)

% GenerateMatFileFromEZ4U() 
% GenerateMatFileFromEZ4U('MyDirectory')
% GenerateMatFileFromEZ4U(...,{'MyFile1.dcm' 'MyFile2.dcm'...})
% GenerateMatFileFromEZ4U(...,face_nodes,inner_nodes)
% GenerateMatFileFromEZ4U(...,face_nodes1d)
% matFiles = GenerateMatFileFromEZ4U(...)
% 
% The function GenerateMatFileFromEZ4U creates a .mat file from one or 
% various .dcm files that have to contain the same format as an output EZ4U
% mesh file (normally it's generated by clicking the "Export a Mesh file"
% option in the EZ4U graphic interface's menu. In this case don't forget to
% add to the file the .dcm extension).
% 
% Loading these .mat files the position matrix (X), the element information 
% (elemInfo) and the connectivity matrices (T) will be created in the 
% current workspace. For the boundary, the connectivity matrices' name will 
% have the Tb_attributeName form, and for the submeshes the T_attributeName 
% form. The attributeName will be the same that has been assigned in EZ4U.
%
% BY DEFAULT, the considered local numbering of the nodes is as follows:
%
%         QUA elements                 TRI elements             
%
%               7                           3
%         4 *---x---* 3                     *                1D elements
%           |       |                      / \
%         8 x   x   x 6                 6 x 7 x 5           1 *---x---* 3
%           |    9  |                    /  x  \                  2
%         1 *---x---* 2               1 *---x---* 2
%               5                           4
%
% For the inner nodes, the order follows an upper-piramidal numbering like
% this one:
%
%                            i+(nOfInnerNodes-1)                           
%                                    \
%                                     \
%                            i+n+u+2-->i+n+u+m+2
%                                m nodes
%                                   \
%                                    \
%                                     \
%                                      \
%                            i+n+1------>i+n+u+1
%                                u nodes 
%                                  \
%                                   \
%                                    \
%                                     \
%                                      \
%                                       \
%                             i----------->i+n
%                                 n nodes
%
% The function GenerateMatFileFromEZ4U allows the user to use both default
% or other local numbering. See the syntax below. 
%
% SYNTAX I: if you want to use the default local numbering
% --------------------------------------------------------
%   
%   1) GenerateMatFileFromEZ4U() reads and creates a .mat file from all
%      .dcm mesh files that are into the current directory.
% 
%   2) GenerateMatFileFromEZ4U(MyDirectory) reads and creates a .mat file
%      from all .dcm mesh files that are into the specified string path  
%      'MyDirectory'. This path indicates the location of the files from 
%      the current directory.
%
%   3) GenerateMatFileFromEZ4U(MyFile.dcm) reads and creates a .mat file
%      from the specified mesh file that is into the current directory.
%      The input argument could be a string 'MyFile.dcm' or a cell of
%      strings {'MyFile1.dcm' 'MyFile2.dcm'...} if you want to read a list
%      of mesh files.
% 
%   4) GenerateMatFileFromEZ4U(MyDirectory,MyFile.dcm) combines both
%      previous syntax 2) and 3).
%
%   5) matFiles = GenerateMatFileFromEZ4U(...) returns a cell of strings
%      {'matFile1.mat' 'matFile2.mat'...} with the name of 
%      the created .mat files. You can make use of any previous syntax.
%
% SYNTAX II: if you want to use your own local numbering
% ------------------------------------------------------
%   
%   6) GenerateMatFileFromEZ4U(...,face_nodes,inner_nodes) uses any of the
%      previous 1) to 5) syntax and read the .dcm mesh files using the 2D 
%      numbering specified by the input arguments face_nodes and
%      inner_nodes. Remind that this syntax uses the default 1D numbering.
%
%      The face_nodes argument has to be a (nOfFaces x nOfNodesPerFace)
%      matrix where [nOfFaces,nOfNodesPerFace] > 1. This matrix indicates 
%      the order of the face nodes in the reference element. The numbering 
%      of the faces has to be given in a clockwise sense beginning from the 
%      lower face, as follows:
%
%                       QUA elements                 TRI elements     
%
%                             3
%                         *-------*                       *                
%                         |       |                      / \
%                       4 |       | 2                 3 /   \ 2            
%                         |       |                    /     \               
%                         *-------*                   *-------* 
%                             1                           1
%
%      For a given face, the column index of the matrix indicates the
%      global position of the node in the reference element. This global
%      numbering has to ascend in a clockwise sense too.
% 
%      The inner_nodes argument has to be vector with nOfInnerNodes
%      elements. Each index of this vector indicates the global position of
%      the node in the reference element. This global position has to be
%      given with the same default numbering as EZ4U (see the default
%      upper-piramidal numbering).
%
%      NOTE: if the element has not inner nodes, use an empty array
%      inner_nodes = [].
%
%   7) GenerateMatFileFromEZ4U(...,face_nodes1d) uses any of the previous
%      1) to 5) syntax and read the .dcm mesh files using the 1D numbering
%      specified by the input argument face_nodes1d. Remind that this
%      syntax uses the default 2D numbering.
%
%      The face_nodes1d argument has to be a vector with nOf1dNodes
%      elements where nOf1dNodes > 1. Each index of this vector indicates
%      the global position of the node in the reference element. This
%      global numbering has to ascend from left to right as follows:
%
%                             (for N nodes per 1D element)
%                           *---x---x---x-----....----x---*
%                           1   2   3   4            N-1  N  
% 
%   8) GenerateMatFileFromEZ4U(...,face_nodes,inner_nodes,face_nodes1d)
%      combines both previous syntax 6) and 7). 
%
% EXAMPLE
% -------
%
%                2D element                            
%
%               23   24   25                          
%         3 *----x----x----x----* 4                     
%           |                   |
%        18 x    o    o    o    x 22                   1D element
%           |   19   20   21    |                      
%        13 x    o    o    o    x 17            1 *----x----x----x----* 2
%           |   14   15   16    |                      3    4    5
%         8 x    o    o    o    x 12                  
%           |    9   10   11    | 
%         2 *----x----x----x----* 1         
%                5    6    7
% 
% If you want to read three Q4 mesh files (25 element-noded quadrilateral
% mesh) located into "currentDirectory/Mesh Files/EZ4U mesh files" and  
% making use of the local numbering shown in the previous figure, type
% GenerateMatFileFromEZ4U(path,files,fn,in,fn1d), where:
% 
% path = 'Mesh Files/EZ4U mesh files' (string array)
% files = {'MyFile1.dcm' 'MyFile2.dcm' 'MyFile3.dcm'} (cell of strings array)
% fn = [2  5  6  7  1
%       1 12 17 22  4
%       4 25 24 23  3
%       3 18 13  8  2] (numeric matrix array)
% in = [9 10 11 14 15 16 19 20 21] or transpose (numeric vector array)
% fn1d = [1 3 4 5 2] or transpose (numeric vector array)
%
%
%*-----------------------------------------------------------------------*
%| IMPORTANT NOTE: this function only works with 2D meshes and a constant| 
%|                 element type (no mixed elements).                     |
%|                                                                       |
%| Last tested version of Matlab: 7.5.0.338 (R2007b)                     |
%| Last tested version of EZ4U: first version that incloudes option      |
%|                              save/load session in experimental menu   |
%|                                                                       |
%| January 2009 by David Modesto (david.modesto@upc.edu)                 |
%| LaCaN (Laboratori de Calcul Numeric)                                  |
%| UPC (Universitat Politecnica de Catalunya)                            |
%*-----------------------------------------------------------------------*


%Checking output variable's call
if nargout > 1
   error(['You are calling more than one output variable. There is only '...
       'a cell array as an output variable'])
end


%Checking input syntax and detecting EZ4U mesh files
switch nargin
   case 1
       if isCellStringOrChar(arg1)
           meshFiles = getEZ4UMeshFiles(arg1);
       elseif isNumVector(arg1)
           meshFiles = getEZ4UMeshFiles();
           face_nodes1d = arg1;
       else error('Wrong input arguments. Check help to correctly use the syntax')
       end
   case 2
       if isCellStringOrChar(arg1,arg2)
           meshFiles = getEZ4UMeshFiles(arg1,arg2);
       elseif isNumMatrix(arg1) && isVector(arg2)
           meshFiles = getEZ4UMeshFiles();
           face_nodes = arg1; inner_nodes = arg2; 
       elseif isCellStringOrChar(arg1) && isNumVector(arg2)
           meshFiles = getEZ4UMeshFiles(arg1);
           face_nodes1d = arg2;
       else error('Wrong input arguments. Check help to correctly use the syntax')
       end
   case 3
       if isCellStringOrChar(arg1,arg2) && isNumVector(arg3)
           meshFiles = getEZ4UMeshFiles(arg1,arg2);
           face_nodes1d = arg3;
       elseif isNumMatrix(arg1) && isVector(arg2) && isNumVector(arg3)
           meshFiles = getEZ4UMeshFiles();
           face_nodes = arg1; inner_nodes = arg2; face_nodes1d = arg3;
       elseif isCellStringOrChar(arg1) && isNumMatrix(arg2) && isVector(arg3)
           meshFiles = getEZ4UMeshFiles(arg1);
           face_nodes = arg2; inner_nodes = arg3;
       else error('Wrong input arguments. Check help to correctly use the syntax')
       end
   case 4
       if isCellStringOrChar(arg1,arg2) && isNumMatrix(arg3) && isVector(arg4)
           meshFiles = getEZ4UMeshFiles(arg1,arg2);
           face_nodes = arg3; inner_nodes = arg4;
       elseif isCellStringOrChar(arg1) && isNumMatrix(arg2) && isVector(arg3)...
               && isNumVector(arg4)
           meshFiles = getEZ4UMeshFiles(arg1);
           face_nodes = arg2; inner_nodes = arg3; face_nodes1d = arg4;
       else error('Wrong input arguments. Check help to correctly use the syntax')
       end
   case 5
       if isCellStringOrChar(arg1,arg2) && isNumMatrix(arg3) && isVector(arg4)...
               && isNumVector(arg5)
           meshFiles = getEZ4UMeshFiles(arg1,arg2);
           face_nodes = arg3; inner_nodes = arg4; face_nodes1d = arg5;
       else error('Wrong input arguments. Check help to correctly use the syntax')
       end
   otherwise
       meshFiles = getEZ4UMeshFiles();
end
nOfMeshFiles = numel(meshFiles);


%Reading mesh files and creating .mat files
matFiles = cell(1,nOfMeshFiles);
for ifile = 1:nOfMeshFiles
   ez4uFile = meshFiles{ifile};

   %Open EZ4U mesh file
   fid = fopen(ez4uFile,'r');

   %Reading header
   header = fscanf(fid,'%d',3);
   nOfNodes = header(1);
   nOfElements = header(2);
   nOfAttributes = header(3);

   %Reading nodes
   dim = 2;
   X = zeros(nOfNodes,dim);
   for iNode = 1:nOfNodes
       lineVar = fscanf(fid,'%f',4);
       X(iNode,:) = lineVar(2:dim+1);
   end

   %Element information
   nOfInfo = 7;
   Info = fscanf(fid,'%d',nOfInfo);
   nOfFaces = Info(4);
   nOfEdgeNodes = Info(5);
   nOfInnerNodes = Info(6);
   nOfElementNodes = nOfInnerNodes + nOfEdgeNodes*nOfFaces + nOfFaces;
   elemType = 4 - nOfFaces;

   %Reading connectivities for all the mesh
   T = zeros(nOfElements,nOfElementNodes);
   firstRow = fscanf(fid,'%d',nOfElementNodes);
   T(1,:) = firstRow';
   lineSize = nOfInfo + nOfElementNodes;
   nOfElemNodesPos = nOfInfo+1:nOfElementNodes+nOfInfo;
   for iElem = 2:nOfElements
       lineVar = fscanf(fid,'%d',lineSize);
       T(iElem,:) = lineVar(nOfElemNodesPos)';
   end

   %Reading connectivities for the boundary and submeshes (attributes)
   indexSubMesh = 0;
   indexBoundary = 0;
   if nOfAttributes
       attribInfo = cell(2,nOfAttributes,2);
       for iAttrib = 1:nOfAttributes
           lineIntegers = fscanf(fid,'%d',4);
           nOfMarkedElements = lineIntegers(4);
           attribType = lineIntegers(2);
           attributeName = fscanf(fid,'%s',1);

           if attribType == 2 %Submeshes (2D faces)
               indexSubMesh = indexSubMesh + 1;
               attribInfo{1,indexSubMesh,1} = zeros(nOfMarkedElements,nOfElementNodes);
               for item = 1:nOfMarkedElements
                   lineVar = fscanf(fid,'%d',3);
                   element = lineVar(1);
                   attribInfo{1,indexSubMesh,1}(item,:) = T(element,:);
               end

               %Attribute's name
               attribInfo{1,indexSubMesh,2} = ['T_' attributeName];

           elseif attribType == 1 %Boundaries (2D edges)
               indexBoundary = indexBoundary + 1;
               attribInfo{2,indexBoundary,1} = zeros(nOfMarkedElements,nOfEdgeNodes+2);
               for item = 1:nOfMarkedElements
                   lineVar = fscanf(fid,'%d',3);
                   element = lineVar(1);
                   face = lineVar(2);
                   elementNodes = [T(element,1:nOfFaces) zeros(1,nOfEdgeNodes)...
                        T(element,nOfFaces+1:end)];
                   elementFaces = [elementNodes(1:nOfFaces) elementNodes(1)];
                   vertexNodes = elementFaces(face:face+1);
                   ini = nOfFaces + face*nOfEdgeNodes + 1;
                   fin = ini + nOfEdgeNodes - 1;
                   innerNodes = elementNodes(ini:fin);
                   attribInfo{2,indexBoundary,1}(item,:) = [vertexNodes(1) innerNodes vertexNodes(2)];
               end

               %Attribute's name
               attribInfo{2,indexBoundary,2} = ['Tb_' attributeName];

           else 
               error('Attribute type not implemented')
           end
       end
   end

   %Applying the given local numbering to the boundary (if it's necessary)
   if exist('face_nodes1d','var')
       nOfNodes1d = size(attribInfo{2,1,1},2);
       givenNOfNodes1d = length(face_nodes1d);
       if (nOfNodes1d ~= givenNOfNodes1d) && nOfNodes1d
           error(['Wrong argument face_nodes1d for the file "' ez4uFile...
                '". You specified a wrong number of nodes'])
       end
       for item = 1:indexBoundary
           attribInfo{2,item,1}(:,face_nodes1d) = attribInfo{2,item,1};
       end

       %info to store in elemInfo
       elemFaceNodes1d = face_nodes1d;
   else
       elemFaceNodes1d = 1:nOfEdgeNodes+2;
   end

   %Applying the given local numbering to the mesh and submeshes (if it's necessary)
   if exist('face_nodes','var') && exist('inner_nodes','var') 
       [givenNOfFaces,givenNOfFaceNodes] = size(face_nodes);
       givenNOfInnerNodes = length(inner_nodes);
       if givenNOfFaceNodes ~= nOfEdgeNodes+2
           error(['Wrong argument face_nodes for the file "' ez4uFile...
               '". You specified a wrong number of face nodes'])
       elseif givenNOfFaces ~= nOfFaces
           error(['Wrong argument face_nodes for the file "' ez4uFile...
               '". You specified a wrong number of faces'])
       elseif givenNOfInnerNodes ~= nOfInnerNodes
           error(['Wrong argument inner_nodes for the file "' ez4uFile...
                '". You specified a wrong number of inner nodes'])
       end
       givenOrder = getEZ4UOrder(face_nodes,inner_nodes,nOfFaces,nOfEdgeNodes);

       %Complete mesh
       T(:,givenOrder) = T;

       %Submeshes
       for item = 1:indexSubMesh
           attribInfo{1,item,1}(:,givenOrder) = attribInfo{1,item,1};
       end

       %info to store in elemInfo
       elemFaceNodes = face_nodes;
   else
       elemFaceNodes = zeros(nOfFaces,nOfEdgeNodes+2);
       elemVertices = 1:nOfFaces;
       elemEdgeNodes = nOfFaces+1:nOfEdgeNodes*nOfFaces + nOfFaces;
       elemFaceNodes(:,1) = elemVertices';
       elemFaceNodes(:,end) = [elemVertices(2:end) 1]';
       aux = 0;
       for icolumn = 2:nOfEdgeNodes+1
           ini = 1 + aux;
           fin = ini + nOfEdgeNodes*(nOfFaces - 1);
           elemFaceNodes(:,icolumn) = elemEdgeNodes(ini:nOfEdgeNodes:fin)';
           aux = aux + 1;
       end
   end

   %Creating submeshes and boundary conectivities in the current workspace
   index = [indexSubMesh indexBoundary];
   for iattrib = 1:length(index)
       for item = 1:index(iattrib)
           name = attribInfo{iattrib,item,2};
           var2save = genvarname(name);
           evalc([var2save '=attribInfo{iattrib,item,1}']);
       end
   end     

   %Store the element information into a structure
   elemInfo = struct('type',elemType,'nOfNodes',nOfElementNodes,...
       'faceNodes',elemFaceNodes,'faceNodes1d',elemFaceNodes1d);

   %Close EZ4U mesh file
   fclose(fid);

   %Creating .mat file
   matFileName = [ez4uFile(1:end-4) '.mat'];
   matFiles{ifile} = matFileName;
   save(matFileName,'X','T*','elemInfo')
   clear X T* elemInfo
end


%Assign output variable
if nargout == 1, varargout = {matFiles};
else varargout = [];
end


%_______________________________________________________________________
% HELPER FUNCTIONS TO CHECK THE KIND OF ARRAY THE DATA IS AND MAKE THIS 
% CHECKING MORE READABLE

function isIt = isCellStringOrChar(varargin)

isIt = true;
for i = 1:length(varargin)
   data = varargin{i};
   if iscell(data)
       for j = 1:numel(data)
           if ~ischar(data{j}), isIt = false; return, end
       end
   elseif ischar(data)
   else isIt = false; return
   end
end

%---------

function isIt = isNumMatrix(data)

if isnumeric(data) && all(size(data) > 1), isIt = true;
else isIt = false;
end

%---------

function isIt = isVector(data)

if isnumeric(data)
   condition1 = size(data) == 1;
   condition2 = ~size(data); 
   if any(condition1 | condition2), isIt = true;
   else isIt = false;
   end
else isIt = false;
end       

%---------

function isIt = isNumVector(data)

if isnumeric(data)
   condition1 = size(data) == 1;
   condition2 = size(data) > 1;
   if any(condition1) && any(condition2), isIt = true;
   else isIt = false;
   end
else isIt = false;
end       


%_______________________________________________________________________
% HELPER FUNCTIONS TO FIND OUT AND/OR CHECK THE MESH FILES

function meshFiles = getEZ4UMeshFiles(arg1,arg2)

%Assign folder or files
if nargin == 1
   if ~ischar(arg1)
       checkEZ4UMeshFiles([],arg1), meshFiles = arg1; return
   else
       condition = length(arg1) > 4;
       if condition && strcmpi(arg1(end:-1:end-3),'mcd.')
           arg1 = {arg1};
           checkEZ4UMeshFiles([],arg1), meshFiles = arg1; return
       else folder = arg1;
       end
   end
elseif nargin == 2
   if ~iscell(arg2), arg2 = {arg2}; end
   checkEZ4UMeshFiles(arg1,arg2), meshFiles = arg2; return
else folder = [];
end

%This part executes the case of being only a folder
emptyFolder = isempty(folder);
if ~emptyFolder && ~exist(folder,'dir')
   error(['The specified directory "' folder '" does not exist'])
elseif ~emptyFolder, addpath(folder), folder = [folder '/'];
end
dirMeshFiles = dir([pwd '/' folder '*dcm']);
nOfDirMeshFiles = length(dirMeshFiles);
if ~nOfDirMeshFiles && ~emptyFolder
   error('There is no .dcm file into the specified directory')
elseif ~nOfDirMeshFiles && emptyFolder
   error(['There is no .dcm file into the current directory.'...
       ' You have to specify the directory where they are located'])
end
meshFiles = cell(1,nOfDirMeshFiles);
for i = 1:nOfDirMeshFiles
   meshFiles{i} = dirMeshFiles(i).name;
end

%---------

function checkEZ4UMeshFiles(folder,meshFiles)

emptyFolder = isempty(folder);
if ~emptyFolder && ~exist(folder,'dir')
   error(['The specified directory "' folder '" does not exist'])
elseif ~emptyFolder, addpath(folder)
end
nOfmeshFiles = numel(meshFiles);
for ifile = 1:nOfmeshFiles
   file = meshFiles{ifile};
   dirFile = dir([pwd '/' folder '/' file]);
   condition = length(dirFile);
   if ~condition && ~emptyFolder
       error(['The file "' file '" is not located into the'...
           ' specified directory'])
   elseif ~condition && emptyFolder
       error(['The file "' file '" is not located into the'...
           ' current directory. You have to specify the directory'...
           ' where it is located'])
   end
end


%_______________________________________________________________________
% AUXILIAR FUNCTIONS

function Order = getEZ4UOrder(fnodes,inodes,nfaces,nenodes)

vnodes = zeros(1,nfaces);
enodes = zeros(1,nfaces*nenodes);
aux = 1;
for i = 1:nfaces
   vnodes(i) = fnodes(i,1);
   enodes(aux:aux+nenodes-1) = fnodes(i,2:end-1);
   aux = aux + nenodes;
end
if size(inodes,2) == 1, inodes = inodes'; end
Order = [vnodes enodes inodes];



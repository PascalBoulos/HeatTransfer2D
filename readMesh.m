function [mesh]=readMesh(fileName,nDimensionProbleme)
% takes in a string filename in the format 'name.extension'
% reads said file and fills the class Mesh variable
% filename must respect the .mesh format from inria

% clc
% clear all
% close all
% fileID=fopen('triangles.mesh','r');

% initializing mesh
mesh=Mesh;

% opening file
[fileID,errorMessage]=fopen(fileName,'r');

% verifying if file opened correctly
if fileID < 0
    error(errorMessage);
end

% getting rid of first line
fgetl(fileID);

% reading number of spatial dimensions
nDim=fscanf(fileID,'%*s %i',1);
% going to next line
fgetl(fileID);

% reading number of  vertices
nVertice=fscanf(fileID,'%*s %i',1);
% reading vertices
mesh.verticesGeo=fscanf(fileID,'%f',[nDim+1 nVertice ])';
% eliminating vertice number identifier (seems to be random in .mesh  format)
mesh.verticesGeo=mesh.verticesGeo(:,1:nDimensionProbleme);

% reading domain names and geometric connectivity
i=0;
while 1
    i=i+1;
    domainType=fscanf(fileID,'%s',1);
    if strcmp(domainType,'End')
        nDom=i-1;
        break;
    end
    domainSize=fscanf(fileID,'%i',1);
    if strcmp(domainType,'EdgesP2')
        domainTypeSize=4;
        dim=1;
        nDeg=2;
%     elseif strcmp(domainType,'Quadrilaterals')
%         domainTypeSize=10;
%         dim=2;
%         nDeg=2;
    elseif strcmp(domainType,'Edges')
        domainTypeSize=3;
        dim=1;
        nDeg=1;
    elseif strcmp(domainType,'Triangles')
        domainTypeSize=4;
        dim=2;
        nDeg=1;
    elseif strcmp(domainType,'TrianglesP2')
        domainTypeSize=7;
        dim=2;
        nDeg=2;
    else
        error('Domain type %s is not recognized.\n',domainType);
    end
    domains{i}=fscanf(fileID,'%f',[domainTypeSize domainSize])';
    domainTypes{i}=domainType;
    domainDims(i)=dim;
    domainDegGeos(i)=nDeg;
end

fclose(fileID);

% separating domains by physical region identifier

alpha=0;
for i=1:size(domains,2)
    for j=1:domains{i}(end)
        alpha=alpha+1;
        mesh.domainsGeo{alpha}=domains{i}(domains{i}(:,end)==j,:);
        mesh.domainTypes{alpha}=domainTypes{i};
        mesh.domainDims(alpha)=domainDims(i);
        mesh.domainDegGeos(alpha)=domainDegGeos(i);
    end
end

fprintf('Mesh %s successfully loaded.\n', fileName);

end
function [nDegGeo, equations, meshFileName, nDimensionProbleme, damping, minDamping, tolerance, iIterMax, listeVariable]=config(configFileName)
% clc
% clearvars
% close all

if exist(configFileName,'file')==2
    run(configFileName)
else
    error('Configuration file not found, verify entered name and file name.')
end

if isempty(equations)
    error('Configuration file did not initialize or return ''class Equations'' variable.')
end

if exist(meshFileName,'file')~=2
    error('Mesh file not found, verify entered mesh name and file name.')
end

fprintf('Configuration %s successfully loaded.\n', configFileName);


end
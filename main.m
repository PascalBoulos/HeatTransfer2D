clc
clear all
close all

global degSpec

tic
configFileName='config7.m';
for degSpec=1:8
    prb=SEMProblem(configFileName);
    prb.nDDL
    cond(prb.matrice(1:prb.nDDL,1:prb.nDDL))
    min(abs(eig(prb.matrice(1:prb.nDDL,1:prb.nDDL))))
end
toc




%
% toc
%
% %%
% % figure
% % text(prb.mesh.verticesDDL(:,1),prb.mesh.verticesDDL(:,2),num2str(prb.numerotation))



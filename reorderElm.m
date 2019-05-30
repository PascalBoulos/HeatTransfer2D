function [order]=reorderElm(nDeg,nDimElm)
% Soit order, contient l'ordre dans lequel l'element du .mesh doit etre lu pour
% concorde avec l'ordre de l'elm de referance

% clc
% clearvars
% close all

% nDeg=2;
order=[];
%% 1d
switch nDimElm
    case 1
        % ligne=zerosDLegendrePN(nDeg+1);
        % ligne=ligne([1 end 2:end-1]);
        order=[1 (nDeg+1) 2:nDeg];
        
        %% 2d
    case 2
        % triangle=LTT(nDeg);
        
        switch nDeg
            case 1
                order=[1 2 3];
                %         triangleRef=[0 1 0;0 0 1];
            case 2
                %         triangleRef=[0 1 0 0.5 0.5 0;0 0 1 0 0.5 0.5];
                order=[1 4 2 6 5 3];
        end
        
        % triangleRef(:,order)-triangle
        
        %% 3d
        
    case 3
        % tetra=LTTetra(nDeg);
        
        switch nDeg
            case 1
                order=[1 3 2 4];
                %         tetraRef=[0 1 0 0;0 0 1 0;0 0 0 1];
            case 2
                %         tetraRef=[0 1 0 0 0.5 0.5 0   0   0.5 0;
                %                   0 0 1 0 0   0.5 0.5 0   0   0.5;
                %                   0 0 0 1 0   0   0   0.5 0.5 0.5] ;
                order=[1 7 3 5 6 2 8 4 10 9];
        end
        
        % tetraRef(:,order)-tetra
end
if isempty(order)
    error('L''ordre de l''element fourni n''est pas encore supporte');
end
end
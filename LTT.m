function [etaZeta]=LTT(nDeg)
% clc
% clear all
% close all

% nDeg=6;


filename=['nodes' num2str(nDeg+1) '.mat'];
if exist(filename,'file')==2
    load(filename)
    etaZeta=nodes;
else
    
    
    
    seed=zerosDLegendrePN(nDeg+1);
    seed=(seed+1)/2;
    
    for i=1:nDeg+1
        for j=1:nDeg+2-i
            k=nDeg+3-i-j;
            eta(i,j)=(1+2*seed(j)-seed(i)-seed(k))/3;
        end
    end
    
    
    
    zeta=eta';
    
    alpha=0;
    for i=1:nDeg+1
        for j=1:nDeg+2-i
            alpha=alpha+1;
            etaA(alpha)=eta(i,j);
            zetaA(alpha)=zeta(i,j);
        end
    end
    
    etaZeta=[etaA; zetaA];
end
% scatter(etaA,zetaA)

end
function [xiEtaZeta]=LTTetra(nDeg)
% clc
% clear all
% close all
% 
% tic
% nDeg=4;

seed=zerosDLegendrePN(nDeg+1);
seed=(seed+1)/2;

alpha=0;
for i=1:nDeg+1
    for j=1:nDeg+2-i
        elle=nDeg+3-i-j;
        alpha=alpha+1;
        xi(alpha)=(1+2*seed(i)-seed(j)-seed(elle))/3;
        eta(alpha)=(1-seed(i)+2*seed(j)-seed(elle))/3;
        zeta(alpha)=0;
    end
end
for j=1:nDeg
    for k=2:nDeg+2-j
        elle=nDeg+3-j-k;
        alpha=alpha+1;
        xi(alpha)=0;
        eta(alpha)=(1+2*seed(j)-seed(k)-seed(elle))/3;
        zeta(alpha)=(1-seed(j)+2*seed(k)-seed(elle))/3;
    end
end
for i=2:nDeg
    for k=2:nDeg+2-i
        elle=nDeg+3-i-k;
        alpha=alpha+1;
        xi(alpha)=(1+2*seed(i)-seed(k)-seed(elle))/3;
        eta(alpha)=0;
        zeta(alpha)=(1-seed(i)+2*seed(k)-seed(elle))/3;
    end
end
for i=2:nDeg
    for j=2:nDeg+1-i
        elle=nDeg+3-i-j;
        alpha=alpha+1;
        xi(alpha)=(1+2*seed(i)-seed(j)-seed(elle))/3;
        eta(alpha)=(1-seed(i)+2*seed(j)-seed(elle))/3;
        zeta(alpha)=1-xi(alpha)-eta(alpha);
    end
end
for i=2:nDeg
    for j=2:nDeg+1-i
        for k=2:nDeg+2-i-j
            elle=nDeg+4-i-j-k;
            alpha=alpha+1;
            xi(alpha)=(1+3*seed(i)-1*seed(j)-1*seed(k)-1*seed(elle))/4;
            eta(alpha)=(1-1*seed(i)+3*seed(j)-1*seed(k)-1*seed(elle))/4;
            zeta(alpha)=(1-1*seed(i)-1*seed(j)+3*seed(k)-1*seed(elle))/4;
        end
    end
end

xiEtaZeta=[xi; eta; zeta];

%% Affichage
% scatter3(zeta,eta,xi)
% xlabel zeta
% ylabel eta
% zlabel xi

% toc
% 
end
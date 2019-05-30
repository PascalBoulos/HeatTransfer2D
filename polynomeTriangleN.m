% function [z,dzdzeta,dzdeta]=polynomeTriangleN(nDeg,xy,xySeed)
clc
clear all
close all
% tic
% syms zeta eta real

nDeg=4;
xySeed=LTT(nDeg);
xy=LTT(nDeg);


xSeed=xySeed(1,:);
ySeed=xySeed(2,:);

psi=zeros((nDeg+1)*(nDeg+2)/2);
dpsidzeta=psi;
dpsideta=psi;
alpha=0;
for i=1:nDeg+1
    for j=1:nDeg-i+2
        alpha=alpha+1;
%         [i-1 j-1]
%         b(i,j)=1;
        psi(alpha,:)=xSeed.^(i-1).*ySeed.^(j-1);
        dpsidzeta(alpha,:)=(i-1)*xSeed.^(i-2).*ySeed.^(j-1);
        dpsideta(alpha,:)=(i-1)*xSeed.^(i-1).*ySeed.^(j-2);
    end
end


%% Activer pour affichage
% xy=LTT(nDeg+3);
x=xy(1,:);
y=xy(2,:);

%% Calcul pour les points x y demande

psi2=zeros((nDeg+1)*(nDeg+2)/2,length(x));
dpsidzeta2=psi2;
dpsideta2=psi2;

alpha=0;
for i=1:nDeg+1
    for j=1:nDeg-i+2
        alpha=alpha+1;
%         [i-1 j-1]
%         b(i,j)=1;
        psi2(alpha,:)=x.^(i-1).*y.^(j-1);
        dpsidzeta2(alpha,:)=(i-1)*x.^(i-2).*y.^(j-1);
        dpsideta2(alpha,:)=(i-1)*x.^(i-1).*y.^(j-2);
    end
end

z=psi\psi2;
dzdzeta=psi\dpsidzeta2;
dzdeta=psi\dpsideta2;

cond(psi)
%% Affichage
% for i=1:size(z,1)
%    scatter3(x,y,z(i,:))
%    pause(0.2)
% end
% toc


% end
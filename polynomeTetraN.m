% function [z,dzdzeta,dzdeta,dzdxi]=polynomeTetraN(nDeg,xyz,xyzSeed)
clc
clear all
close all
% tic
% syms zeta eta real

nDeg=6;

xyzSeed=LTTetra(nDeg);
xSeed=xyzSeed(1,:);
ySeed=xyzSeed(2,:);
zSeed=xyzSeed(3,:);

psi=zeros((nDeg+1)*(nDeg+2)*(nDeg+3)/6);
dpsidzeta=psi;
dpsideta=psi;
dpsidxi=psi;
alpha=0;
for i=1:nDeg+1
    for j=1:nDeg-i+2
        for k=1:nDeg-i-j+3
            alpha=alpha+1;
            %         [i-1 j-1]
            %         b(i,j)=1;
            psi(alpha,:)=xSeed.^(i-1).*ySeed.^(j-1).*zSeed.^(k-1);
            dpsidzeta(alpha,:)=(i-1)*xSeed.^(i-2).*ySeed.^(j-1).*zSeed.^(k-1);
            dpsideta(alpha,:)=(i-1)*xSeed.^(i-1).*ySeed.^(j-2).*zSeed.^(k-1);
            dpsidxi(alpha,:)=(i-1)*xSeed.^(i-1).*ySeed.^(j-1).*zSeed.^(k-2);
        end
    end
end


%% Activer pour affichage
xyz=LTTetra(nDeg);
x=xyz(1,:);
y=xyz(2,:);
z=xyz(3,:);

%% Calcul pour les points x y z demande

psi2=zeros((nDeg+1)*(nDeg+2)*(nDeg+3)/6,length(x));
dpsidzeta2=psi2;
dpsideta2=psi2;
dpsidxi2=psi2;

alpha=0;
for i=1:nDeg+1
    for j=1:nDeg-i+2
        for k=1:nDeg-i-j+3
            alpha=alpha+1;
            %         [i-1 j-1]
            %         b(i,j)=1;
            psi2(alpha,:)=x.^(i-1).*y.^(j-1).*z.^(k-1);
            dpsidzeta2(alpha,:)=(i-1)*x.^(i-2).*y.^(j-1).*z.^(k-1);
            dpsideta2(alpha,:)=(i-1)*x.^(i-1).*y.^(j-2).*z.^(k-1);
            dpsidxi2(alpha,:)=(i-1)*x.^(i-1).*y.^(j-1).*z.^(k-2);
        end
    end
end
    
    val=psi\psi2;
    dvaldzeta=psi\dpsidzeta2;
    dvaldeta=psi\dpsideta2;
    dvaldxi=psi\dpsidxi2;
    
    %% Affichage
%     for i=1:size(val,1)
%        scatter3(x,y,z,1,val(i,:))
% %        pause(0.2)
%     end
    cond(psi)
    % toc
% end
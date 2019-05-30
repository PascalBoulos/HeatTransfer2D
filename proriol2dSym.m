function [P2,dPdx2,dPdy2,P,polynome]=proriol2dSym(nDeg,xy,xyRef)
% % % %Soit
% % % %nDeg, le degr� de l'interpolant d�sir�
% % % %xy, les points o� on d�sire les valeurs
% % % %xyRef, les points de collocation d�sir�s

% clc
% clear all
% close all
% tic


% for nDeg=2:5
% xy=[0 1 2;0 1 3];
% xyRef=LTT(nDeg);

% for nDeg=3:9
syms zeta eta real

filename=['polynomeTrian' num2str(nDeg) '.mat'];

npts=(nDeg+1)*(nDeg+2)/2;

% % % Les calculs sont effectu�s seulement si les fichiers n'existent pas
if exist(filename,'file')==2
% % %     On importe les fichiers si ils existent
    load(filename);
else
    
    
    
    % syms k elle p integer
% % %     On effectue la transformation de Duffy
    zetaPrime=2*zeta/(1-eta)-1;
    etaPrime=2*eta-1;
    
    
% % %     On construit le pollyn�me de base et ses d�riv�s
    polynome=sym(zeros(1,npts));
    
    alpha=0;
    for k=0:nDeg
        for elle=0:nDeg-k
            
            alpha=alpha+1;
            %             [k elle p]
            polynome(alpha)=legendreP(k,zetaPrime)*(1-eta)^k*jacobiP(elle,2*k+1,0,etaPrime);
            
        end
    end
    
    polynome=simplify(polynome);
    dpolynomedzeta=diff(polynome,zeta);
    dpolynomedeta=diff(polynome,eta);
% % %     On sauvegarde  pour �viter d'avoir � calculer plus d'une fois
    save(filename,'polynome','dpolynomedzeta','dpolynomedeta');
end
%end
% toc

% % % On transforme les �quations symboliques en fonction matlab  plus
% rapide � �valu�es
f=matlabFunction(polynome,'Vars',[zeta eta]);
fx=matlabFunction(dpolynomedzeta,'Vars',[zeta eta]);
fy=matlabFunction(dpolynomedeta,'Vars',[zeta eta]);

% % % On discr�tise les  fonctions sur les points de collocations
zeta=xyRef(1,:);
eta=xyRef(2,:);

P=zeros(length(eta));
% dPdx=P;
% dPdy=P;
% dPdz=P;
for i=1:length(eta)
    P(:,i)=f(zeta(i),eta(i))';
    %     dPdx(:,i)=fx(xi(i),eta(i),zeta(i));
    %     dPdy(:,i)=fy(xi(i),eta(i),zeta(i));
    %     dPdz(:,i)=fz(xi(i),eta(i),zeta(i));

end

%% calcul de l'interpolant
% % % On discr�tise le polynome de base sur les points � �valuer 
zeta=xy(1,:);
eta=xy(2,:);

P2=zeros(npts,length(eta));
dPdx2=P2;
dPdy2=P2;
for i=1:length(eta)
    P2(:,i)=f(zeta(i),eta(i));
    dPdx2(:,i)=fx(zeta(i),eta(i));
    dPdy2(:,i)=fy(zeta(i),eta(i));
end
% % On r�sout le syst�me pour obtenir les interpolants et leurs d�riv�s
P2=P\P2;
dPdx2=P\dPdx2;
dPdy2=P\dPdy2;

% P=double(subs(polynome));
% cond(P)
end
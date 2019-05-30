function [P2,dPdx2,dPdy2,dPdz2]=proriol3dSym(nDeg,xyz,xyzRef)
% calcul du polynome de proriol
% note: P est la matrice de vandermonde modifiée

% exemple
% nDeg=3;
% xyz=[0 1 2;0 1 3;0 1 4];
%


% for nDeg=3:9
syms xi eta zeta real

filename=['polynomeTetra' num2str(nDeg) '.mat'];

npts=(nDeg+1)*(nDeg+2)*(nDeg+3)/6;

if exist(filename,'file')==2
    load(filename);
else
    
    zetaPrime=2*zeta-1;
    etaPrime=4*eta./(1-zetaPrime)-1;
    xiPrime=8*xi./(1-etaPrime)./(1-zetaPrime)-1;
    
    
    
    polynome=sym(zeros(npts,1));
    
    alpha=0;
    for k=0:nDeg
        for elle=0:nDeg-k
            for p=0:nDeg-k-elle
                alpha=alpha+1;
                %             [k elle p]
                polynome(alpha)=legendreP(k,xiPrime)*jacobiP(elle,2*k+1,0,etaPrime)*jacobiP(p,2*k+2*elle+2,0,zetaPrime)*((1-etaPrime)/2)^k*((1-zetaPrime)/2)^(k+elle);
            end
        end
    end
    
    polynome=simplify(polynome);
    dpolynomedxi=diff(polynome,xi);
    dpolynomedeta=diff(polynome,eta);
    dpolynomedzeta=diff(polynome,zeta);
    
    save(filename,'polynome','dpolynomedxi','dpolynomedeta','dpolynomedzeta');
end

f=matlabFunction(polynome,'Vars',[xi eta zeta]);
fx=matlabFunction(dpolynomedxi,'Vars',[xi eta zeta]);
fy=matlabFunction(dpolynomedeta,'Vars',[xi eta zeta]);
fz=matlabFunction(dpolynomedzeta,'Vars',[xi eta zeta]);

xi=xyzRef(1,:);
eta=xyzRef(2,:);
zeta=xyzRef(3,:);

P=zeros(length(eta));
for i=1:length(eta)
    P(:,i)=f(xi(i),eta(i),zeta(i));
end

%% calcul de l'interpolant
xi=xyz(1,:);
eta=xyz(2,:);
zeta=xyz(3,:);

P2=zeros(npts,length(eta));
dPdx2=P2;
dPdy2=P2;
dPdz2=P2;
for i=1:length(eta)
    P2(:,i)=f(xi(i),eta(i),zeta(i));
    dPdx2(:,i)=fx(xi(i),eta(i),zeta(i));
    dPdy2(:,i)=fy(xi(i),eta(i),zeta(i));
    dPdz2(:,i)=fz(xi(i),eta(i),zeta(i));
end
P2=P\P2;
dPdx2=P\dPdx2;
dPdy2=P\dPdy2;
dPdz2=P\dPdz2;

end
function [jac,jacDet]=jacNDv2(pointsGeo, dimensionElm, pointsInt, dPdx, dPdy, dPdz)
% prend le nDeg de la discretisation geometrique
% prend pointsGeo, les points geometrique de la discretisation
% prend dimensionElm, la dimension de l'objet de reference
% prend pointsInt, les polynomes evalues au points d'interpolation

% NB: pointsGeo contient nLigne=dimension du maillage et mColonne=dimension
% de l'objet de reference
%
% retourne le jacobien [dx/dr dx/ds dx/dt;dy/dr dy/ds dy/dt;dz/dr dz/ds dz/dt]
% et le determinant du jacobien



% clc
% clear all
% close all
%
% nDeg=1;
% dimensionElm=2; % dimension de l'elm (1 pour une ligne, 2 pour une surface, etc.)
% dimension=2; % dimension du maillage

% switch dimensionElm
%     case 0
%     case 1
%         pointsGeo=[0 0.5 1;0 0.6 1;0 0.5 1];
% %         pointsGeo=[0 0.5 1;0 0.6 1;0 0 0];
%
%     case 2
% %         pointsGeo=LTT(nDeg);
% %         pointsGeo=pointsGeo/4;
% %         theta=pi/6;
% %         pointsGeo=[cos(theta) -sin(theta);sin(theta) cos(theta)]*pointsGeo;
% %         pointsGeo(3,size(pointsGeo,2))=1;
%     case 3
%         pointsGeo=LTTetra(nDeg);
% end
%
% pointsGeo=pointsGeo(1:dimension,:);


switch dimensionElm
    case 0
        jac=1;
        jacDet=1;
    case 1
        %          pointsRef=(zerosDLegendrePN(nDeg+1)+1)/2;
        %         pointsInt=simplexquad(ceil(nDeg*3/2),dimensionElm);
        %         pointsInt=pointsInt';
        %         [~,dPdx]=lobattoPN(pointsInt,nDeg,pointsRef);
        dfdzeta=pointsGeo*dPdx;
        
        jacDet=zeros(1,size(pointsInt,2));
        jac=zeros(size(dfdzeta,1),dimensionElm,size(pointsInt,2));
%         jacInv=jac;
        
        for i=1:size(pointsInt,2)
            jac(:,:,i)=[dfdzeta(:,i)];
%             if size(jac(:,:,i))==size(jac(:,:,i)')
%                 jacInv(:,:,i)=inv(jac(:,:,i));
%             end
            jacDet(i)=sqrt(det(jac(:,:,i)'*jac(:,:,i)));
        end
    case 2
        %         pointsRef=LTT(nDeg);
        %         pointsInt=simplexquad(ceil(nDeg*3/2),dimensionElm);
        %         pointsInt=pointsInt';
        %         [~,dPdx,dPdy]=proriol2dSym(nDeg,pointsInt,pointsRef);
        dfdzeta=pointsGeo*dPdx;
        dfdeta=pointsGeo*dPdy;
        
        jacDet=zeros(1,size(pointsInt,2));
        jac=zeros(size(pointsGeo,1),dimensionElm);
%         jacInv=jac;
        
        for i=1:size(pointsInt,2)
            jac(:,:,i)=[dfdzeta(:,i) dfdeta(:,i)];
%             if size(jac(:,:,i))==size(jac(:,:,i)')
%                 jacInv(:,:,i)=inv(jac(:,:,i));
%             end
            jacDet(i)=sqrt(det(jac(:,:,i)'*jac(:,:,i)));
        end
        
    case 3
        %         pointsRef=LTTetra(nDeg);
        % %
        %         pointsInt=simplexquad(ceil(nDeg*3/2),dimensionElm);
        %         pointsInt=pointsInt';
        %         [~,dPdx,dPdy,dPdz]=proriol3dSym(nDeg,pointsInt,pointsRef);
        dfdzeta=pointsGeo*dPdx;
        dfdeta=pointsGeo*dPdy;
        dfdxi=pointsGeo*dPdz;
        
        jacDet=zeros(1,size(pointsInt,2));
        jac=zeros(size(dfdzeta,1),dimensionElm,size(pointsInt,2));
        jacInv=jac;
        
        for i=1:size(pointsInt,2)
            jac(:,:,i)=[dfdzeta(:,i) dfdeta(:,i) dfdxi(:,i)];
%             if size(jac(:,:,i))==size(jac(:,:,i)')
%                 jacInv(:,:,i)=inv(jac(:,:,i));
%             end
            jacDet(i)=sqrt(det(jac(:,:,i)'*jac(:,:,i)));
        end
end

% jacDet
% jac
end
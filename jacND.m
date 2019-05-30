function [jacX,jacY,jacZ]=jacND(pointsGeometrique,pointsRef,dimension,dPdx,dPdy,dPdz,dPdxGeo,dPdyGeo,dPdzGeo)
% pointsGeometrique, vrai points  g�om�triques
% pInt, polynome d'interpolation evalue aux points d'integration
% dPdx, derive du polynome d'interpolation en x  evalue aux points
%       geometriques
% dPdy, meme de dPdx mais derive en y


% clc
% clear all
% close all
%
% nDeg=1;
% pointsRef=LTT(nDeg);
% pointsGeometrique=pointsRef;
% pointsGeometrique(1,:)=pointsGeometrique(1,:);
% xInt=simplexquad(4,2);
% xInt=xInt';
% [pInt,~,~]=proriol2dSym(nDeg,xInt,pointsRef);

% for i=1:size(pointsGeometrique,1)

switch dimension
    case 0
        jacX=1;
    case 1
%         [~,dPdx]=lobattoPN(pointsGeometrique,nDeg,pointsRef);
        jacX=(pointsGeometrique(1,:)*dPdxGeo)./(pointsRef(1,:)*dPdx);
        jacX=(pointsGeometrique(1,:)*dPdxGeo)./(pointsRef(1,:)*dPdx);
        
        
%         jacXInt=jacX*pInt;
        
    case 2
%         [~,dPdx,dPdy]=proriol2dSym(nDeg,pointsGeometrique,pointsRef);
%         jacX=(pointsGeometrique(1,:)*dPdx)./(pointsRef(1,:)*dPdx);
%         jacY=(pointsGeometrique(2,:)*dPdy)./(pointsRef(2,:)*dPdy);
        jacX=(pointsGeometrique(1,:)*dPdxGeo)./(pointsRef(1,:)*dPdx);
        jacY=(pointsGeometrique(2,:)*dPdyGeo)./(pointsRef(2,:)*dPdy);
        
        
%         jacXInt=jacX*pInt;
%         jacYInt=jacY*pInt;
        
        
    case 3
       
%         [~,dPdx,dPdy,dPdz]=proriol3dSym(nDeg,pointsGeometrique,pointsRef);
        jacX=(pointsGeometrique(1,:)*dPdxGeo)./(pointsRef(1,:)*dPdx);
        jacY=(pointsGeometrique(2,:)*dPdyGeo)./(pointsRef(2,:)*dPdy);
        jacZ=(pointsGeometrique(3,:)*dPdzGeo)./(pointsRef(3,:)*dPdz);
        
%         jacXInt=jacX*pInt;
%         jacYInt=jacY*pInt;
%         jacZInt=jacZ*pInt;
end
% end
end
function [lesZeros]=zerosDLegendrePN(npts)
%prend le nombre de points désirés
%retourne les  zeros des polynomes de lobatto dans le nombre desirés

% clc
% clear all
% close all

% npts=7;
% % % % syms x  real
% % % %
% % % % P(2)=x;
% % % % P(1)=1;
% % % %
% % % %
% % % % for n=2:npts+1
% % % %     P(n+1)=((2*(n-1)+1)*x*P(n)-(n-1)*(P(n-1)) )/(n);
% % % % end
% % % %
% % % % dP=diff(P);
% % % % g=matlabFunction(dP(end));
% % % % lesZeros=sort(real(double(solve(dP(npts+2)==0,x))));

% for i=3:10
npts=npts-2;
filename=['ZDLP' num2str(npts) '.mat'];

if exist(filename,'file')==2
    load(filename)
else
    
    
    x=linspace(-1,0,npts*2);
    % for i=1:40
    erreur=1;
    a=0;
    while erreur>1e-13
        a=a+1;
        %     indexZeros=find((diff((sign(double(subs(dP(end))))))));
        [~,dP]=dLegendrePN(x,npts);
        indexZeros=find((diff((sign(dP(end,:))))));
        
        erreur=max(x(indexZeros+1)-x(indexZeros));
        x=sort([x(indexZeros) (x(indexZeros)+x(indexZeros+1))/2 x(indexZeros+1)]);
        %     erreur=max(abs(x(indexZeros)'-lesZeros(1:3)));
    end
    
    lesZeros=sort([x(indexZeros) -x(indexZeros)]);
    if mod(npts,2)==1
        lesZeros(length(indexZeros))=[];
    end
    
    save(filename,'lesZeros')
end

lesZeros=[-1 lesZeros 1];
end
function [P,dP]=dLegendrePN(x,npts)
% clc
% clear all
% close all
%
% npts=4;
% % syms x real
%
% x=linspace(-1,1,100);

P(2,:)=x;
P(1,:)=ones(1,length(x));

dP(1,:)=zeros(1,length(x));
dP(2,:)=ones(1,length(x));

for n=2:npts+1
    dP(n+1,:)=((2*(n-1)+1)*(P(n,:)+x.*dP(n,:))-(n-1)*(dP(n-1,:)) )/(n);
    P(n+1,:)=((2*(n-1)+1)*x.*P(n,:)-(n-1)*(P(n-1,:)) )/(n);
end
% P=P(end,:);
% dP=dP(end,:);
end
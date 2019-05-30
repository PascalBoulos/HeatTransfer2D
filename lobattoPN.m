function [ LP,dLP ] = lobattoPN( x, nDeg, seed)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% x

% global nDeg

% clc
% clear all
% close all

% nDeg=10;

% syms x real;
% syms LP;

xNodes=seed;
% x=linspace(-1,1,nDeg*2);

LP=ones(nDeg+1,length(x));
dLP=zeros(nDeg+1,length(x));




for j=1:nDeg+1
%     sum=zeros(1,length(x));
    for i=1:nDeg+1
        if i~=j
            LP(j,:)=LP(j,:).*(x-xNodes(i))./(xNodes(j)-xNodes(i));
            prod=ones(1,length(x));
            for m=1:nDeg+1
                if m~=i && m~=j
                    prod=prod.*(x-xNodes(m))/(xNodes(j)-xNodes(m));
                end
            end
            dLP(j,:)=dLP(j,:)+1/(xNodes(j)-xNodes(i)).*prod;
        end
    end
    
%     dLP(j,:)=sum;
end

end


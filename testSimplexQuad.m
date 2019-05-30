clc
clear all
close all

syms x y z

f=x^2*y^5*z^3;

normeRef=double(int(int(int(f,z,0,1-y-x),y,0,1-x),x,0,1));

for i=1:10
[xInt,wInt]=simplexquad(i,3);
x=xInt(:,1)';
y=xInt(:,2)';
z=xInt(:,3)';

norme=double(subs(f))*wInt;
norme-normeRef

end

% norme-normeRef

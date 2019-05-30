%fichier de configuration
% NB: les ddls sont assign�s dans l'ordre des �quations alors les
% dirichlets doivent absolutment etre a la fin

nDegGeo=1;
nDimensionProbleme=2;

meshFileName='triangle5.mesh';

%% Equations
%initialise les equations
nEquation=5;
equations=Equation(nEquation);

% Equation 1

equations(1).domaines=3;
equations(1).domainNames='fluide';
equations(1).variables='T';
equations(1).nDegs=3;
equations(1).nDegPoidsInterpolation=6;
equations(1).nDim=2;
equations(1).formulationFaible=@formeFaibleDiffusion;
equations(1).solutionInitiale=0.5;

% Equation 2

equations(2).domaines=3;
equations(2).domainNames='fluide';
equations(2).variables='T';
equations(2).nDegs=3;
equations(2).nDegPoidsInterpolation=6;
equations(2).nDim=2;
equations(2).formulationFaible=@formeFaibleTermeSourceChaleur;
equations(2).parametres=1;
equations(2).solutionInitiale=0.5;

% Equation 3

equations(3).domaines=[2 1];
equations(3).domainNames='murGaucheDroit';
equations(3).variables='T';
equations(3).nDegs=3;
equations(3).nDegPoidsInterpolation=6;
equations(3).nDim=1;
equations(3).formulationFaible=@dirichlet;
equations(3).dirichlet=0;
equations(3).solutionInitiale=0.5;



% Equation 3

% equations(3).domaines=1;
% equations(3).domainNames='murDroit';
% equations(3).variables='T';
% equations(3).nDegs=3;
% equations(3).nDim=1;
% equations(3).formulationFaible=@dirichlet;
% equations(3).dirichlet=1;
% equations(3).solutionInitiale=0.5;


tolerance=1e-6;
iIterMax=100;
minDamping=1e-10;
damping=1;


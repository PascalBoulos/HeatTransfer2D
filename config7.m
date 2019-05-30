%fichier de configuration
% NB: les ddls sont assign�s dans l'ordre des equations alors les
% dirichlets doivent absolutment etre a la fin

global degSpec

nDegGeo=1;
nDimensionProbleme=2;

meshFileName='triangle2.mesh';

%% Equations
%initialise les equations
listeVariable={'T1'};

nEquation=1;
equations=Equation(nEquation);

% Equation 1

equations(1).domaines=3;
equations(1).domainNames='fluide';
equations(1).variables='T1';
equations(1).nDegs=degSpec;
equations(1).nDegPoidsInterpolation=40;
equations(1).nDim=2;
equations(1).formulationFaible=@formeFaibleDiffusion2;
equations(1).solutionInitiale=0.1;

% % Equation 2
% 
% equations(2).domaines=3;
% equations(2).domainNames='fluide';
% equations(2).variables='T1';
% equations(2).nDegs=degSpec;
% equations(2).nDegPoidsInterpolation=6;
% equations(2).nDim=2;
% equations(2).formulationFaible=@formeFaibleTermeSourceChaleur;
% equations(2).parametres=1;
% equations(2).solutionInitiale=0.2;
% 
% % Equation 3
% 
% equations(3).domaines=[1];
% equations(3).domainNames='murGaucheDroit';
% equations(3).variables='T1';
% equations(3).nDegs=degSpec;
% equations(3).nDegPoidsInterpolation=6;
% equations(3).nDim=1;
% equations(3).formulationFaible=@dirichlet;
% equations(3).dirichlet=0.3;
% equations(3).solutionInitiale=0;



tolerance=1e-6;
iIterMax=100;
minDamping=1e-10;
damping=1;


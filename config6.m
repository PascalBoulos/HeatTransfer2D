%fichier de configuration
% NB: les ddls sont assign�s dans l'ordre des �quations alors les
% dirichlets doivent absolutment etre a la fin

nDegGeo=2;
nDimensionProbleme=2;

meshFileName='triangle2.mesh';

%% Equations
%initialise les equations
listeVariable={'T1'};

nEquation=3;
equations=Equation(nEquation);

% Equation 1

equations(1).domaines=3;
equations(1).domainNames='fluide';
equations(1).variables='T1';
equations(1).nDegs=3;
equations(1).nDegPoidsInterpolation=6;
equations(1).nDim=2;
equations(1).formulationFaible=@formeFaibleDiffusion;
equations(1).solutionInitiale=0.1;

% Equation 2

equations(2).domaines=3;
equations(2).domainNames='fluide';
equations(2).variables='T1';
equations(2).nDegs=3;
equations(2).nDegPoidsInterpolation=6;
equations(2).nDim=2;
equations(2).formulationFaible=@formeFaibleTermeSourceChaleur;
equations(2).parametres=1;
equations(2).solutionInitiale=0.2;

% Equation 3

equations(3).domaines=[2 1];
equations(3).domainNames='murGaucheDroit';
equations(3).variables='T1';
equations(3).nDegs=3;
equations(3).nDegPoidsInterpolation=6;
equations(3).nDim=1;
equations(3).formulationFaible=@dirichlet;
equations(3).dirichlet=0.3;
equations(3).solutionInitiale=0;


% 
% % Equation 4
% 
% equations(4).domaines=3;
% equations(4).domainNames='fluide';
% equations(4).variables='T2';
% equations(4).nDegs=2;
% equations(4).nDegPoidsInterpolation=5;
% equations(4).nDim=2;
% equations(4).formulationFaible=@formeFaibleDiffusion;
% equations(4).solutionInitiale=0.4;
% 
% % Equation 5
% 
% equations(5).domaines=1;
% equations(5).domainNames='murDroit';
% equations(5).variables='T2';
% equations(5).nDegs=2;
% equations(5).nDegPoidsInterpolation=5;
% equations(5).nDim=1;
% equations(5).formulationFaible=@dirichlet;
% equations(5).dirichlet=0.5;
% equations(5).solutionInitiale=0;
% 
% % Equation 6
% 
% equations(6).domaines=2;
% equations(6).domainNames='murGauche';
% equations(6).variables='T2';
% equations(6).nDegs=2;
% equations(6).nDegPoidsInterpolation=5;
% equations(6).nDim=1;
% equations(6).formulationFaible=@dirichlet;
% equations(6).dirichlet=0.6;
% equations(6).solutionInitiale=0;
% 


tolerance=1e-6;
iIterMax=100;
minDamping=1e-10;
damping=1;


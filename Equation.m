classdef Equation
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        domaines
        domainNames
        variables
        nDegs
        nDegPoidsInterpolation
        nDim
        formulationFaible
        parametres
        dirichlet
        solutionInitiale
    end
    
    methods
        function [obj]=Equation(dim)
            if nargin~=0
                obj(dim)=Equation;
            end
            
            
        end
%         function [obj]=addEquation(domaine,variable,nDeg,formulationFaible,parametres)
%             obj.domaine=[obj.domaine domaine];
%             obj.variable=[obj.variable variable];
%             obj.nDeg=[obj.nDeg nDeg];
%             obj.formulationFaible=[obj.formulationFaible formulationFaible];
%             obj.parametres=[obj.parametres parametres];
%         end
    end
    
end


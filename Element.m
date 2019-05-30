classdef Element
    %UNTITLED10 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nDeg
        nDegGeo
        nDegPoidsInterpolation
        dimension
        polygoneType
        nNodes
        nodes
        nodesGeo
        wInt %poids d'integration
        xInt %position des points d'integration
        pInt %polynome evalue aux points d'integration
        dPIntdZeta
        dPIntdEta
        dPIntdXi
        pGeo %polynome d'interpolation evalue aux noeuds dans le deg du polynome geometrique
             %il est utilise pour le remaillage qui sert au compte des DDL
        
        dPIntdZetaGeo
        dPIntdEtaGeo
        dPIntdXiGeo
        
    end
    
    methods
     
    end
    
end


classdef Simplex < Element
    %UNTITLED12 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        % constructeur
        function obj=Simplex(nDeg,dimension,nDegGeo,nDegPoidsInterpolation)
            obj.polygoneType='Simplex';
            obj.dimension=dimension;
            obj.nDeg=nDeg;
            obj.nDegGeo=nDegGeo;
            obj.nDegPoidsInterpolation=nDegPoidsInterpolation;
            if nDeg<1
                error('nDeg must be bigger than 0')
            end
            obj.nNodes=prod(nDeg+(1:dimension))/prod(1:dimension);
            if dimension>0
%                 [obj.xInt, obj.wInt]=simplexquad(ceil((nDeg)*3/2),dimension);
                [obj.xInt, obj.wInt]=simplexquad(nDegPoidsInterpolation,dimension);
                obj.xInt=obj.xInt';
            else
               obj.xInt=0;
               obj.wInt=1;
            end
            
            switch dimension
                case 0
                    obj.nodes=0;
                    obj.pInt=1;
                case 1
                    obj.nodes=(zerosDLegendrePN(nDeg+1)+1)/2;
                    obj.nodesGeo=(zerosDLegendrePN(nDegGeo+1)+1)/2;
                    [obj.pInt, obj.dPIntdZeta]=lobattoPN(obj.xInt,nDeg,obj.nodes);
                    [obj.pGeo]=lobattoPN(obj.nodes,nDegGeo,obj.nodesGeo);
                    [~, obj.dPIntdZetaGeo]=lobattoPN(obj.xInt,nDegGeo,obj.nodesGeo);
                case 2
                    obj.nodes=LTT(nDeg);
                    obj.nodesGeo=LTT(nDegGeo);
                    [obj.pInt, obj.dPIntdZeta, obj.dPIntdEta]=proriol2dSym(nDeg,obj.xInt,obj.nodes);
                    [obj.pGeo]=proriol2dSym(nDegGeo,obj.nodes,obj.nodesGeo);
                    [~, obj.dPIntdZetaGeo, obj.dPIntdEtaGeo]=proriol2dSym(nDegGeo,obj.xInt,obj.nodesGeo);

                case 3
                    
                    obj.nodes=LTTetra(nDeg);
                    obj.nodesGeo=LTTetra(nDegGeo);
                    [obj.pInt, obj.dPIntdZeta, obj.dPIntdEta,obj.dPIntdXi]=proriol3dSym(nDeg,obj.xInt,obj.nodes);
                    [obj.pGeo]=proriol3dSym(nDegGeo,obj.nodes,obj.nodesGeo);
                    [~, obj.dPIntdZetaGeo, obj.dPIntdEtaGeo,obj.dPIntdXiGeo]=proriol3dSym(nDegGeo,obj.xInt,obj.nodesGeo);

            end
            
            
            
        end
    end
    
end


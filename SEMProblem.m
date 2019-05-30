classdef SEMProblem
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % configuration file info
        configFileName
        
        % mesh info
        meshFileName
        mesh
        nDimensionProbleme % 1  pour 1d, 2 pour 2d, etc.
        nDegGeo
        
        % equations, boundary conditions info
        equations
        
        % reference elements
        elementRef
        
        % jacobian information
        jacobian
        jacobianDeterminant
        
        % solution information
        variables
        solution
        
        % Degres of liberty information (DDL)
        nDDL
        %         numerotationIndex
        numerotation
        vecteurAdressage
        
        % solution information
        solution2
        matrice
        residu
        
        
        %         boundaryConditions
        %         valeurDirichlet
        
        %
        %         elementRefNp1
        
        %
        %
        %
        %         connectivite
        %
        %
        
        %config newton
        damping
        minDamping
        tolerance
        iIterMax
        
    end
    
    methods
        %         function obj=SEMProblem(meshFileName,nDeg,nDegGeo,dimensionProbleme)
        function obj=SEMProblem(configFileName)
            obj.configFileName=configFileName;
            [obj.nDegGeo, obj.equations, obj.meshFileName, obj.nDimensionProbleme, obj.damping, obj.minDamping, obj.tolerance, obj.iIterMax, obj.variables]=config(configFileName);
            obj.mesh=readMesh(obj.meshFileName,obj.nDimensionProbleme);
            obj=obj.generateReferenceElement();
            obj=obj.reorderElement();
            obj=obj.calculateJabobian();
            obj=obj.remesh();
            obj=obj.genereNumerotation();
            obj=obj.genereVecteurAdressage();
            obj=obj.initializeSolution();
            obj=obj.dampedNewton();
            obj.afficheSolution();
        end
        %%
        function obj=generateReferenceElement(obj)
            %             obj.elementRef=[Simplex(obj.nDeg,1,obj.nDegGeo) Simplex(obj.nDeg,2,obj.nDegGeo) Simplex(obj.nDeg,3,obj.nDegGeo)];
            for iEquation=1:length(obj.equations)
                for iDeg=1:length(obj.equations(iEquation).nDegs)
                    obj.elementRef{iEquation,iDeg}=Simplex(obj.equations(iEquation).nDegs(iDeg),obj.equations(iEquation).nDim,obj.nDegGeo,obj.equations(iEquation).nDegPoidsInterpolation);
                end
            end
            disp('Reference elements generated.')
        end
        %%
        function obj=reorderElement(obj)
            for i=1:length(obj.mesh.domainTypes)
                dim=obj.mesh.domainDims(i);
                nDeg=obj.mesh.domainDegGeos(i);
                order=reorderElm(nDeg,dim);
                obj.mesh.domainsGeo{i}=obj.mesh.domainsGeo{i}(:,order);
            end
            disp('Elements reordered by local order.')
        end
        %%
        function obj=calculateJabobian(obj)
            
            
            for iEquation=1:length(obj.equations)
                dim=obj.equations(iEquation).nDim;
                domain=[];
                for domainIndex=obj.equations(iEquation).domaines
                   domain=[domain;obj.mesh.domainsGeo{domainIndex}];
                end
                
                for iElement=1:size(domain,1)
                    for iDeg=1:length(obj.equations(iEquation).nDegs)
                        pointsGeometriques=obj.mesh.verticesGeo(domain(iElement,:),:)';
                        xInt=obj.elementRef{iEquation,iDeg}.xInt;
                        dPIntdZetaGeo=obj.elementRef{iEquation,iDeg}.dPIntdZetaGeo;
                        dPIntdEtaGeo=obj.elementRef{iEquation,iDeg}.dPIntdEtaGeo;
                        dPIntdXiGeo=obj.elementRef{iEquation,iDeg}.dPIntdXiGeo;
                        [obj.jacobian{iEquation,iDeg,iElement}, obj.jacobianDeterminant{iEquation,iDeg,iElement}]=jacNDv2(pointsGeometriques,dim,xInt,dPIntdZetaGeo,dPIntdEtaGeo,dPIntdXiGeo);
                    end
                end
                
                
            end
        end
        %%
        function obj=remesh(obj)
            %transformer l'elm geometrique en elm du mm degre que les
            %variables
            alpha=0;
            %             for i=1:length(obj.mesh.domainTypes)
            for  iEquation=1:length(obj.equations)
                
                domain=[];
                for domainIndex=obj.equations(iEquation).domaines
                   domain=[domain;obj.mesh.domainsGeo{domainIndex}];
                end
                
                for iElementGeo=1:size(domain,1)
                    ligneGeo=obj.mesh.verticesGeo(domain(iElementGeo,:),:);
                    %                     P=obj.elementRef(dim).pGeo;
                    for iDeg=1:length(obj.equations(iEquation).nDegs);
                        P=obj.elementRef{iEquation,iDeg}.pGeo;
                    end
                    nouveauPoints=(ligneGeo'*P)';
                    obj.mesh.verticesDDL=[obj.mesh.verticesDDL; nouveauPoints];
                end
                obj.mesh.domainsDDL{iEquation}=reshape(alpha+1:alpha+size(domain,1)*size(nouveauPoints,1),size(nouveauPoints,1),size(domain,1))';
                alpha=alpha+size(domain,1)*size(nouveauPoints,1);
            end
            
            % eliminer des doublons
            [obj.mesh.verticesDDL,~,ic]=uniquetol(obj.mesh.verticesDDL,'ByRows',true);
            for iEquation=1:length(obj.equations)
                obj.mesh.domainsDDL{iEquation}=reshape(ic(obj.mesh.domainsDDL{iEquation}),size(obj.mesh.domainsDDL{iEquation}));
            end
            
            
            
        end
        
        %%
        function obj=genereNumerotation(obj)
            % TODO : modifier pour gerer plus qu'une variable
            % TODO : modifier pour gerer les variables triples ex(u v w)
            obj.numerotation=zeros(size(obj.mesh.verticesDDL,1),length(obj.variables));
            for iEquation=1:length(obj.equations)
                testIndexes=unique(obj.mesh.domainsDDL{iEquation}(:));
                
                if isempty(obj.equations(iEquation).dirichlet) % true if ddl
                    obj.numerotation(testIndexes,strcmp(obj.equations(iEquation).variables,obj.variables))=1;
                end
                
            end
            for iEquation=1:length(obj.equations)
                testIndexes=unique(obj.mesh.domainsDDL{iEquation}(:));
                
                if ~isempty(obj.equations(iEquation).dirichlet) % true if dirichlet
                    obj.numerotation(testIndexes,strcmp(obj.equations(iEquation).variables,obj.variables))=-1;
                end
                
            end
            obj.nDDL=sum(obj.numerotation(:)==1);
            nDirichlet=sum(obj.numerotation(:)==-1);
            
            obj.numerotation(obj.numerotation==1)=1:obj.nDDL;
            obj.numerotation(obj.numerotation==-1)=-(obj.nDDL+1:obj.nDDL+nDirichlet);
            
            disp('DDLs identified')
            %
            
        end
        %%
        function obj=genereVecteurAdressage(obj)
            for iEquation=1:length(obj.equations)
                iVariable=find(strcmp(obj.variables,obj.equations(iEquation).variables)); %une seule variable par equation
                num=abs(obj.numerotation(:,iVariable));
                obj.vecteurAdressage{iEquation}=reshape(num(obj.mesh.domainsDDL{iEquation}),size(obj.mesh.domainsDDL{iEquation}));
            end
        end
        
        %%
        function obj=initializeSolution(obj)
            obj.solution=zeros(nnz(obj.numerotation),1);
            
            for iEquation=1:length(obj.equations)
                %                 if strcmp(obj.boundaryConditions{i},'Dirichlet')
                iVariable=find(strcmp(obj.variables,obj.equations(iEquation).variables)); %une seule variable par equation
                num=abs(obj.numerotation(:,iVariable));
                
                
                domainIndex=num(obj.mesh.domainsDDL{iEquation}(:));
                if isempty(obj.equations(iEquation).dirichlet)
                    %                     indexDirichlet=[indexDirichlet alpha:alpha-1+size(obj.mesh.domainsDDL{i},1)];
                    
                    obj.solution(domainIndex)=obj.equations(iEquation).solutionInitiale;
                    
                end
                
            end
            for iEquation=1:length(obj.equations)
                %                 if strcmp(obj.boundaryConditions{i},'Dirichlet')
                iVariable=find(strcmp(obj.variables,obj.equations(iEquation).variables)); %une seule variable par equation
                num=abs(obj.numerotation(:,iVariable));
                
                domainIndex=num(obj.mesh.domainsDDL{iEquation}(:));
                if ~isempty(obj.equations(iEquation).dirichlet)
                    
                    
                    obj.solution(domainIndex)=obj.equations(iEquation).dirichlet;
                end
                
            end
        end
        
        %%
        function [residu]=calculeResidu(obj,j,estPerturbe,iEquation)
            %estPerturbe =0, residu normal
            %estPerturbe =1, residu perturbe

            dim=obj.equations(iEquation).nDim;
            
            if ~estPerturbe
                sol=obj.solution(obj.vecteurAdressage{iEquation}(j,:))';
            else
                sol=obj.solution2(obj.vecteurAdressage{iEquation}(j,:))';
            end
            sol=repmat(sol,obj.elementRef{iEquation,1}.nNodes,1); %change  le 1 de elemRef pour iDeg
            
            w=obj.elementRef{iEquation,1}.wInt;
            
            
            switch dim
                case 0
                    residu=obj.equations(iEquation).formulationFaible(1,0,0,0,sol);
                case 1
                    P=obj.elementRef{iEquation,1}.pInt;
                    dPdx=obj.elementRef{iEquation,1}.dPIntdZeta;
                    
                    for i=1:size(dPdx,2)
                        dd=dPdx(:,i)/obj.jacobian{iEquation,1,j}(:,:,i);
                        dPdx(:,i)=dd(:,1);
                    end
                    
                    residu=obj.equations(iEquation).formulationFaible(P,dPdx,zeros(size(dPdx)),zeros(size(dPdx)),sol)*(obj.jacobianDeterminant{iEquation,1,j}'.*w);
                case 2
                    P=obj.elementRef{iEquation,1}.pInt;
                    dPdx=obj.elementRef{iEquation,1}.dPIntdZeta;
                    dPdy=obj.elementRef{iEquation,1}.dPIntdEta;
                    
                    for i=1:size(dPdx,2)
                        dd=[dPdx(:,i) dPdy(:,i)]/obj.jacobian{iEquation,1,j}(:,:,i);
                        dPdx(:,i)=dd(:,1);
                        dPdy(:,i)=dd(:,2);
                    end
                    
                    residu=obj.equations(iEquation).formulationFaible(P,dPdx,dPdy,zeros(size(dPdx)),sol,obj.equations(iEquation).parametres)*(obj.jacobianDeterminant{iEquation,1,j}'.*w);
                    
                case 3 
                    P=obj.elementRef{iEquation,1}.pInt;
                    dPdx=obj.elementRef{iEquation,1}.dPIntdZeta;
                    dPdy=obj.elementRef{iEquation,1}.dPIntdEta;
                    dPdz=obj.elementRef{iEquation,1}.dPIntdXi;
                    
                    for i=1:size(dPdx,2)
                        dd=[dPdx(:,i) dPdy(:,i) dPdz(:,i)]/obj.jacobian{3,j}(:,:,i);
                        dPdx(:,i)=dd(:,1);
                        dPdy(:,i)=dd(:,2);
                        dPdz(:,i)=dd(:,2);
                    end
                    residu=obj.equations(iEquation).formulationFaible(P,dPdx,dPdy,dPdz,sol,obj.equations(iEquation).parametres)*(obj.jacobianDeterminant{iEquation,1,j}'.*w);
                    
            end
        end
        
        
        %%
        function [ae,be]=calculeCoefficientsV2(obj,j,iEquation)

            dim=obj.equations(iEquation).nDim;
            
            ae=zeros(obj.elementRef{iEquation,1}.nNodes);
            for i=1:obj.elementRef{iEquation,1}.nNodes
                obj.solution2=obj.solution;
                h=max(abs(obj.solution2(obj.vecteurAdressage{iEquation}(j,i))*(sqrt(eps))),sqrt(eps));
                obj.solution2(obj.vecteurAdressage{iEquation}(j,i))=obj.solution2(obj.vecteurAdressage{iEquation}(j,i))+h;
                
                residu=obj.calculeResidu(j,0,iEquation);
                residu2=obj.calculeResidu(j,1,iEquation);
                ae(:,i)=(residu-residu2)/h;
                
            end
            be=residu;
        end
        
        %%
        function obj=assemble(obj)
            % Assemblage
            
%             A=zeros(size(obj.mesh.verticesDDL,1));
%             B=zeros(size(obj.mesh.verticesDDL,1),1);
            A=zeros(nnz(obj.numerotation));
            B=zeros(nnz(obj.numerotation),1);
            for iEquation=1:length(obj.equations)
                for iElement=1:size(obj.mesh.domainsDDL{iEquation},1)
                    [coeff, bCoeff]=obj.calculeCoefficientsV2(iElement,iEquation);
                    A(obj.vecteurAdressage{iEquation}(iElement,:),obj.vecteurAdressage{iEquation}(iElement,:))=A(obj.vecteurAdressage{iEquation}(iElement,:),obj.vecteurAdressage{iEquation}(iElement,:))+coeff;
                    B(obj.vecteurAdressage{iEquation}(iElement,:))=B(obj.vecteurAdressage{iEquation}(iElement,:),1)+bCoeff;
                end
            end
            obj.matrice=A;
            obj.residu=B;
        end
        
        %%
        function obj=assembleResidu(obj)
            %% Assemblage
            
             B=zeros(nnz(obj.numerotation),1);
            for iEquation=1:length(obj.equations)
                for i=1:size(obj.mesh.domainsDDL{iEquation},1)
                    bCoeff=obj.calculeResidu(i,0,iEquation);
                    B(obj.vecteurAdressage{iEquation}(i,:))=B(obj.vecteurAdressage{iEquation}(i,:),1)+bCoeff;
                end
            end

            obj.residu=B;
        end
        %%
        function obj=dampedNewton(obj)
            % check source for
            % https://www.mathworks.com/matlabcentral/fileexchange/40038-newton-raphson-solver-with-adaptive-step-size?focused=3775952&tab=function
            
            
            %% first newton step
            
            % calculate step size
            obj=obj.assemble();
            deltaT=obj.matrice(1:obj.nDDL,:)\obj.residu(1:obj.nDDL);
            
            %first newton step
            obj.solution(1:obj.nDDL)=obj.solution(1:obj.nDDL)+obj.damping*deltaT(1:obj.nDDL);
            
            obj=obj.assembleResidu();
            err=sum(abs(obj.residu(1:obj.nDDL)))/obj.nDDL;
            
            % for i=1:10
            iIter=0;
            while err>obj.tolerance && iIter<obj.iIterMax
                iIter=iIter+1;
                
                obj=obj.assemble();
                deltaTTemp=obj.matrice(1:obj.nDDL,:)\obj.residu(1:obj.nDDL);
                
                if(~(max(abs(obj.damping * deltaTTemp)) < max(abs(deltaT)) ))
                    while( ( max(abs(deltaT)) < max(abs(obj.damping * deltaTTemp))))
                        obj.damping=obj.damping/2;
                        if obj.damping<obj.minDamping
                            error('Damping too strong, no convergence')
                        end
                    end
                end
                % next newton step
                
                deltaT=deltaTTemp;
                
                obj.solution(1:obj.nDDL)=obj.solution(1:obj.nDDL)+obj.damping*deltaT(1:obj.nDDL);
                
                obj=obj.assembleResidu();
                obj.damping=min(1,obj.damping*2);
                
                err=sum(abs(obj.residu(1:obj.nDDL)))/obj.nDDL;
                
                
            end
        end
        function []=afficheSolution(obj)
            for iVariable=1:length(obj.variables)
                figure
                
                npts=100;
                ddls=abs(obj.numerotation(:,iVariable));
                [s,index]=sort(ddls);
                ordreAffichage=index(s~=0);
                ddlAffiche=ddls(ddls~=0);
                
                %             plot3(obj.mesh.verticesDDL(ordreAffichage,1),obj.mesh.verticesDDL(ordreAffichage,2),obj.solution,'.')
                %             scatter3(obj.mesh.verticesDDL(ordreAffichage,1),obj.mesh.verticesDDL(ordreAffichage,2),obj.solution,10,obj.solution)
                x=obj.mesh.verticesDDL(ordreAffichage,1);
                y=obj.mesh.verticesDDL(ordreAffichage,2);
                
                z=obj.solution(sort(ddlAffiche));
                minx=min(x);
                maxx=max(x);
                miny=min(y);
                maxy=max(y);
                dx=(maxx-minx)/npts;
                dy=(maxy-miny)/npts;
                
                [xi,yi] = meshgrid(minx:dx:maxx, miny:dy:maxy);
                zi = griddata(x,y,z,xi,yi);
                surf(xi,yi,zi,'EdgeColor','none');
%                 plot3(x,y,z,'.')
                xlabel x
                ylabel y
                zlabel(obj.variables{iVariable})
                grid on
            end
        end
    end
    
end


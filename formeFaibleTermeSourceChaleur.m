function [r]=formeFaibleTermeSourceChaleur(P,dPdx,dPdy,dPdz,T,parametres)

r=P;

% le parametre represente la valeur du terme source 
if ~isempty(parametres)
    r=parametres*r;
end

end
function [r]=formeFaibleFluxChaleur(P,dPdx,dPdy,dPdz,T,parametres)

r=P*-4;

if ~isempty(parametres)
    r=parametres*r;
end

end
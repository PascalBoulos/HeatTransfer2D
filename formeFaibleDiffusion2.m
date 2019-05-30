function [r]=formeFaibleDiffusion2(P,dPdx,dPdy,dPdz,T,parametres)

r=-dPdx.*(T*dPdx)-dPdy.*(T*dPdy)-dPdz.*(T*dPdz)-T*P;

% le parametre represente la constante de diffusion
if ~isempty(parametres)
    r=parametres*r;
end

end
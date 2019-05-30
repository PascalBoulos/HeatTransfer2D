function [r]=formeFaibleDiffusion(~,dPdx,dPdy,dPdz,T,parametres)

r=-dPdx.*(T*dPdx)-dPdy.*(T*dPdy)-dPdz.*(T*dPdz);

% le parametre represente la constante de diffusion
if ~isempty(parametres)
    r=parametres*r;
end

end
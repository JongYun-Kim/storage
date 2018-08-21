function [a] = ICON_vessel(ax,transparency,SF)
% SF = 2;
load('kara_cruiser.mat')
pEdge = [ .4 .4 .4 ];		% model edge color: [ R G B ]
pFace = [ .5 .5 .5 ];		% model face color: [ R G B ]
% transparency = 0.8;

phi = -90;
theta = 0;
psi = 90;

sinTheta = sind(theta);
cosTheta = cosd(theta);
sinPsi = sind(psi);
cosPsi = cosd(psi);
sinPhi = sind(phi);
cosPhi = cosd(phi);
transformMatrix = [ ...
    cosPsi * cosTheta ...
    -sinPsi * cosTheta ...
    sinTheta; ...
    cosPsi * sinTheta * sinPhi + sinPsi * cosPhi ...
    -sinPsi * sinTheta * sinPhi + cosPsi * cosPhi ...
    -cosTheta * sinPhi; ...
    -cosPsi * sinTheta * cosPhi + sinPsi * sinPhi ...
    sinPsi * sinTheta * cosPhi + cosPsi * sinPhi ...
    cosTheta * cosPhi ];
V_new = V * transformMatrix;
           
           
h(1) = patch('Faces',F,'Vertices',V_new*SF,...
    'FaceColor',pFace,'EdgeColor',pEdge,'FaceAlpha', transparency);

hg = [h];

%% Moving

a = hgtransform('Parent',ax);
set(hg,'Parent',a);
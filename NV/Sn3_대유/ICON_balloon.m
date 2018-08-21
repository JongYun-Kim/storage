function [a] = ICON_balloon(ax,transparency,SF)
% SF = 2;
load('balloon.mat')
pEdge = [ 0.8 0 0];		% model edge color: [ R G B ]
pFace = [0 0 0];		% model face color: [ R G B ]
% transparency = 0.8;
SF = SF*0.01;
phi = 0;
theta = 0;
psi = 180;

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
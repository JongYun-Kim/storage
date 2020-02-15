function [m,dm] = meanPathloss(hyp, x)
%
% Linear mean function. The mean function is parameterized as:
% m(x) = -10*n*log10( sqrt((x-xb).^2) ) + C
%
% The hyperparameter is:
% hyp = [ n
%         C
%         %x_b1
%         %..
%         %x_bD ]   => base position in hyp outdated
%
% Copyright (c) by Jongyun Kim, 2020-02-16.
% See also MEANFUNCTIONS.M.
%

% Size check
    % % % if nargin<2, m = '2+D'; return; end       % report number of hyperparameters
if nargin<2, m = '2'; return; end               % report number of hyperparameters
[n,~] = size(x);
    % % % if any(size(hyp)~=[2+D,1]), error('Exactly 2+D hyperparameters needed.'), end
if any(size(hyp)~=[2,1]), error('Exactly (2x1) hyperparameters required.'), end

% Base position
global base_pos_meanfunc
    % % % xb = repmat(hyp(3:end)',n,1);  % == n x D matrix
xb = repmat(base_pos_meanfunc,n,1);  % == n x D matrix

% Mean and directional derivatives wrt each hyp
m = -10*hyp(1)*log10( sqrt(sum( (x-xb).^2, 2)) ) + hyp(2);  % == n x 1 vector
    %dm = @(q) [sum(q), -10*hyp(1)*log10( sum( (x-xb).^2, 2) )'*q(:)];  % 2 x 1 vector
dm = @(q) dirder(q,x,xb);  % directional derivative

function dhyp = dirder(q,x,xb)
    h1 =  ( -10*log10( sqrt(sum( (x-xb).^2, 2)) )  )' * q(:);  % (nx1)'*(nx1) = (1xn)*(nx1) = (1x1)
    h2 =  sum(q(:));  % ones(1,n) * q(:);
    dhyp = [h1; h2];                                            % (2x1) vector
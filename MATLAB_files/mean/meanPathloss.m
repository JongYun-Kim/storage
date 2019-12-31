function [m,dm] = meanPathloss(hyp, x)

% Linear mean function. The mean function is parameterized as:
%
% m(x) = -10*n*log10( (x-xb).^2 ) + C
%
%
% The hyperparameter is:
%
% hyp = [ n
%         C
%         x_b1
%         ..
%         x_bD ]
%
% Copyright (c) by Carl Edward Rasmussen and Hannes Nickisch, 2016-04-15.
%
% See also MEANFUNCTIONS.M.
global base_pos

% % % if nargin<2, m = '2+D'; return; end             % report number of hyperparameters
if nargin<2, m = '2'; return; end             % report number of hyperparameters
[n,D] = size(x);
% % % if any(size(hyp)~=[2+D,1]), error('Exactly 2+D hyperparameters needed.'), end
if any(size(hyp)~=[2,1]), error('Exactly 2+D hyperparameters needed.'), end
%m = x*hyp(:);                                                    % evaluate mean
%dm = @(q) x'*q(:);
% % % xb = repmat(hyp(3:end)',n,1);  % == n x D matrix
xb = repmat(base_pos,n,1);  % == n x D matrix
m = -10*hyp(1)*log10( sum( (x-xb).^2, 2) ) + hyp(2);  % == n x 1 vector
dm = @(q) [sum(q), -10*hyp(1)*log10( sum( (x-xb).^2, 2) )'*q(:)];  % 2 x 1 vector
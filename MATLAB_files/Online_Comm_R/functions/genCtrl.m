function [ u_possible ] = genCtrl( horizonLength, controlTypes, sayTrue )
% This functino returns the possible control inputs within the horizon
% INPUT: horizonLength: int scalar > 0
%        controlTypes:  column vector !!
%        sayTrue: 'true' when the function is implemented at the most outside of the code
%                 if you put this arg to 'false', this function does not implement the input validation 
% Example: getCtrl(2, [-1; 0; 1], true)

    % Default value
    if nargin < 3
        sayTrue = true;
    end
    
    % Input validation
    if sayTrue
        if size(controlTypes,2)~=1
            error('The controlType must be a column vector')
        elseif horizonLength < 1
            error('The length of the horizon must be equal to or larger than 1')
        else
            % Code implementation without the input validation
            u_possible = genCtrl( horizonLength, controlTypes, false);
        end
    else
        if horizonLength > 1  % Àç±Í È£Ãâ
            NumControl =  length(controlTypes);
            u_temp = [];
            for i = 1:NumControl
                u_temp = [u_temp; repmat(controlTypes(i),NumControl^(horizonLength-1),1)];
            end
            u_possible = [u_temp, repmat(genCtrl(horizonLength - 1, controlTypes, false),NumControl,1)];
        else                  % Àç±Í ¹Ù´Ú
            u_possible = controlTypes;
        end
    end
end
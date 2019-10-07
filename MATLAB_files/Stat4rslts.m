% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% @@@@ 반드시 원래코드 clear만 끄고 한다;@@@@
% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
clear;

NumRepeat = 20;
bb1 = zeros(NumRepeat,1);
bb2 = zeros(NumRepeat,1);

for iiiii = 1:NumRepeat
    clearvars -except bb1 bb2 iiiii NumRepeat;
    Data_Gao;
    close all;
    bb1(iiiii) = mean(yy);
end

for iiiii = 1:NumRepeat
    clearvars -except bb1 bb2 iiiii NumRepeat;
    Data_GaoExt;
    close all;
    bb2(iiiii) = mean(yy);
end
fprintf('Done!\n\n');
disp(bb1);
fprintf('And\n');
disp(bb2);
fprintf('Gao= %6.4f,  GaoExt = %6.4f \n',mean(bb1),mean(bb2));

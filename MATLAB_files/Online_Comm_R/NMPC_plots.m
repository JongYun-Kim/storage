%% Post Processing
% % % plot(data.x(1,:),data.y(1,:))  % 릴레이 1번만
% % % hold on;
% % % plot(base_position(:,1),base_position(:,2),'LineStyle','none','Marker','o');
% % % plot(client_position(:,1),client_position(:,2),'LineStyle','none','Marker','o');
% % % axis equal; grid on; legend('Relay trajectory','Base I','Client I');
% % % hold off;

X1 = data.x(1:NumRelay,:)';
Y1 = data.y(1:NumRelay,:)';

XB = base_position(:,1);
YB = base_position(:,2);

XC = client_position(:,1);
YC = client_position(:,2);

% figure 생성
figure1 = figure(1);

% axes 생성
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% plot 생성
plot(X1,Y1,'DisplayName','Relay trajectory','LineWidth',1);

% plot 생성
plot(XB,YB,'DisplayName','Base(s)','MarkerSize',4,'Marker','o','LineWidth',4,...
    'LineStyle','none');

% plot 생성
plot(XC,YC,'DisplayName','Client(s)','MarkerSize',4,'Marker','o',...
    'LineWidth',4,...
    'LineStyle','none');

% 다음 라인의 주석을 해제하여 좌표축의 Y 제한을 유지
% ylim(axes1,[-19.4471443556152 19.704786846415]);
box(axes1,'on');
grid(axes1,'on');
% 나머지 axes 속성 설정
set(axes1,'DataAspectRatio',[1 1 1],'FontSize',12,'FontWeight','bold',...
    'PlotBoxAspectRatio',[24.8202426843136 19.5759656010151 1]);
axis(MapBound);
% legend 생성
% legend1 = legend(axes1,'show');
% set(legend1,...
%     'Position',[0.573809532174066 0.730912722920779 0.307142850703427 0.161904757434413],...
%     'FontSize',12);


%% Plots
% GP plot
[X1,XB] = meshgrid(Xmin:0.1:Xmax, Ymin:0.1:Ymax);
z = [X1(:) XB(:)];

for i = 1:NumBase
    base_pos_meanfunc = base_position(i,:);
    [m, s2] = gp(GP(i).hyp_learned, GP(i).inffunc, GP(i).meanfunc, GP(i).covfunc, GP(i).likfunc, GP(i).D, GP(i).Y, z);
    mm = reshape(m, size(X1));
    ss2 = reshape(s2, size(X1));

    figure(2*i); hold on;
    surf(Xmin:0.1:Xmax, Ymin:0.1:Ymax , -mm,'LineStyle','none');  % 맵과 resolution 맞춤 608*704
    plot3(base_position(:,1),base_position(:,2),    ones(size(base_position(:,1),1),1)*(75),'o','MarkerSize',2,'Color','r')
    plot3(client_position(:,1),client_position(:,2),ones(size(client_position(:,1),1),1)*(75),'o','MarkerSize',2,'Color','g')
    axis equal;
    axis([Xmin Xmax Ymin Ymax 20 75])
    hold off; grid on; colorbar;
    
    figure(2*i+1); hold on;
    surf(Xmin:0.1:Xmax, Ymin:0.1:Ymax , ss2,'LineStyle','none');  % 맵과 resolution 맞춤 608*704
    plot3(base_position(:,1),base_position(:,2),    ones(size(base_position(:,1),1),1)*(75),'o','MarkerSize',2,'Color','r')
    plot3(client_position(:,1),client_position(:,2),ones(size(client_position(:,1),1),1)*(75),'o','MarkerSize',2,'Color','g')
    axis equal;
    axis([Xmin Xmax Ymin Ymax])
    hold off; grid on; colorbar;
end
clear m2 s2 mm ss2
P=linspace(0,1.5,30);
f=0.008;
P0=1/f;
u=2;
a=0.005;
L=0.008;
pixel_size = 2.8e-6;
PP=P+P0;

distance = 0.5:0.01:3;
RR=zeros(1,length(distance));
for i =1:length(PP)
    R=round((PP(i).*L*a-L*a./distance-a)/pixel_size);
    plot(distance,R)
    hold on
    RR=R+RR;
%     RR=[RR,sum(R)];
end
grid on 
% xticks(0.5:0.01:3)
hold on
plot(0.5:0.01:3,RR/length(PP))
% hold on
% plot(range(2:length(range)-1),0.01./(RR(2:length(range)-1)-RR(1:length(range)-2)))
% aa = 0.002:0.0001:0.005;
% [F,A]=meshgrid(PP,aa);
% R=abs(1./(F.*L.*A-A.*L/u-A));
% mesh(F,A,R)

clear
F=8 *1e-3; %焦距大小单位m50
wave_length = 750*1e-9; % 光波长
pixel_size = 2.2 *1e-6; % 像元大小

aperture_size = 5e-3;%F/1.8;%5e-3;% F/1.8;
% c=[0,0];%子光圈中心的位置，[x,y]
cz=0.005;%apture和光心距离;
ra = 1.22*F*wave_length/2/pixel_size;
A = max(ra,1e-3);%子光圈的aperture  1e-3;%

d_focus = 1;%对焦距离；
d=1.3;%
depth_inc = 0.1;%深度递增

objCord=[0,0,d];%物点坐标，以光心为原点，[x,y,z]z物距，以光心为原点；
kernel_size = 201;
K=1/2;
alpha = 250;
sigma_noise = 0.005;


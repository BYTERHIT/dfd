clear
F=8 *1e-3; %�����С��λm50
wave_length = 750*1e-9; % �Ⲩ��
pixel_size = 2.2 *1e-6; % ��Ԫ��С

aperture_size = 5e-3;%F/1.8;%5e-3;% F/1.8;
% c=[0,0];%�ӹ�Ȧ���ĵ�λ�ã�[x,y]
cz=0.005;%apture�͹��ľ���;
ra = 1.22*F*wave_length/2/pixel_size;
A = max(ra,1e-3);%�ӹ�Ȧ��aperture  1e-3;%

d_focus = 1;%�Խ����룻
d=1.3;%
depth_inc = 0.1;%��ȵ���

objCord=[0,0,d];%������꣬�Թ���Ϊԭ�㣬[x,y,z]z��࣬�Թ���Ϊԭ�㣻
kernel_size = 201;
K=1/2;
alpha = 250;
sigma_noise = 0.005;


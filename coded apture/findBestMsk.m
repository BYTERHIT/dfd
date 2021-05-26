%Image and Depth from a Conventional Camera with a Coded Aperture
%Anat Levin Rob Fergus Fre ?do Durand William T. Freeman
%Massachusetts Institute of Technology, Computer Science and Artificial Intelligence Laboratory
close all
parameters
%计算先验模型
gx=zeros(kernel_size);
gy = zeros(kernel_size);
gx(ceil(kernel_size/2),ceil(kernel_size/2))= -1;
gx(ceil(kernel_size/2)+1,ceil(kernel_size/2)) = 1;
gy(ceil(kernel_size/2),ceil(kernel_size/2))= -1;
gy(ceil(kernel_size/2),ceil(kernel_size/2)+1)= 1;

% gy=[1;-1];

Gx=fft2(gx);
Gx_plot=log(abs((Gx))+1);
Gy=fft2(gy);
Gy_plot=log(abs((Gy))+1); 
Prior = alpha*(abs(Gx).^2 + abs(Gy).^2);

%计算spf 1

msk_size = round(aperture_size/A);%aperture/A 总光圈x,y方向上可以分成多少个子光圈

mskMod = msk_size*msk_size;%floor(msk_size/2)*floor(msk_size/2);%对称的
iterNum = 2^mskMod-1;
D=zeros(iterNum,1);
aptMsk = zeros(mskMod);% zeros(floor(msk_size/2)*2);
Dkl = getDkl(objCord,depth_inc,aptMsk,F,d_focus,kernel_size,...
        pixel_size,K,cz,A,sigma_noise,Prior);
D(1)=Dkl;
i=1;
msk = zeros(msk_size);%zeros(floor(msk_size/2));
maxDkl = 0;
while i<iterNum
%     seed = randsample(mskMod,round(mskMod/2));%(rand(1,1)*(2^mskMod-1));
    seed = i;
    msk = getMsk(seed,mskMod);
%     msk(seed) = 1;% = getMsk(seed,mskMod);
    aptMsk =  msk;%[msk,fliplr(msk);flipud(msk),rot90(msk,2)];
%     if sum(sum(aptMsk)) > mskMod/2
    Dkl = getDkl(objCord,depth_inc,aptMsk,F,d_focus,kernel_size,...
        pixel_size,K,cz,A,sigma_noise,Prior);
    D(i+1) = Dkl;
    
%     D(i+1,:)=[seed,Dkl];
    i=i+1;
    if maxDkl < Dkl
        maxDkl = Dkl;
        maxAptMsk = aptMsk;
    end
%     end
end
% [N,I]=max(D(:,2))
% msk = getMsk(D(I,1),mskMod)
% aptMsk = [msk,fliplr(msk);flipud(msk),rot90(msk,2)]
% aptMsk = [0,1;1,0];
figure
subplot(2,1,1)
apt = imresize(maxAptMsk,[100,100],'nearest');
imshow(apt)
title("apture")
subplot(2,1,2)
plot(D)
hold on
plot(ones(size(D))*D(1))








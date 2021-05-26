
%@brief 计算DL散度
%@param objCord 待测点的坐标，以光心为原点，[x,y,z]；
%@param depth_inc 测量的距离精度
%@param aptMsk coded aperture的掩膜，为仿真，0表示通，1表示不通，需要是方阵
%@param F 系统的焦距
%@param d_focus 系统设置的对焦距离，物方距离
%@param kernel_size psf的kernel size
%@param pixel_size 像素大小
%@param K 计算子光圈形成的模糊半径的矫正系数 默认是1/6,需要进一步矫正
%@param cz 光圈和光心的距离
%@param A 子光圈的大小
%@param sigma_noise 白噪声的方差
%@param Prior 根据梯度的高斯分布的模型计算出来方差的倒数 alpha*(gx^2+gy^2)
%@return 在objCord下，相距depth_inc产生两个不同的模糊spf fk1,fk2，其对应的P(Yk1)和P(Yk2)的kl散度
function Dkl = getDkl(objCord,depth_inc,aptMsk,F,d_focus,kernel_size,pixel_size,K,cz,A,sigma_noise,Prior)
psf_pre = getCodedAptPsf(objCord,F,d_focus,aptMsk,kernel_size,pixel_size,K,cz,A);
PSF_pre = fft2(psf_pre*100)./100;
sigma_pre = ( abs(PSF_pre).^2./(Prior+eps)) + sigma_noise^2;
Dkl_ = zeros(8,1);
draw=0;
if draw
    PSF_1d = fftshift(PSF_pre);
    PSF_1d = PSF_1d(floor(kernel_size/2),:);
    hand1 = figure();
    hand2 = figure();
    plot(abs(PSF_1d))
    hold on
end
% figure
for i = -3.5:3.5
    psf2 = getCodedAptPsf(objCord+[0,0,depth_inc*i],F,d_focus,aptMsk,kernel_size,pixel_size,K,cz,A);
    PSF2 = fft2(psf2*100)./100;  
    sigma2 = (abs(PSF2).^2./(Prior+eps)) + sigma_noise^2;
    sig1DivSig2 = sigma_pre./sigma2;
    Dkl_(i+4.5) = sum(sum(sig1DivSig2))-sum(sum(log(sig1DivSig2)));
    if draw
        PSF_1d = fftshift(PSF2);
        PSF_1d = PSF_1d(floor(kernel_size/2),:);
        figure(hand1)
        plot(abs(PSF_1d))
        hold on
        figure(hand2)
        subplot(2,8,2*(i+4.5)-1)
        
        imshow(fftshift(abs(PSF2)),[])
        subplot(2,8,2*(i+4.5))
        [rows,cols]=find(psf2>0.000001);
        height = max(rows)-min(rows);
        width = max(cols)-min(cols);
%         [x,y]=meshgrid(1-ceil(kernel_size/2):kernel_size-ceil(kernel_size/2),1-ceil(kernel_size/2):kernel_size-ceil(kernel_size/2));
%         mesh(x,y,psf2)
        imshow(psf2,[])
        title(["w:" int2str(width) " h:" int2str(height)]);
    end
    
%     sigma_pre = sigma2;
end
Dkl=min(Dkl_);
% figure
% subplot(2,2,1)
% 
% imshow(sigma1,[])
% title("sigma1")
% subplot(2,2,2)
% 
% imshow(sigma2,[])
% title("sigma2")
% subplot(2,2,3)
% 
% figure
% imshow(log(abs((fftshift(PSF_pre)))+1),[])
% title("psf")
% subplot(2,2,4)
% msk = imresize(aptMsk,[kernel_size, kernel_size],'nearest');
% imshow(msk)
% title("aptMask")
end
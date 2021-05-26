
%@brief ����DLɢ��
%@param objCord ���������꣬�Թ���Ϊԭ�㣬[x,y,z]��
%@param depth_inc �����ľ��뾫��
%@param aptMsk coded aperture����Ĥ��Ϊ���棬0��ʾͨ��1��ʾ��ͨ����Ҫ�Ƿ���
%@param F ϵͳ�Ľ���
%@param d_focus ϵͳ���õĶԽ����룬�﷽����
%@param kernel_size psf��kernel size
%@param pixel_size ���ش�С
%@param K �����ӹ�Ȧ�γɵ�ģ���뾶�Ľ���ϵ�� Ĭ����1/6,��Ҫ��һ������
%@param cz ��Ȧ�͹��ĵľ���
%@param A �ӹ�Ȧ�Ĵ�С
%@param sigma_noise �������ķ���
%@param Prior �����ݶȵĸ�˹�ֲ���ģ�ͼ����������ĵ��� alpha*(gx^2+gy^2)
%@return ��objCord�£����depth_inc����������ͬ��ģ��spf fk1,fk2�����Ӧ��P(Yk1)��P(Yk2)��klɢ��
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
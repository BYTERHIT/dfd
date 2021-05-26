%coded aperture
%Martinello, Manuel. (2012). Coded Aperture Imaging. 10.13140/RG.2.1.3886.8004. 
%1. 计算 能够忽略衍射干扰的最小孔径的大小ra
%@brief 获取coded aperture 的psf
%@param objCord 待测点的坐标，以光心为原点，[x,y,z]；
%@param F 系统的焦距
%@param d_focus 系统设置的对焦距离，物方距离
%@param apterMsk coded aperture形成的掩膜矩阵,需要是方阵
%@param kernel_size psf的kernel size
%@param pixel_size 像素大小
%@param K 计算子光圈形成的模糊半径的矫正系数 默认是1/6,需要进一步矫正
%@param cz 光圈和光心的距离
%@param A 子光圈的大小
%@return psf coded aperture 的点扩散函数
function psf = getCodedAptPsf(objCord,F,d_focus,aptMsk,kernel_size,pixel_size,K,cz,A)
    
        
    d = objCord(3);
    p = objCord(1:2);
    v=1/(1/F-1/d_focus);%像距，以光心为原点；
    v0=1/(1/F-1/d);%物距d对应的对焦像距；
%     apterMsk = unidrnd(2,msk_size,msk_size)-1;
    msk_size = size(aptMsk,1);
    pSpf = zeros(kernel_size);
    B = A*abs(1-v/v0)*d/(d-cz);%子光圈的模糊直径大小
   

    sigma = B*K/pixel_size;
    
    i = 1;
    if sum(sum(aptMsk))==0%如果全为0，则为传统的aperture
        pApterCentI=(-1*v/d*p+(1-v/v0)*(d.*[0,0]-cz*p)./(d-cz))./pixel_size;
        B = A*msk_size*abs(1-v/v0)*d/(d-cz);
        sigma=B*K/pixel_size;
        pSpf = pSpf + pillowboxPsf(pApterCentI,sigma,kernel_size);
    else
        pApterCentI=zeros(sum(sum(aptMsk)),2);
            for ai=0:msk_size-1
                for aj=0:msk_size-1
                    if aptMsk(ai+1,aj+1)==1
                        continue;
                    else
                        c=[ai-(msk_size-1)/2,aj-(msk_size-1)/2].*A;
                        pApterCentI(i,:) = (-1*v/d*p+(1-v/v0)*(d.*c-cz*p)./(d-cz))./pixel_size;%子光圈中心坐标，[x,y]   
                        i = i+1;
                    end
                end
            end

        pSpf = pSpf + pillowboxPsf(pApterCentI,sigma,kernel_size);
    end
%     figure
%     [x,y]=meshgrid(1-ceil(kernel_size/2):kernel_size-ceil(kernel_size/2),1-ceil(kernel_size/2):kernel_size-ceil(kernel_size/2));
%     mesh(x,y,pSpf)
%     imshow(pSpf,[])
    
    psf = pSpf./sum(sum(pSpf));
end
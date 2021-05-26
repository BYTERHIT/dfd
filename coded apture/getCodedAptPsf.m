%coded aperture
%Martinello, Manuel. (2012). Coded Aperture Imaging. 10.13140/RG.2.1.3886.8004. 
%1. ���� �ܹ�����������ŵ���С�׾��Ĵ�Сra
%@brief ��ȡcoded aperture ��psf
%@param objCord ���������꣬�Թ���Ϊԭ�㣬[x,y,z]��
%@param F ϵͳ�Ľ���
%@param d_focus ϵͳ���õĶԽ����룬�﷽����
%@param apterMsk coded aperture�γɵ���Ĥ����,��Ҫ�Ƿ���
%@param kernel_size psf��kernel size
%@param pixel_size ���ش�С
%@param K �����ӹ�Ȧ�γɵ�ģ���뾶�Ľ���ϵ�� Ĭ����1/6,��Ҫ��һ������
%@param cz ��Ȧ�͹��ĵľ���
%@param A �ӹ�Ȧ�Ĵ�С
%@return psf coded aperture �ĵ���ɢ����
function psf = getCodedAptPsf(objCord,F,d_focus,aptMsk,kernel_size,pixel_size,K,cz,A)
    
        
    d = objCord(3);
    p = objCord(1:2);
    v=1/(1/F-1/d_focus);%��࣬�Թ���Ϊԭ�㣻
    v0=1/(1/F-1/d);%���d��Ӧ�ĶԽ���ࣻ
%     apterMsk = unidrnd(2,msk_size,msk_size)-1;
    msk_size = size(aptMsk,1);
    pSpf = zeros(kernel_size);
    B = A*abs(1-v/v0)*d/(d-cz);%�ӹ�Ȧ��ģ��ֱ����С
   

    sigma = B*K/pixel_size;
    
    i = 1;
    if sum(sum(aptMsk))==0%���ȫΪ0����Ϊ��ͳ��aperture
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
                        pApterCentI(i,:) = (-1*v/d*p+(1-v/v0)*(d.*c-cz*p)./(d-cz))./pixel_size;%�ӹ�Ȧ�������꣬[x,y]   
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
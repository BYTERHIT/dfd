function  psf = pillowboxPsf(apterCenterI, radia,kernel_size)
scal_factor = 10;
kernel_size=kernel_size*scal_factor;
apterCenterI = apterCenterI *scal_factor;
radia = radia * scal_factor;
pSpf = zeros(kernel_size);
centerPoint = apterCenterI+(kernel_size+1)/2;
r2= (radia)^2;
using_retangle = 1;%使用矩形来拟合还是使用圆形，根据apt的形状来确定
for i=1:size(apterCenterI,1)
    
    if centerPoint(i,1)<0 || centerPoint(i,1) > kernel_size ...
        || centerPoint(i,2)<0 || centerPoint(i,2) > kernel_size
        disp("outof range")
        disp(centerPoint(i,:))
    else
        if radia<1
            pSpf(floor(centerPoint(i,1)),floor(centerPoint(i,2))) =1;
            pSpf(ceil(centerPoint(i,1)),ceil(centerPoint(i,2))) =1;
        else
            if using_retangle 
                pSpf(floor(centerPoint(i,1))-round(radia):ceil(centerPoint(i,1))+round(radia),...
                    floor(centerPoint(i,2))-round(radia):ceil(centerPoint(i,2))+round(radia))=1;
            else
                for j=-ceil(radia)-0.5:ceil(radia)+0.5
                    for k=-ceil(radia)-0.5:ceil(radia)+0.5
                        cordi = round([j,k]+centerPoint(i,:));%round((kernel_size+1)/2);
                        if abs(j)<radia/1.42 && abs(k)<radia/1.42
                            pSpf(cordi(1),cordi(2))=1;
                        elseif (j^2+k^2)<r2
                            pSpf(cordi(1),cordi(2))=1;
                        end
                    end
                end
            end
        end
    end
end
pSpf=imbinarize(pSpf,eps);
kernel_size = kernel_size / scal_factor;
apterCenterI = apterCenterI / scal_factor;
radia = radia / scal_factor;
centerPoint = round(apterCenterI+(kernel_size+1)/2);
psf=zeros(kernel_size);
x_start = max(1,min(centerPoint(:,1))-2*ceil(radia))-1;
x_end = min(kernel_size,max(centerPoint(:,1))+2*ceil(radia))-1;
y_start = max(1,min(centerPoint(:,2))-2*ceil(radia))-1;
y_end = min(kernel_size,max(centerPoint(:,2))+2*ceil(radia))-1;
for i=x_start:x_end
    for j=y_start:y_end
        psf(i+1,j+1)=sum(sum(pSpf(i*scal_factor+(1:scal_factor),j*scal_factor+(1:scal_factor))));
    end
end
% pSpf = imresize(pSpf,[kernel_size,kernel_size],'bilinear');
psf=psf./sum(sum(psf));%归一化
end
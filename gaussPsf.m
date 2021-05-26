function  psf = gaussPsf(apterCenterI, sigma,kernel_size)
pSpf = zeros(kernel_size);
centerPoint = apterCenterI+(kernel_size+1)/2;
if centerPoint(1)<0 || centerPoint(1) > kernel_size ...
    || centerPoint(2)<0 || centerPoint(2) > kernel_size
    disp("outof range")
    disp(centerPoint)
else
    %数值分布在(μ-σ,μ+σ)中的概率为0.6526;
    %2sigma原则:数值分布在(μ-2σ,μ+2σ)中的概率为0.9544;
    %3sigma原则:数值分布在(μ-3σ,μ+3σ)中的概率为0.9974;
    %to do 需要计算落在每格的大小
    if sigma<1/6
        pSpf(floor(centerPoint(1)),floor(centerPoint(2))) =...
            pSpf(floor(centerPoint(1)),floor(centerPoint(2)))+ 1/2;
        pSpf(ceil(centerPoint(1)),ceil(centerPoint(2))) =...
            pSpf(ceil(centerPoint(1)),ceil(centerPoint(2)))+ 1/2;
    elseif sigma<1/4
        pSpf(floor(centerPoint(1)),floor(centerPoint(2))) =...
            pSpf(floor(centerPoint(1)),floor(centerPoint(2)))+ 0.95/2;
        pSpf(ceil(centerPoint(1)),ceil(centerPoint(2))) =...
            pSpf(ceil(centerPoint(1)),ceil(centerPoint(2)))+ 0.95/2;
%     elseif sigma<1/2
%         pSpf(centerPoint(1),centerPoint(2)) = 0.65;
    else
        for i=1:kernel_size
            for j=1:kernel_size
                cordi = [i,j]-centerPoint;
                pSpf(i,j)=pSpf(i,j)+exp(-1*sum(abs(cordi).^2)/2/(sigma^2))/2/pi/(sigma^2);
            end
        end
    end
end
psf=pSpf./sum(sum(pSpf));%重新归一化
end
%@brief 生成coded apture 的掩膜
%@param index 掩膜的序号，一次从0到size
%@param size 掩膜的大小，表示所有可能掩膜的大小
%@return msk 掩膜
function msk = getMsk(index, size)
% power = log2(size);
msk=zeros(sqrt(size),sqrt(size));
for i = 1:size
    msk(i) = mod(floor(index/2^(i-1)),2);
end
end
% [mod(i,2),mod(floor(i/2),2);mod(floor(i/4),2),mod(floor(i/8),2)]
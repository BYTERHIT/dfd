%@brief ����coded apture ����Ĥ
%@param index ��Ĥ����ţ�һ�δ�0��size
%@param size ��Ĥ�Ĵ�С����ʾ���п�����Ĥ�Ĵ�С
%@return msk ��Ĥ
function msk = getMsk(index, size)
% power = log2(size);
msk=zeros(sqrt(size),sqrt(size));
for i = 1:size
    msk(i) = mod(floor(index/2^(i-1)),2);
end
end
% [mod(i,2),mod(floor(i/2),2);mod(floor(i/4),2),mod(floor(i/8),2)]
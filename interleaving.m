function [int_aft_interleav] = interleaving(int_pre_interleav, int_interleaving_array)
%   完成对接收数组的交织操作，生成的是进行交织处理后的数组；
%   建立数组int_pre_interleav,接收数据包；测试其长度，N=length(int_pre_interleav)；	
%   调用interleav_matrix 构造长度为N的交织矩阵；
%   将接收的数据包int_pre_interleav按interleav_matrix的规则写入int_aft_interleav； 
%   [int_ aft _interleav] = interleaving( int_pre_interleav ,int_interleaving_array) 
%   返回经过交织技术处理后的数组；

N = length( int_interleaving_array );   %测试int_interleaving_array的长度
n = length( int_pre_interleav );        %测试int_pre_interleav的长度

%%%  判断两者的长度是否相等   %%%
if  N == n
    int_aft_interleav=zeros(n,1);
    %%%  进行N次循环，对int_pre_interleav进行交织变换  %%%
    for i = 1:N
        add = int_interleaving_array( i );   %将int_interleaving_array中的内容依次取出，作为int_aft_interleav的地址
        int_aft_interleav( add ) = int_pre_interleav( i );  %int_aft_interleav( add )中的内容就是int_pre_interleav( i )中对应的值
    end
else
    error('Receiving  wrong  array');        %输出错误信息提示
end
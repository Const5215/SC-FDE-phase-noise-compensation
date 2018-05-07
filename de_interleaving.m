function [int_output] = de_interleaving( int_channeloutput_interleav ,int_interleaving_array )
%   完成对接收数组的解交织操作，生成的是原始的进行交织变换前的数组；
%	接收数据包int_channeloutput_interleav；交织矩阵  int_interleaving_array
%	将接收的数据包int_channeloutput_interleav按interleav_matrix的规则的反变换
%   进行解交织操作，写入int_output；   
%   function [int_output] = de_interleaving( int_channeloutput_interleav ,int_interleaving_array ) 
%   返回经过交织技术处理后的数组；

N = length( int_interleaving_array );   %测试int_interleaving_array的长度
n = length( int_channeloutput_interleav ); %测试int_channeloutput_interleav的长度

%%%   判断两者的长度是否相等   %%%
if  N == n
	int_output=zeros(n, 1);
	%   将接收的数据包按int_interleaving_array的规则的反变换写入int_output
	for i = 1:N
        %   将int_interleaving_array中的内容依次取出，作为int_channeloutput_interleav的地址
	    add = int_interleaving_array( i );
        %   int_output(i)中的内容既是地址为add的int_channeloutput_interleav中的内容
	    int_output( i ) = int_channeloutput_interleav( add );
	end
%   否则输出错误提示信息
else 
   error('receiving wrong array');
end
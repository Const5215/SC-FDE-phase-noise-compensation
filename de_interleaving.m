function [int_output] = de_interleaving( int_channeloutput_interleav ,int_interleaving_array )
%   ��ɶԽ�������Ľ⽻֯���������ɵ���ԭʼ�Ľ��н�֯�任ǰ�����飻
%	�������ݰ�int_channeloutput_interleav����֯����  int_interleaving_array
%	�����յ����ݰ�int_channeloutput_interleav��interleav_matrix�Ĺ���ķ��任
%   ���н⽻֯������д��int_output��   
%   function [int_output] = de_interleaving( int_channeloutput_interleav ,int_interleaving_array ) 
%   ���ؾ�����֯�������������飻

N = length( int_interleaving_array );   %����int_interleaving_array�ĳ���
n = length( int_channeloutput_interleav ); %����int_channeloutput_interleav�ĳ���

%%%   �ж����ߵĳ����Ƿ����   %%%
if  N == n
	int_output=zeros(n, 1);
	%   �����յ����ݰ���int_interleaving_array�Ĺ���ķ��任д��int_output
	for i = 1:N
        %   ��int_interleaving_array�е���������ȡ������Ϊint_channeloutput_interleav�ĵ�ַ
	    add = int_interleaving_array( i );
        %   int_output(i)�е����ݼ��ǵ�ַΪadd��int_channeloutput_interleav�е�����
	    int_output( i ) = int_channeloutput_interleav( add );
	end
%   �������������ʾ��Ϣ
else 
   error('receiving wrong array');
end
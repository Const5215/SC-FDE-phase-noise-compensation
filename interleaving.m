function [int_aft_interleav] = interleaving(int_pre_interleav, int_interleaving_array)
%   ��ɶԽ�������Ľ�֯���������ɵ��ǽ��н�֯���������飻
%   ��������int_pre_interleav,�������ݰ��������䳤�ȣ�N=length(int_pre_interleav)��	
%   ����interleav_matrix ���쳤��ΪN�Ľ�֯����
%   �����յ����ݰ�int_pre_interleav��interleav_matrix�Ĺ���д��int_aft_interleav�� 
%   [int_ aft _interleav] = interleaving( int_pre_interleav ,int_interleaving_array) 
%   ���ؾ�����֯�������������飻

N = length( int_interleaving_array );   %����int_interleaving_array�ĳ���
n = length( int_pre_interleav );        %����int_pre_interleav�ĳ���

%%%  �ж����ߵĳ����Ƿ����   %%%
if  N == n
    int_aft_interleav=zeros(n,1);
    %%%  ����N��ѭ������int_pre_interleav���н�֯�任  %%%
    for i = 1:N
        add = int_interleaving_array( i );   %��int_interleaving_array�е���������ȡ������Ϊint_aft_interleav�ĵ�ַ
        int_aft_interleav( add ) = int_pre_interleav( i );  %int_aft_interleav( add )�е����ݾ���int_pre_interleav( i )�ж�Ӧ��ֵ
    end
else
    error('Receiving  wrong  array');        %���������Ϣ��ʾ
end
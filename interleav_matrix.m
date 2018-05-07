function [int_interleaving_array] = interleav_matrix( int_interleaving_buffer )

N = length(int_interleaving_buffer);      %����int_interleaving_buffer�ĳ���
int_interleaving_array = [];              %��int_interleaving_array�ÿգ�

%%��int_interleaving_array�����жϣ�������� <= N,����int_interleaving_array����ƣ�
while ( length( int_interleaving_array ) ~= N ) 
    %%%  �Ը����������½��г�ʼ��  %%%
    int_interleaving_array = [];        %��int_interleaving_array�ÿ�
    int_number_array = [1:N];   %����int_number_array������ΪN���洢1--N��N������
    int_refuse_array = [];      %����int_refuse_array��ʹ�䳤��ΪN������Ϊ��
    
    %%%  ����������ĳ��Ƚ����жϣ���Ϊ��ʱ�������Խ�֯���������  %%%
    while  length( int_number_array ) > 0 
        %%%  ���������  %%%
        n = length(int_number_array);       %��������int_number_array�ĳ���   
        subscript = floor( n * rand + 1 );  %��1��N��N�������������ȡһ���±�subscipt
        int_rand_num = int_number_array( subscript ); %������±�����ʾ��λ����ȡ��ѡ�������int_random_num
        int_number_array( subscript ) = int_number_array( n ); %��int_number_array�����һ��ֵ����������subscriptλ��
        %%  ��int_number_array���¸�ֵ��ʹ�䳤��ΪN-1
        if  n == 1
            int_number_array = [];
        else
            int_number_array = int_number_array( 1:n-1 );
        end 
        %%%  ������S-��������   %%%
        s = floor( (N/2)^0.5 ) - 1;         %�趨�жϾ���S = [��N/2��^0.5]-1
        flag = 1;               %��ʼ��flag��ֵ
        %���int_interleaving_array�ĳ���С��s����s��Ϊint_interleaving_array�ĳ���
        len = length(int_interleaving_array);
        if  len < s
            s = len;
        end
        %���int_number_array�ĳ��Ȳ�����2*s��s��ֵ����
        if  n <= 2 * s
            s = floor( n/2 );
        end
        %��int_rand_num��int_interleaving_array�е����S��ֵ���бȽϣ�
        for i = 0:s-1
            %   �Ա�־λflag�����趨��
            if abs( int_interleaving_array ( len - i ) - int_rand_num ) <= s
                flag = 0;       %�������С��s,��flag��0������ѭ��
                break;
            end
        end       
        %%%  ��־λΪ0������ܾ�����  %%%
        if  flag == 0
            int_refuse_array = int_rand_num;
        else
            int_interleaving_array = [int_interleaving_array,int_rand_num];     %������������뽻֯����
        end
        %%%   �Ծܾ�������д���   %%%
        if  length( int_refuse_array ) > 0
            int_number_array = [int_number_array,int_refuse_array];     %���ܾ������е����ּ���int_number_array
            int_refuse_array = [];          %��վܾ�����
        end
    end
end
            
        
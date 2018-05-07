function [int_interleaving_array] = interleav_matrix( int_interleaving_buffer )

N = length(int_interleaving_buffer);      %测试int_interleaving_buffer的长度
int_interleaving_array = [];              %将int_interleaving_array置空；

%%对int_interleaving_array进行判断，如果长度 <= N,进行int_interleaving_array的设计；
while ( length( int_interleaving_array ) ~= N ) 
    %%%  对各个数组重新进行初始化  %%%
    int_interleaving_array = [];        %将int_interleaving_array置空
    int_number_array = [1:N];   %生成int_number_array，长度为N，存储1--N这N个整数
    int_refuse_array = [];      %生成int_refuse_array，使其长度为N，内容为空
    
    %%%  对数字数组的长度进行判断，不为空时，继续对交织器进行设计  %%%
    while  length( int_number_array ) > 0 
        %%%  产生随机数  %%%
        n = length(int_number_array);       %测量数组int_number_array的长度   
        subscript = floor( n * rand + 1 );  %从1至N这N个数字中随机获取一个下标subscipt
        int_rand_num = int_number_array( subscript ); %从这个下标所表示的位置提取所选的随机数int_random_num
        int_number_array( subscript ) = int_number_array( n ); %将int_number_array中最后一个值存入该数组的subscript位置
        %%  对int_number_array重新赋值，使其长度为N-1
        if  n == 1
            int_number_array = [];
        else
            int_number_array = int_number_array( 1:n-1 );
        end 
        %%%  测试其S-距离特性   %%%
        s = floor( (N/2)^0.5 ) - 1;         %设定判断距离S = [（N/2）^0.5]-1
        flag = 1;               %初始化flag的值
        %如果int_interleaving_array的长度小于s，将s设为int_interleaving_array的长度
        len = length(int_interleaving_array);
        if  len < s
            s = len;
        end
        %如果int_number_array的长度不大于2*s，s的值减半
        if  n <= 2 * s
            s = floor( n/2 );
        end
        %将int_rand_num与int_interleaving_array中的最后S个值进行比较；
        for i = 0:s-1
            %   对标志位flag进行设定；
            if abs( int_interleaving_array ( len - i ) - int_rand_num ) <= s
                flag = 0;       %如果距离小于s,则flag置0，跳出循环
                break;
            end
        end       
        %%%  标志位为0，记入拒绝数组  %%%
        if  flag == 0
            int_refuse_array = int_rand_num;
        else
            int_interleaving_array = [int_interleaving_array,int_rand_num];     %将此随机数记入交织数组
        end
        %%%   对拒绝数组进行处理   %%%
        if  length( int_refuse_array ) > 0
            int_number_array = [int_number_array,int_refuse_array];     %将拒绝数组中的数字记入int_number_array
            int_refuse_array = [];          %清空拒绝数组
        end
    end
end
            
        
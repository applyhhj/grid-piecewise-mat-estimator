function [ A ] = primMinTree( G )
% from http://www.cnblogs.com/tiandsp/archive/2013/04/10/3012181.html
% test data
% G=[ 0 4 0 0 0 0 0 8 0;
%     4 0 8 0 0 0 0 11 0;
%     0 8 0 7 0 4 0 0 2;
%     0 0 7 0 9 14 0 0 0;
%     0 0 0 9 0 10 0 0 0;
%     0 0 4 14 10 0 2 0 0;
%     0 0 0 0 0 2 0 1 6;
%     8 11 0 0 0 0 1 0 7;
%     0 0 2 0 0 0 6 7 0];

[m,n]=size(G);

q=1;      %�Ѿ�����ǵ�Ԫ��
k=1;        %�Ѿ���ǵ�Ԫ�ظ���
A=[];       %����������С������
while length(q)~=m
    e=[];
    for i=1:k
        for j=1:n
            if G(q(i),j)~=0 && ~mark(j,q) %�������е�Ԫ��
                e=[e;G(q(i),j) q(i) j];
            end
        end
    end
    
    [~, index]=min(e(:,1));    %���뵱ǰ��ǵ�����Ԫ�����ڵ�Ȩ����С�ıߵ�����
    A=[A;e(index,:)];       %��С����������Ԫ���ʾ weight i j
    q=[q e(index,3)];
    k=k+1;
end

A=A(:,2:3);

    function re=mark(j,marked)  %�ж�j���Ƿ��ѱ����
        l=length(marked);
        for k1=1:l
            if j==marked(k1)
                re=1;
                return;
            end
        end
        re=0;
        return;
    end

end


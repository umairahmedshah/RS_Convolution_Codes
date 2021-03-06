function lamda=bkm(syn,primpol,m)
q=8;
pp=bi2de(fliplr([1 0 0 0 1 1 1 0 1]));
S1=syn;
n=power(2,q);
t=(size(S1,2))/2;
S(1:16)=[0];
for i=1:16
if S1(1,i)==-Inf
    S(1,i)=0;
else
    S(1,i)=S1(1,i);
end 
end
S=[0 S];    
S=S';
for j=2:size(S,1)
   temp=zeros(1,n-1);
    temp(S(j)+1)=1;
    [qu r]=gfdeconv(temp,de2bi(pp));
    S(j)=bi2de(r);
end
S=gf(S,q,pp);
del=gf([1; zeros(2*t,1)],q,pp); 
eloc=gf(zeros(2*t+1,t+1),q,pp); eloc(:,1)=1;
L=zeros(2*t+1,1); 
m=zeros(2*t+1,1);
for k=1:2*t
    SPRED=gf(0,q,pp);
    if k==1
        SPRED=0;
    else
        for i=1:L(k)
            SPRED=SPRED+eloc(k,i+1)*S(k-i+1);
        end
    end
    del(k+1)=S(k+1)-SPRED;
    if del(k+1)==0
        eloc(k+1,:)=eloc(k,:);
        L(k+1)=L(k);
    else
        if k>1
            m(k+1)=find(L==L(k), 1 )-1;
        end
        if m(k+1)<1
            z=0;
            y=[1 zeros(1,t)];
        else
            z=L(m(k+1));
            y=eloc(m(k+1),:);
        end
        eshift=[zeros(1,k-m(k+1)) y];
        eshift=eshift(1:t+1);
        eloc(k+1,:)=eloc(k,:)-del(k+1)*(1/del(m(k+1)+1))*eshift;
        L(k+1)=max(L(k),z+k-m(k+1));
    end
    
end
%% output in powers of alpha
field = bi2de(gftuple([-1:2^q-2]',de2bi(pp),2));
elocf=zeros(2*t+1,t+1);
for i=1:(2*t+1)
    for j=1:(t+1)
        k=find(field==eloc(i,j));
        elocf(i,j)=k-2;
    end
end
lamda=elocf(2*t+1,:);
end


        



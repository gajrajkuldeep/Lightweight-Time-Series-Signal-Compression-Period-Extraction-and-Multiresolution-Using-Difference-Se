% generate NXN matrix containg all difference sequences up to N
function W2 = diffSeq(N)

%clear all;close all;clc;
%N=50;
W2=zeros(N,N);
a=[1 ; -1];
W2(:,1)=ones(N,1);
for k=1:N
            if(k<=2)
            W2(k,2)=a(k,1);
            else
                if(mod(k,2)==0)
                 W2(k,2)=a(2,1);
                else
                 W2(k,2)=a(mod(k,2),1);
                end
            end
end
        
for i=3:N
    if(isprime(i))
        b=zeros(i-2,1);
        c=[b;a];
        for k=1:N
            if(k<=i)
            W2(k,i)=c(k,1);
            else
                if(mod(k,i)==0)
                    W2(k,i)=c(i,1);
                else
                    W2(k,i)=c(mod(k,i),1);
                end
            end
        end
    else
        d=factor(i);
        unid=unique(d);
        lenu=length(unid);
        if(lenu==1)
            e=zeros(i,1);
            
            for k=1:d(1)
            e(k+((k-1)*(i/d(1)-1)),1)=W2(k,d(1));
            %e(k+((k-1)*(i/d(1)-1)),1)=(i/d(1))*W2(k,d(1));
            end
            
            for k=1:N
                if(k<=i)
                W2(k,i)=e(k,1);
                else
                    if(mod(k,i)==0)
                        W2(k,i)=e(i,1);
                    else
                        W2(k,i)=e(mod(k,i),1);
                    end
                end
            end
            
        else
            for k=1:lenu
                lend=length(find(d==unid(k)));
                muld(k)=unid(k)^lend;
            end
            f=ones(i,1);
            for k=1:lenu
                f=f.*W2(1:i,muld(k));
            end
            for k=1:N
                if(k<=i)
                W2(k,i)=f(k,1);
                else
                    if(mod(k,i)==0)
                        W2(k,i)=f(i,1);
                    else
                        W2(k,i)=f(mod(k,i),1);
                    end
                end
            end
        end
        
    end
    
end
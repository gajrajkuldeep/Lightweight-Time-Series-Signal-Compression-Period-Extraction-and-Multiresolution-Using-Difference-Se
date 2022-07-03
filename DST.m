% To generate D_N matrix for a given N
function F = DST(N)


z= diffSeq(N);  % all difference sequences 
F=zeros(N,N);
k=1;
for i = 1:N
    if(rem(N,i)==0) % i is a divisor of N
        F(:,k)=z(1:N,i);
        X=F(:,k);
       rp= length(find(gcd(1:i,i)==1)); %rp contains the no. of relatively prime to i
       for j = 1:rp-1
           F(:,k+j) = circshift(X,1);
          X=F(:,k+j);
       end
        k=k+rp;
    end
end
F=F';
end


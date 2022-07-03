
function s = projection_matrix(N)

z=diffSeq(N);
k=1;ind = 1;
s = cell(N,1);
if(isprime(N))
    t=z(1:N,N);
    for j = 1:N
        B(:,j) = circshift(t,(j-1));
    end
    s{ind}=B;
else
    for i = 2:N
        if(rem(N,i)==0) % i is a divisor of N
            B(:,k)=z(1:N,i);
            d=i;
            X=B(:,k);
            for j = 1:d-1
                B(:,k+j) = circshift(X,1);
                X=B(:,k+j);
            end
            k=1;
            s{ind,1} = B(1:d,:);
            ind = ind +1;
        end
    end
end
end
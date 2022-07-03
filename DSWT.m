function h = DSWT(M,N)
 A = DST(M)';
Gmat=[];
for z=1:1:M
for i=0:1:(N/M)-1
    
Gmat{i+((z-1)*N/M)+1}=circshift([A(:,z);zeros(N-M,1)], M*i);
    
end
end
h=zeros(N,N);
for j=1:1:N
    h(:,j)=Gmat{j};
end
h=h';
end
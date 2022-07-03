clear all;close all;clc;
% NP=primes(512);
NP=1:512;
for j=1:length(NP)
A=DST(NP(j));

for i=1:NP(j)
    Sum(i)=length(find(abs(A(i,:))==1))-1;
end
NumberOfAdditions(j)=sum(Sum);

end
Add_DCT=NP.*log2(NP);
T=4;
Add_DWT=2*NP*4-4;


stem(NP,NumberOfAdditions)
hold on;
stem(NP,Add_DCT)
stem(NP,Add_DWT)

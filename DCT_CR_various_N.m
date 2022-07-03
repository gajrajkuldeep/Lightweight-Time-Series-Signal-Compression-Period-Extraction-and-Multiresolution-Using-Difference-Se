clear all;close all;clc;
N=512; % DCT and DWT signal length
N1=509; % DST signal length
fileno=[100:1:109,111:1:119,121:1:124,200:1:203,205,207:1:210,212:1:215,217,219:1:223,228,230:234];
s1='ECG/';
d=1;
for N1=500:512
for flen=1:length(fileno)
Cfile=sprintf('%s%dm.mat',s1,fileno(flen));
load(Cfile);
sig=val(1,:)';
for block=1:20

DST_mat=DST(N1);

x_DST=sig(1+(block-1)*N1:block*N1,1);
yDST=DST_mat*x_DST;

[p,symbols]=hist(yDST,unique(yDST));
 p=p/sum(p);
 
 [dict_DST,avglen_DSWT] = huffmandict(symbols,p); 
% 
 compECG_DST = huffmanenco(yDST,dict_DST);
 BitRate_DST(block,flen)=N1*11/length(compECG_DST);
end

end
a(d,:)=mean(BitRate_DST);
d=d+1;
end


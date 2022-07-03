clear all;close all;clc;
dwtmode('per'); % to have equal length wavlet coefficient
N=512; % DCT and DWT signal length
N1=509; % DST signal length
remove_coeffi=200;
fileno=[100:1:109,111:1:119,121:1:124,200:1:203,205,207:1:210,212:1:215,217,219:1:223,228,230:234];
s1='ECG/';
for flen=1:length(fileno)
Cfile=sprintf('%s%dm.mat',s1,fileno(flen));
load(Cfile);
sig=val(1,:)';
for block=1:20
x=sig(1+(block-1)*N:block*N,1);
[LoD,HiD] = wfilters('db10','d');
[y1,y2]=dwt(x,LoD,HiD);
yDWT=[y1;y2];
yDWT=round(yDWT);
[p,symbols]=hist(yDWT,unique(yDWT));
 p=p/sum(p);
 
 [dict_WT,avglen_WT] = huffmandict(symbols,p); 
% 
 compECG_WT = huffmanenco(yDWT,dict_WT);
 yDWTdecoded = huffmandeco(compECG_WT,dict_WT);
 x_rec_DWT=idwt(yDWTdecoded(1:N/2),yDWTdecoded(N/2+1:end),'db10');
 mse_DWT(block,flen)=mse(x,x_rec_DWT);
 BitRate_WT(block,flen)=N*11/length(compECG_WT);
 


yDCT=round(dctmtx(N)*x);

[p,symbols]=hist(yDCT,unique(yDCT));
 p=p/sum(p);
 
 [dict_DCT,avglen_Haar] = huffmandict(symbols,p); 
% 
 compECG_DCT = huffmanenco(yDCT,dict_DCT);
 yDCTdecoded = huffmandeco(compECG_DCT,dict_DCT);
 x_rec_DCT=idct(yDCTdecoded);
 mse_DCT(block,flen)=mse(x,x_rec_DCT);
 
 BitRate_DCT(block,flen)=N*11/length(compECG_DCT);



DST_mat=DST(N1);

x_DST=sig(1+(block-1)*N1:block*N1,1);
yDST=DST_mat*x_DST;

[p,symbols]=hist(yDST,unique(yDST));
 p=p/sum(p);
 
 [dict_DST,avglen_DST] = huffmandict(symbols,p); 
% 
 compECG_DST = huffmanenco(yDST,dict_DST);
 yDSTdecoded = huffmandeco(compECG_DST,dict_DST);
 x_rec_DST=inv(DST_mat)*yDSTdecoded;
 mse_DST(block,flen)=mse(x_DST,x_rec_DST);
 BitRate_DST(block,flen)=N1*11/length(compECG_DST);
end

end
figure(1);
bar(mean(BitRate_DST),.6);
hold on
bar(mean(BitRate_DCT),.6);
bar(mean(BitRate_WT),.6);
legend('DST','DCT','DWT')
xlabel('ECG records'); ylabel('CR');
hold off 
% plot(mean(BitRate_WT'));
% hold on
% 
mean(mean(BitRate_DST))
mean(mean(BitRate_DCT))
mean(mean(BitRate_WT))
% plot(mean(BitRate_DSWT'));
figure(2);
plot(mean(mse_DCT)); hold on;
plot(mean(mse_DWT));
plot(mean(mse_DST));
legend('DCT','DWT','DST')

xlabel('ECG records'); ylabel('MSE');
hold off 


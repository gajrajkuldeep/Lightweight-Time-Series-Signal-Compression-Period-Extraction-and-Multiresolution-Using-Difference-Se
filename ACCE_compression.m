clear all;close all;clc;
ACC_axis=4; % 2 for x axis; 3 for y axis; 4 for z axis 
dwtmode('per'); % to have equal length wavlet coefficient
N=512;
fileno=["rest1_acc.mat","rest2_acc.mat","rest3_acc.mat","rest4_acc.mat","rest5_acc.mat","squat1_acc.mat","squat2_acc.mat","squat3_acc.mat","squat4_acc.mat","squat5_acc.mat","step1_acc.mat","step2_acc.mat","step3_acc.mat","step4_acc.mat","step5_acc.mat"];
s1='S1/';
for flen=1:length(fileno)
Cfile=sprintf('%s%s',s1,fileno(flen));
load(Cfile);
 sig=ACC(:,ACC_axis); % x-axis
%sig=ACC(:,3); % y-axis
 %sig=ACC(:,4); % z-axis
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
 BitRate_WT(block,flen)=N*16/length(compECG_WT);
 


yDCT=round(dctmtx(N)*x);

[p,symbols]=hist(yDCT,unique(yDCT));
 p=p/sum(p);
 
 [dict_DCT,avglen_Haar] = huffmandict(symbols,p); 
% 
 compECG_DCT = huffmanenco(yDCT,dict_DCT);
 yDCTdecoded = huffmandeco(compECG_DCT,dict_DCT);
 x_rec_DCT=idct(yDCTdecoded);
 mse_DCT(block,flen)=mse(x,x_rec_DCT);
 BitRate_DCT(block,flen)=N*16/length(compECG_DCT);

N1=509;

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
 BitRate_DST(block,flen)=N1*16/length(compECG_DST);
end

end
bar(mean(BitRate_DST),.8);
hold on
bar(mean(BitRate_DCT),.6);
bar(mean(BitRate_WT),.4);
legend('DST','DCT','DWT')
xlabel('Accelerometer records'); ylabel('CR');
% plot(mean(BitRate_WT'));
% hold on
% 
% plot(mean(BitRate_DSWT'));

mean(mean(BitRate_DST))
mean(mean(BitRate_DCT))
mean(mean(BitRate_WT))

mean(mean(mse_DST))
mean(mean(mse_DCT))
mean(mean(mse_DWT))
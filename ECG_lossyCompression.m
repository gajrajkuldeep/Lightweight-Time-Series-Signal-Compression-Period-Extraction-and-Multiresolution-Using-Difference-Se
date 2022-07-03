 clear all;close all;clc;
 dwtmode('per'); % to have equal length wavlet coefficient
N=512;
remove_coeffi=200;
fileno=[100:1:109,111:1:119,121:1:124,200:1:203,205,207:1:210,212:1:215,217,219:1:223,228,230:234];
s1='ECG/';
block=1;
for flen=1:length(fileno)
Cfile=sprintf('%s%dm.mat',s1,fileno(flen));
load(Cfile);
sig=val(1,:)';
x=sig(1:N,1);
DCT_mat=dctmtx(N);
yDCT=DCT_mat*x;
%yDCT=round(yDCT);

[LoD,HiD] = wfilters('db10','d');
[y1,y2]=dwt(x,LoD,HiD);
yDWT=[y1;y2];
%yDWT=round(yDWT);

[LoDH,HiDH] = wfilters('haar','d');
[y1H,y2H]=dwt(x,LoDH,HiDH);
yHAAR=[y1H;y2H];
%yHAAR=round(yHAAR);

N1=509;

DST_mat=DST(N1);

x_DST=sig(1+(block-1)*N1:block*N1,1);
yDST=DST_mat*x_DST;

for j=1:remove_coeffi
   
   [value_DST, index_DST]=sort(abs(100*yDST));
    index_DST=index_DST(1:j,1); % first j values set to zero
    yDST(index_DST)=0;
    x_rec_DST=inv(DST_mat)*yDST;
  
    prd_DST(flen,j)=(norm(x_DST-x_rec_DST)/norm(x_DST))*100;
    mse_DST(flen,j)=mse(x_DST,x_rec_DST);
   
    [value_HAAR, index_HAAR]=sort(abs(100*yHAAR));
    index_HAAR=index_HAAR(1:j,1); % first j values set to zero
    yHAAR(index_HAAR)=0;
    x_rec_HAAR=idwt(yHAAR(1:N/2),yHAAR(N/2+1:end),'haar');
    prd_HAAR(flen,j)=(norm(x-x_rec_HAAR)/norm(x))*100;
    mse_HAAR(flen,j)=mse(x,x_rec_HAAR);
    [value_DCT, index_DCT]=sort(abs(100*yDCT));
    index_DCT=index_DCT(1:j,1); % first j values set to zero
    yDCT(index_DCT)=0;
    x_rec_DCT=inv(DCT_mat)*yDCT;
    mse_DCT(flen,j)=mse(x,x_rec_DCT);
    prd_DCT(flen,j)=(norm(x-x_rec_DCT)/norm(x))*100;
    
    [value_DWT, index_DWT]=sort(abs(100*yDWT));
    index_DWT=index_DWT(1:j,1); % first j values set to zero
    yDWT(index_DWT)=0;
    x_rec_DWT=idwt(yDWT(1:N/2),yDWT(N/2+1:end),'db10');
    mse_DWT(flen,j)=mse(x,x_rec_DWT);
    prd_DWT(flen,j)=(norm(x-x_rec_DWT)/norm(x))*100;
    
end
end

 plot(mean())
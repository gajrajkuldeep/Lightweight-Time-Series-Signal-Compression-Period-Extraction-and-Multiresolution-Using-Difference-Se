clear all;close all;clc;
N=512;
d=3;
N=d*floor(N/d);

ImageInput= double(imresize(imread('Images/mandrill.pgm'),[N N]));

B=DSWT(d,N);

Y=B*ImageInput*B';
Y(1:170,1:170)=Y(1:170,1:170)/30;
figure(1);
imshow((Y/100));

Y(1:170,1:170)=0;
imageEdge=inv(B)*Y*inv(B');
figure(2);
imshow(uint8(imageEdge*7))
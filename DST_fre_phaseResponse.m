clear all;close all;clc;
N=6;
A=DST(N);
figure(1);
hold on;
for i=1:N
plot(abs(fft(A(i,:))));
end
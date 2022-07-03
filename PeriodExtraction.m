% To find projection energy

clear all;close all;clc;
rng(100);
period1 = 7;
period2 =5;
period3 =8;
N = lcm(period1,period2);
N=lcm(period3,N);
N=N*2;
Sq = projection_matrix(N);

temp1 = (randn(1,period1));
signal1 =[];
for i = 1:N/length(temp1)
    signal1 = [signal1 temp1];
end
signal2 = [];
temp2 = (randn(1,period2));
for i = 1:N/length(temp2)
    signal2 = [signal2 temp2];
end
signal3 = [];
temp3 = (randn(1,period3));
for i = 1:N/length(temp3)
    signal3 = [signal3 temp3];
end
signal = signal1 + signal2 + signal3;
% temp = 2*round(ones(1,period));
% signal = [temp zeros(1,period) temp zeros(1,period) temp zeros(1,period) temp zeros(1,period)];
% signal = awgn(signal,1); % adds noise to the signal
% signal = cconv(signal,signal,32);
% signal = signal(1:32);

divisors = find(rem(N,1:N)==0);
eng(1) = sum(signal.^2)/N;
for i = 2:length(divisors)
    ith_divisor = divisors(i);
    blk_signal = zeros(1,ith_divisor);
    for k = 1:(ith_divisor):length(signal)
        blk_signal = blk_signal + signal(k:k+(ith_divisor-1));
    end
    yq = Sq{i-1}*blk_signal';
    eng(i) = yq'*yq/(N*ith_divisor);
end
%subplot(311);
%signal=[signal,signal];

plot(signal);
hold on;
plot(signal1)
plot(signal2)
plot(signal3)
figure
stem(divisors,eng);grid on;axis([1 N/2 0 max(eng)]);
stem(divisors,eng);grid on;axis([1 20 0 max(eng)]);

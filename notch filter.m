clc;clear;
%[aud,ff] = audioread("asd.ogg");

fs = 8000;
t = (0:(4551-1))/fs;
signal = cos(2*pi*4000*t);
norm_signal = (signal - min(signal)) / ( max(signal) - min(signal) )
fn1 = 1000;
fn2 = 2000;
fn3 = 3000;

noise1 = cos(2*pi*1000*t);
noise2 = cos(2*pi*2000*t);
noise3 = cos(2*pi*3000*t);

summ = noise1+signal+noise2+noise3;
%summ = aud+noise1+noise2+noise3;
norm_summ = (summ - min(summ)) / ( max(summ) - min(summ) )
r = 0.99;
b = [1 -2*cos(2*pi*fn1/fs) 1];
a1 = [1 -2*r*cos(2*pi*fn1/fs) r^2];    % filter coefficients
b1 = b/sum(b)*sum(a1); 
%[H1, om] = freqz(b, a);
%y2 = filter(b, a, summ);

b = [1 -2*cos(2*pi*fn2/fs) 1];
a2 = [1 -2*r*cos(2*pi*fn2/fs) r^2];    % filter coefficients
b2 = b/sum(b)*sum(a2); 
%[H2, om] = freqz(b, a);
%y2 = filter(b, a, y2);

b = [1 -2*cos(2*pi*fn3/fs), 1];
a3 = [1 -2*r*cos(2*pi*fn3/fs) r^2];    % filter coefficients
b3 = b/sum(b)*sum(a3); 
%[H3, om] = freqz(b, a);
%y2 = filter(b, a, y2);
A = conv(a1,a2);
A = conv(A,a3);
B = conv(b1,b2);
B = conv(B,b3);
y2 = filter(B, A, summ);
[h,m] = freqz(B, A);
plot((m)/2*pi*fs,abs(h))
norm_filt = (y2 - min(y2)) / ( max(y2) - min(y2) )
pause(1)
player1 = audioplayer(norm_signal,fs,8)
play(player1)
pause(1)
player1 = audioplayer(summ,fs,8)
play(player1)
pause(2);
player2 = audioplayer(y2,fs,8)
play(player2)
##audiowrite("filered.ogg",norm_filt,fs);
##audiowrite("summ.ogg",norm_summ,fs);
##audiowrite("audd.ogg",signal,fs);

pause(1);
##
subplot(3,1,1);
plot(t*1000*14.05,abs(fft(signal)))
title("pure signal");
subplot(3,1,2);
plot(t*1000*14.05,abs(fft(summ)));
title("noise induced");
subplot(3,1,3)
plot(t*1000*14.05,abs(fft(y2)));
title("filtered signal")

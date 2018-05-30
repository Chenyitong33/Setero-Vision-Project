% 5. Spectral Cross Correlation

%--------------------------------------------------------------------------------------------
text1 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment1','sensor1_data_general(1).txt');
text2 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment1','sensor2_data_general(1).txt');

s1 = transpose(dlmread(text1,'\t',1,0));
s2 = transpose(dlmread(text2,'\t',1,0));

% s1 = [1 2 3 4 5];
% s2 = [6 7 8 9 10];

lengtha = length(s1);
lengthb = length(s2);
l = lengtha+lengthb-1;

tic
% correlation using FFT
r = ifft(fft(s1,l).*conj(fft(s2,l)));
r = fftshift(r);
toc

% generate lag vector
lag = zeros(1,length(s1)*2-1);
init = (length(s1)-1)*(-1);
for i = 1:(length(s1)*2-1)
    lag(i) = init + i - 1;
end

% plot the cross correlation over lag vector
figure
plot(lag,r);
xlabel('lag')
ylabel('correlation value')

Fs = 44100;
Speed = 333;

[~,I] = max(abs(r));
lagDiff = lag(I);
timeDiff = lagDiff/Fs;
distance = timeDiff * Speed;


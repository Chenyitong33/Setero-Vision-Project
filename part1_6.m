% 6. Bonus: Pattern Finder

% read the audio
song = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment1','imperial_march.wav');
[y,Fs] = audioread(song);

% plot the original sound (search region)
subplot(2,1,1)
t1 = (0:length(y)-1)/Fs;
plot(t1,y)
title('original sound')
xlabel('Time (s)')

% transpose to make it a vector
y = transpose(y);

template = zeros(1,length(y));
template(1:10000) = y(50001:60000);

% plot the template sound
subplot(2,1,2)
t2 = (0:length(template)-1)/Fs;
plot(t2,template)
title('template sound')
xlabel('Time (s)')

% get the length of r
lengtha = length(template);
lengthb = length(y);
l = lengtha+lengthb-1;

% correlation using FFT
r = ifft(fft(template,l).*conj(fft(y,l)));
r = fftshift(r);

% generate lag vector
lag = zeros(1,length(y)*2+1);
init = length(y)*(-1);
for i = 1:(length(y)*2+1)
    lag(i) = init + i - 1;
end


% Use the plot to find the high points (split value) at about 15-20.
figure
plot(r)
xlabel('Index')
ylabel('Correlation value')
% initialize the index vector
I=[];
% try 16 to find the occurrences here
for i = 1:length(r)
    if (abs(r(i)) > 16) 
        I = [I i];
    end
end

% Show the resulting correlation vector and then line up the occurrences of the element on a plot of the
% signal (x-axis: time, y-axis: frequency)
figure
y = zeros(1,length(y));
plot(t1,y)
title('sound')
xlabel('Time (s)')
ylabel('Frequency')

for i = 1:length(I)
    hold on;
%   get the lag of index
    lagDiff = lag(I(i));
	timeDiff = lagDiff/Fs;
    plot(timeDiff*(-1), 1.0,'r*');
end

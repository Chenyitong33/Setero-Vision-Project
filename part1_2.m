% 2. Signal Offset

% read the files
text1 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment1','sensor1_data_general(1).txt');
text2 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment1','sensor2_data_general(1).txt');
s1 = transpose(dlmread(text1,'\t',1,0));
s2 = transpose(dlmread(text2,'\t',1,0));

% load sample rate, speed and create time vectors and plot the signals
Fs = 44100;
Speed = 333;
t1 = (0:length(s1)-1)/Fs;
t2 = (0:length(s2)-1)/Fs;

% plot the signals with time series
subplot(2,1,1)
plot(t1,s1)
title('s_1')
subplot(2,1,2)
plot(t2,s2)
title('s_2')
xlabel('Time (s)')

%------------------------------------------------------------------------

% make zero vector in the same size and concat to s2
N = zeros(size(s1));
s2 = horzcat(N,s2,N);

% calculate the time of cross correlation function
tic
r = correlation_vector(s1,s2);
toc

% plot the original correlation vector using customized function
figure
plot(r);
xlabel('index')
ylabel('correlation value')

%trim the first and the last element (0)
acor = r(2:end-1);
% generate lag vector
lag = zeros(1,length(s1)*2-1);
init = (length(s1)-1)*(-1);
for i = 1:(length(s1)*2-1)
    lag(i) = init + i - 1;
end

% replot the cross correlation over lag vector
figure
plot(lag,acor);
xlabel('lag')
ylabel('correlation value')
% find the max correlation value with its index, which could used to get
% the delay
[~,I] = max(abs(acor));
lagDiff = lag(I);
timeDiff = lagDiff/Fs;
distance = timeDiff * Speed;

%% correlation function
function r = correlation_vector(x,y)
if ~isvector(x)
    error('Input must be a vector')
end
if ~isvector(y)
    error('Input must be a vector')
end
% Iteration time of the for loop
times = length(y)-length(x)+1;
% Initialize the correlation vector r
r = zeros(1,times);
for i = 1:times
    for j = 1:size(x,2)
        r(i) = r(i) + x(j) * y(j+i-1);
    end
end
end



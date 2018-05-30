% 1. Spatial Cross Correlation + Normalised Spatial Cross Correlation in 1d

% 1) See A and B are random vectors with the same size
A = rand(1,3);   % generate vector A using rand()
B = rand(size(A));% generate vector B with the same size

ZEROS = zeros(size(A));
% Put same size of zero at the beginning and end of B.
B = horzcat(ZEROS,B,ZEROS);

% Iteration time of the for loop
times = length(B)-length(A)+1;
% Initialize the correlation vector r
r = zeros(1,times);

for i = 1:times
    r(i) = A(1) * B(i) + A(2) * B(i+1) + A(3) * B(i+2);
end
plot(r);
xlabel('index')
ylabel('correlation value')

%2) Normalised the correlation vector

% Initialize the correlation vector r
normalised_r = zeros(1,times);
normalised_A = A/norm(A);
normalised_B = B/norm(B); 
%r2 = xcorr(normalised_A, normalised_B, 'none');

for i = 1:times
    normalised_r(i) = normalised_A(1) * normalised_B(i) + normalised_A(2) * normalised_B(i+1) + normalised_A(3) * normalised_B(i+2);
end
figure
plot(normalised_r);
xlabel('index')
ylabel('correlation value')
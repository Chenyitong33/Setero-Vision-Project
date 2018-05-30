% 4. Where¡¯s Wally
tic
% read the images, make them grayscaled and double byte
image1 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment1','wallypuzzle_rocket_man.png');
image2 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment1','wallypuzzle_png.png');

M1 = imread(image1); %template
M2 = imread(image2); %search region
M1 = rgb2gray(im2double(M1));
M2 = rgb2gray(im2double(M2));
%imshow(M2);

% Subtract the mean value so that there are roughly equal numbers of negative and positive values.
nimg = M2-mean(mean(M2));
nSec = M1-mean(mean(M1));

[M,N] = size(nimg);
m = 1:M;
n = 1:N;

[P,Q] = size(nSec);
p = 1:P;
q = 1:Q;

% Make a zero matrix and put the search region in the center
Xt = zeros([M+2*P N+2*Q]);
Xt(m+P,n+Q) = nimg;

% initialize the cross correlation matrix
C = zeros([M+P N+Q]);

for k = 1:M+P+1
    for l = 1:N+Q+1
        Xtl = Xt(p+k-1,q+l-1); %(1:P)+k-1,(1:Q)+l-1 because k and l start from 1 (should be 0).
        C(k,l) = sum(sum(Xtl.*conj(nSec)))/sqrt(sum(dot(Xtl,Xtl))*sum(dot(nSec,nSec)));%normalisation
    end
end

% trim zeros around the matrix
C = C(2:(M+P),2:(N+Q));

% The maximum of the cross-correlation corresponds to the estimated location of the lower-right corner of the section. 
% Use ind2sub to convert the one-dimensional location of the maximum to two-dimensional coordinates.
[ssr,snd] = max(C(:));
[ij,ji] = ind2sub(size(C),snd);

figure
plot(C(:))
title('Cross-Correlation')
xlabel('index')
ylabel('correlation value')
hold on
plot(snd,ssr,'or')
hold off
text(snd*1.05,ssr,'Maximum')
% draw the original search region image
figure
imshow(M2);
x1=ij-size(M1,1)+1;
x2=ij;
y1=ji-size(M1,2)+1;
y2=ji;

% draw the rectangle on the image
hold on;
x = [x1, x2, x2, x1, x1];
y = [y1, y1, y2, y2, y1];
plot(y, x, 'r');
plot(y1+(y2-y1)/2,x1+(x2-x1)/2, 'r*');%red star
hold off

toc
% 3. Spatial Cross Correlation + Normalised Spatial Cross Correlation in 2d

% Images are just a matrix of grayscaled pixel values 
% read the images.
image1 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment1','apple.png');
image2 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment1','small.jpg');
M1 = imread(image1); %search region
M2 = imread(image2); %template
M1 = rgb2gray(im2double(M1));%greyscale
M2 = rgb2gray(im2double(M2));%greyscale

% show the images
subplot(2,1,1)
imshow(M2);
title('template image')
subplot(2,1,2)
imshow(M1);
title('search region')

img = M1;% M1 is the search region (whole image)
Sec = M2;% M2 is the template (section)

% Subtract the mean value so that there are roughly equal numbers of negative and positive values.
nimg = img-mean(mean(img));
nSec = Sec-mean(mean(Sec));


% The 2-D Correlation block computes the two-dimensional cross-correlation of two input matrices. 
% Assume that matrix A has dimensions (Ma, Na) and matrix B has dimensions (Mb, Nb). 
% When the block calculates the full output size, the equation for the two-dimensional discrete cross-correlation is
% C(i,j) = (Ma-1)¡Æm=0 (Na-1)¡Æn=0 A(m,n).conj(B(m+i,n+j)), where 0¡Üi<Ma+Mb-1 and 0¡Üj<Na+Nb-1.

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

% trim NaN surrounding the matrix
C = C(2:(M+P),2:(N+Q));

C_test = normxcorr2(M2, M1);
figure
shading interp
surf(C);
title('normalised cross-correlation')
colorbar
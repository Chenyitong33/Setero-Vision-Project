% 2. Calibration Model
%% Preparation for real location matrices
% Create the X, Y, Z matrices for real locations
X = zeros(17,21,6);
Y = zeros(17,21,6);
Z = zeros(17,21,6);

% X and Y of the real location do not change
X_2000 = zeros(17,21);
Y_2000 = zeros(17,21);
for i = 1:17
	for j = 1:21
        X_2000(i,j) = -500 + (j-1)*50;
	end
end
for k = 1:6
    X(:,:,k) = X_2000;
end
for i = 1:17
    for j = 1:21
        Y_2000(i,j) = 800 - (i-1)*50;
    end
end
for k = 1:6
    Y(:,:,k) = Y_2000;
end

% The Z coordinate of the real location is changing
for i = 1:17
    for j = 1:21
        Z(i,j,1) = 2000;
    end
end
for i = 1:17
    for j = 1:21
        Z(i,j,2) = 1980;
    end
end
for i = 1:17
    for j = 1:21
        Z(i,j,3) = 1960;
    end
end
for i = 1:17
    for j = 1:21
        Z(i,j,4) = 1940;
    end
end
for i = 1:17
    for j = 1:21
        Z(i,j,5) = 1920;
    end
end
for i = 1:17
    for j = 1:21
        Z(i,j,6) = 1900;
    end
end

%% 1st pair of images
% Read the images for Z=2000mm, make them grayscaled and double byte
image1 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','cal_image_left_2000.tiff');
image2 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','cal_image_right_2000.tiff');
[i_left_2000,j_left_2000, i_right_2000, j_right_2000] = myfn(image1, image2);


%% 2nd pair of images
% Read the images for Z=1980mm, make them grayscaled and double byte
image1 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','cal_image_left_1980.tiff');
image2 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','cal_image_right_1980.tiff');
[i_left_1980,j_left_1980, i_right_1980, j_right_1980] = myfn(image1, image2);

%% 3rd pair of images
% Read the images for Z=1960mm, make them grayscaled and double byte
image1 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','cal_image_left_1960.tiff');
image2 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','cal_image_right_1960.tiff');
[i_left_1960,j_left_1960, i_right_1960, j_right_1960] = myfn(image1, image2);

%% 4th pair of images
% Read the images for Z=1940mm, make them grayscaled and double byte
image1 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','cal_image_left_1940.tiff');
image2 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','cal_image_right_1940.tiff');
[i_left_1940,j_left_1940, i_right_1940, j_right_1940] = myfn(image1, image2);

%% 5th pair of images
% Read the images for Z=1920mm, make them grayscaled and double byte
image1 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','cal_image_left_1920.tiff');
image2 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','cal_image_right_1920.tiff');
[i_left_1920,j_left_1920, i_right_1920, j_right_1920] = myfn(image1, image2);

%% 6th pair of images
% Read the images for Z=1900mm, make them grayscaled and double byte
image1 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','cal_image_left_1900.tiff');
image2 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','cal_image_right_1900.tiff');
[i_left_1900,j_left_1900, i_right_1900, j_right_1900] = myfn(image1, image2);

%% Ployfit the calibration model
% prepare for i and j matrices for all pairs of images
i_left = zeros(17,21,6);
j_left = zeros(17,21,6);
i_right = zeros(17,21,6);
j_right = zeros(17,21,6);
% put matrices of different pairs in
i_left(:,:,1) = i_left_2000;
i_left(:,:,2) = i_left_1980;
i_left(:,:,3) = i_left_1960;
i_left(:,:,4) = i_left_1940;
i_left(:,:,5) = i_left_1920;
i_left(:,:,6) = i_left_1900;

j_left(:,:,1) = j_left_2000;
j_left(:,:,2) = j_left_1980;
j_left(:,:,3) = j_left_1960;
j_left(:,:,4) = j_left_1940;
j_left(:,:,5) = j_left_1920;
j_left(:,:,6) = j_left_1900;

i_right(:,:,1) = i_right_2000;
i_right(:,:,2) = i_right_1980;
i_right(:,:,3) = i_right_1960;
i_right(:,:,4) = i_right_1940;
i_right(:,:,5) = i_right_1920;
i_right(:,:,6) = i_right_1900;

j_right(:,:,1) = j_right_2000;
j_right(:,:,2) = j_right_1980;
j_right(:,:,3) = j_right_1960;
j_right(:,:,4) = j_right_1940;
j_right(:,:,5) = j_right_1920;
j_right(:,:,6) = j_right_1900;

il = i_left(:);
jl = j_left(:);
ir = i_right(:);
jr = j_right(:);

% polyfit for X
x_input = [il , jl , ir , jr] ;
depvar_x = X(:);
x_fit = polyfitn(x_input, depvar_x, 3);
sx = polyn2sym(x_fit);

% polyfit for Y
y_input = [il , jl , ir , jr] ;
depvar_y = Y(:);
y_fit = polyfitn(y_input, depvar_y, 3);
sy = polyn2sym(y_fit);

% polyfit for Z
z_input = [il , jl , ir , jr] ;
depvar_z = Z(:);
z_fit = polyfitn(z_input, depvar_z, 3);
sz = polyn2sym(z_fit);

%% test for the pair of Z=2000mm images
%Get the calibration model
X = matlabFunction(sx);
Y = matlabFunction(sy);
Z = matlabFunction(sz);

Xreal_model = X(i_left_2000,j_left_2000,i_right_2000,j_right_2000);
Yreal_model = Y(i_left_2000,j_left_2000,i_right_2000,j_right_2000);
Zreal_model = Z(i_left_2000,j_left_2000,i_right_2000,j_right_2000);

%% function
function [i_left, j_left, i_right, j_right] = myfn(image1, image2)
i_left = zeros(1,17*21);
j_left = zeros(1,17*21);
i_right = zeros(1,17*21);
j_right = zeros(1,17*21);
% For left image
M2 = rgb2gray(imread(image1)); 
% Gaussian template
M1 = [0,5,11,5,0
5,53,117,53,5
11,117,255,117,11
5,53,117,53,5
0,5,11,5,0];

C = normxcorr2(M1, M2);
C(:,size(C,2)-4:size(C,2))=0;%remove edge effect
%--------------------------------------------------------------------------
for i = 1:17*21
    [~,snd] = max(C(:));% get index of the high point in the vector
    [ij,ji] = ind2sub(size(C),snd);% convert the index to coordinates
    % get the x and y coordinates of the template zone
    x1=ij-size(M1,1)+1;
    x2=ij;
    y1=ji-size(M1,2)+1;
    y2=ji;
    j_left(i) = x1+(x2-x1)/2;% put the x coordinate into j_left.
    i_left(i) = y1+(y2-y1)/2;% put the y coordinate into i_left
    C(ij-5:ij+5,ji-5:ji+5) = 0;% make the cross correlation zone of found dot to zero
end
% sort and get the right order of coordinates
% 1-8 columns are in descending order
j_left = sort(j_left,'descend');
j_left = reshape(j_left,[21,17]);
j_left = transpose(j_left);
% 10-17 columns are in ascending order
j_left(10:17,:) = sort(j_left(10:17,:),2);
i_left = sort(i_left);
i_left = reshape(i_left,[17,21]);

%==========================================================================
% For right image
M2 = rgb2gray(imread(image2)); 
% Gaussian template
M1 = [0,5,11,5,0
5,53,117,53,5
11,117,255,117,11
5,53,117,53,5
0,5,11,5,0];

C = normxcorr2(M1, M2);
C(:,size(C,2)-4:size(C,2))=0;%remove edge effect
%--------------------------------------------------------------------------
for i = 1:17*21
    [~,snd] = max(C(:));% get index of the high point in the vector
    [ij,ji] = ind2sub(size(C),snd);% convert the index to coordinates
    % get the x and y coordinates of the template zone
    x1=ij-size(M1,1)+1;
    x2=ij;
    y1=ji-size(M1,2)+1;
    y2=ji;
    j_right(i) = x1+(x2-x1)/2;% put the x coordinate into j_left.
    i_right(i) = y1+(y2-y1)/2;% put the y coordinate into i_left
    C(ij-5:ij+5,ji-5:ji+5) = 0;% make the cross correlation zone of found dot to zero
end
% sort and get the right order of coordinates
% 10-17 columns are in descending order
j_right = sort(j_right,'descend');
j_right = reshape(j_right,[21,17]);
j_right = transpose(j_right);
% 1-8 columns are in ascending order
j_right(1:8,:) = sort(j_right(1:8,:),2);
i_right = sort(i_right);
i_right = reshape(i_right,[17,21]);
end
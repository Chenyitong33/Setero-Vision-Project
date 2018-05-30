% 5. Test Scan on Computer Generated Calibrated Images
% Should first run the part 2 for building the calibration model
tic
% Read in a pair of images
image1 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','test_left_1.tiff');
image2 = fullfile('C:\','Users','frankie','Desktop','COMP90072','assignment2','test_right_1.tiff');
%==========================================================================
% For left image
M2 = rgb2gray(imread(image1)); 
% Gaussian template
M1 = [0,5,11,5,0
5,53,117,53,5
11,117,255,117,11
5,53,117,53,5
0,5,11,5,0];

C = normxcorr2(M1, M2);

i_left_test = zeros(1,9*13);
j_left_test = zeros(1,9*13);
for i = 1:9*13
    [~,snd] = max(C(:));% get index of the high point in the vector
    [ij,ji] = ind2sub(size(C),snd);% convert the index to coordinates
    % get the x and y coordinates of the template zone
    x1=ij-size(M1,1)+1;
    x2=ij;
    y1=ji-size(M1,2)+1;
    y2=ji;
    j_left_test(i) = x1+(x2-x1)/2;% put the x coordinate into i_left.
    i_left_test(i) = y1+(y2-y1)/2;% put the y coordinate into j_left
    C(ij-5:ij+5,ji-5:ji+5) = 0;% make the cross correlation zone of found dot to zero
end
% sort and get the right order of coordinates
% 1-4 columns are in descending order
j_left_test = sort(j_left_test,'descend');
j_left_test = reshape(j_left_test,[13,9]);
j_left_test = transpose(j_left_test);
% 6-9 columns are in ascending order
j_left_test(6:9,:) = sort(j_left_test(6:9,:),2);
i_left_test = sort(i_left_test);
i_left_test = reshape(i_left_test,[9,13]);

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

i_right_test = zeros(1,9*13);
j_right_test = zeros(1,9*13);
for i = 1:9*13
    [~,snd] = max(C(:));% get index of the high point in the vector
    [ij,ji] = ind2sub(size(C),snd);% convert the index to coordinates
    % get the x and y coordinates of the template zone
    x1=ij-size(M1,1)+1;
    x2=ij;
    y1=ji-size(M1,2)+1;
    y2=ji;
    j_right_test(i) = x1+(x2-x1)/2;% put the x coordinate into i_left.
    i_right_test(i) = y1+(y2-y1)/2;% put the y coordinate into j_left
    C(ij-5:ij+5,ji-5:ji+5) = 0;% make the cross correlation zone of found dot to zero
end
% sort and get the right order of coordinates
% 6-9 columns are in descending order
j_right_test = sort(j_right_test,'descend');
j_right_test = reshape(j_right_test,[13,9]);
j_right_test = transpose(j_right_test);
% 1-4 columns are in ascending order
j_right_test(1:4,:) = sort(j_right_test(1:4,:),2);
i_right_test = sort(i_right_test);
i_right_test = reshape(i_right_test,[9,13]);

%% Get the calibration model from part2_2
X = matlabFunction(sx);
Y = matlabFunction(sy);
Z = matlabFunction(sz);

Xreal_model = X(i_left_test,j_left_test,i_right_test,j_right_test);
Yreal_model = Y(i_left_test,j_left_test,i_right_test,j_right_test);
Zreal_model = Z(i_left_test,j_left_test,i_right_test,j_right_test);
%% Plot
dpx = i_left_test - i_right_test;
dpy = j_left_test - j_right_test;
figure
shading interp

subplot(2,1,1)
surf(dpx)
title('dpx')
xlabel('windows x')
ylabel('windows y')
zlabel('difference value')
colorbar

subplot(2,1,2)
surf(dpy)
title('dpy')
xlabel('windows x')
ylabel('windows y')
zlabel('difference value')
colorbar
%==========================================================================
figure;
plot3(Zreal_model,Yreal_model,Xreal_model,'oc')
hold on
shading interp
surf(reshape(Zreal_model,size(Zreal_model)),reshape(Yreal_model,size(Yreal_model)),reshape(Xreal_model,size(Xreal_model)),dpx)
xlabel('z [mm]')
ylabel('y [mm]')
zlabel('x [mm]')
axis equal
z_min = 0;
z_max = 2000;
y_min = 0;
y_max = 800;
x_min = -500;
x_max = 500; 
axis([z_min , z_max , y_min , y_max , x_min , x_max ]);
grid on
colorbar

toc


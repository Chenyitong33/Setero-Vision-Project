COMP90072 The Art of Scientific Computing
Project name: Stereo Vision Project
Lecturer name: Roger Rassool
Tutor name: Kevin Rassool
Student name: Yitong Chen
Student number: 879326


===========================================================
This file contains MATLAB codes with resources to solve a series of tasks.

Notice:

1. All MATLAB files are loading resources at the beginning, the read path 
is "...\COMP90072\..." in my personal computer.

2. Each time running a new file, it is better to empty the workspace and 
close previous figures for releasing the memory.

3. In Part 2, COMP90072\assignment2\normxcorr2.m is a modified code
of the built-in normxcorr2, which annotated checkIfFlat(T) that can solve
the error "The values of template cannot all be the same". However, I think
the most appropriate way to solve the problem is changing parameters of
the tempalte, because we did not understand the built-in function well.
Please delete this file if it is not allowed.

4. Email or contact me with no hesitation if there is problem  in test.


===========================================================
PART 1
-------------------------------- Cross Correlation in 1d --------------------------------
MATLAB code:
COMP90072\assignment1\part1_1.m
--------------------------------- Finding signal offset -----------------------------------
MATLAB code: 
COMP90072\assignment1\part1_2.m

Resources: 
COMP90072\assignment1\sensor1_data_general(1).txt
COMP90072\assignment1\sensor1_data_general(2).txt
------------------------ Normalised Cross Correlation in 2d -------------------------
MATLAB code: 
COMP90072\assignment1\part1_3.m

Resources: 
COMP90072\assignment1\small.jpg
COMP90072\assignment1\apple.png
-------------------------------- Finding the Rocket Man --------------------------------
MATLAB code: 
COMP90072\assignment1\part1_4.m

Resources: 
COMP90072\assignment1\wallypuzzle_rocket_man.png
COMP90072\assignment1\wallypuzzle_png.png
-------------------------------- Correlation using FFT -----------------------------------
MATLAB code: 
COMP90072\assignment1\part1_5.m

Resources: 
COMP90072\assignment1\sensor1_data_general(1).txt
COMP90072\assignment1\sensor1_data_general(2).txt
------------------------------- Pattern finder for music --------------------------------
MATLAB code: 
COMP90072\assignment1\part1_6.m

Resources: 
COMP90072\assignment1\template.wav
COMP90072\assignment1\imperial_march.wav

==========================================================
PART 2
------------------------------ Dot Detection Algorithm -------------------------------
MATLAB code: 
COMP90072\assignment2\part2_1.m
The window size is set to 64 pixel

Resources: 
COMP90072\assignment2\cal_image_left_2000.tiff
COMP90072\assignment2\cal_image_right_2000.tiff
------------------------------ Create Calibration Model -------------------------------
MATLAB code: 
COMP90072\assignment2\part2_2.m

Resources: 
COMP90072\assignment2\cal_image_left_2000.tiff
COMP90072\assignment2\cal_image_right_2000.tiff
COMP90072\assignment2\cal_image_left_1980.tiff
COMP90072\assignment2\cal_image_right_1980.tiff
COMP90072\assignment2\cal_image_left_1960.tiff
COMP90072\assignment2\cal_image_right_1960.tiff
COMP90072\assignment2\cal_image_left_1940.tiff
COMP90072\assignment2\cal_image_right_1940.tiff
COMP90072\assignment2\cal_image_left_1920.tiff
COMP90072\assignment2\cal_image_right_1920.tiff
COMP90072\assignment2\cal_image_left_1900.tiff
COMP90072\assignment2\cal_image_right_1900.tiff
---------------------------------- Image Comparison ----------------------------------
The default window size is 64, with 0% overlap and 3 times search region.

MATLAB code: 
COMP90072\assignment2\part2_3.m

Resources: 
COMP90072\assignment2\left_portal.tiff
COMP90072\assignment2\right_portal.tiff
--------------------------- Image Comparison Optimisation -----------------------
The optimisation include:
1. 50% overlap
2. 5 times search region
3. 2 passes

MATLAB code: 
COMP90072\assignment2\part2_4.m

Resources: 
COMP90072\assignment2\left_portal.tiff
COMP90072\assignment2\right_portal.tiff
-------------- Test Scan on Computer Generated Calibrated Images 1 --------
MATLAB code: 
COMP90072\assignment2\part2_51.m

Resources: 
COMP90072\assignment2\test_left_1.tiff
COMP90072\assignment2\test_right_1.tiff
-------------- Test Scan on Computer Generated Calibrated Images 2 --------
The code for removing spurious vectors is annotated.
The optimisation adatpted here is 5 times search region only.
The different test pairs could be loaded with different path at the beginning.

MATLAB code: 
COMP90072\assignment2\part2_52.m

Resources: 
COMP90072\assignment2\test_left_2.tiff
COMP90072\assignment2\test_right_2.tiff
COMP90072\assignment2\test_left_3.tiff
COMP90072\assignment2\test_right_3.tiff
-------------------------------- Sub-pixel implementation --------------------------
Window size is 6.4

MATLAB code: 
COMP90072\assignment2\sub-pixel.m

Resources: 
COMP90072\assignment2\small_left_portal.png
COMP90072\assignment2\small_right_portal.png
==========================================================
PART 3
-------------Test Scan on Stereo photos taken by phone------------------------
The photos are taken by my SAMSUNG with 3DSteroid app.
The code is identical to COMP90072\assignment2\part2_52.m

MATLAB code: 
COMP90072\assignment2\part3.m

Resources: 
COMP90072\assignment2\bottle_left.tiff
COMP90072\assignment2\bottle_right.tiff

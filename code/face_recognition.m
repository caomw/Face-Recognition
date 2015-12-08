%
%
%
%
%

% Clear workspace
clear all;
clc;

% Include path to the other files
addpath('../data_normalization');
addpath('../files_management');
addpath('../gui');
addpath('../pca');

% Handler for the different files
h_normalization = data_normalization;
h_files = files_management;
h_gui = gui;
h_pca = pca;

% Clean normalization folders
rmdir( '../train_images/_norm/' , 's' );                                        % Not necessary if these folders are eliminated once finished the program
rmdir( '../test_images/_norm/' , 's' );
mkdir( '../train_images/_norm/' );
mkdir( '../test_images/_norm/' );

% Call GUI
h_items = h_gui.createGui( h_files , h_normalization , h_pca );

% Eliminate of the temporal files
%rmdir( '../train_images/_norm/' , 's' );
%rmdir( '../test_images/_norm/' , 's' );

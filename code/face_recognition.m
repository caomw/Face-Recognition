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

% Handler for the different files
h_normalization = data_normalization;
h_files = files_management;
h_gui = gui;

% Call GUI
h_items = h_gui.createGui();

% Normalize
%train_folder = '../all_faces/';     % folder of train_images

%[ data , images ] = h_files.createValidDataStructure( train_folder );
%h_normalization.normalize( data , images );
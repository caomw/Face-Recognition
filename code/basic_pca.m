clear all;
clc;
I = {};
D = [];
path = '../train_images';
N = 64;
M = 64;
p = 54;
k = 33;
A = [];
for i = 1 : p
    baseImageName = sprintf('%d.jpg', i);
    image_name = fullfile(path, baseImageName);
    I{i} = double(rgb2gray(imread(image_name)));
    I{i} = reshape(I{i}', [1, N*M]);
    A = [A;I{i}];
end
mean_X = mean(A,1);% Get mean value of every dimension
D = [];
for i = 1 : p
    D = [D;(A(i,:) - mean_X)];
end

%C =  (D' * D)./(p-1);
%[U,S,V] = svd(C);
%Phi = U(:, 1:k);


C =  (D * D')./(p-1);
[U,S,V] = svd(C);
Phi = D' * U(:, 1:k); % (p-1) is k

%[V,d] = eig(C);
% Phi = D' * V(:,3:p);
%Phi = V;



%Sigma = U;
%Sigma = D' * U;
%eigenface = reshape(Sigma(:,1),[64,64]);


%Phi = Sigma(:, 1:k);

%eigenface = D * Phi; 

F = {};
for i = 1 : p
    F{i} = I{i} * Phi;
    %F{i} = D(i,:) * Phi;
end

%% Test
test_name = fullfile('../test_images','26.jpg');
test_image = double(rgb2gray(imread(test_name)));

X_test = reshape(test_image',[1,N*M]);
%X_test = X_test - mean_X;
F_test = X_test * Phi;

min_e = 10e24; % arrange this as the error of the first image
num = 0;
error =[];
for i = 1 : p
    e = sum((F_test - F{i}).^2);
    error = [error,e];
end
[s, Idx] = sort(error);
First = Idx(1)
Second= Idx(2)
Third = Idx(3)

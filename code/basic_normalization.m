%% Read Images

%!! Eric, I think you can only change this first part, reading all the images and txt in files,
% and then, correspondingly change a little bit about later parts, for
% example: num.
%Now I just read 3 people, you jose and me, and process them together.
%Finally, I save all the mapped images to files mapped_images.


clear all;
clc;
folder = '../all_faces/';
num = 5;% number of images
for i = 1 : num
    baseFileName = sprintf('Songyou_%d.txt', i);
    fullFileName = fullfile(folder, baseFileName);
    fileID = fopen(fullFileName,'r');
    F{i} = fscanf(fileID, '%u');%This is the positions for features in real images, 10*1
    F{i} = reshape(F{i}, [2,5]);% reshape to 2*5
    
    baseImageName = sprintf('Songyou_%d.JPG', i);
    fullImageName = fullfile(folder, baseImageName);
    image{i} = imread(fullImageName);
end

for i = 1 : num
    baseFileName = sprintf('eric_%d.txt', i);
    fullFileName = fullfile(folder, baseFileName);
    fileID = fopen(fullFileName,'r');
    F{i + num} = fscanf(fileID, '%u');%This is the positions for features in real images, 10*1
    F{i + num} = reshape(F{i + num}, [2,5]);% reshape to 2*5
    
    baseImageName = sprintf('eric_%d.JPG', i);
    fullImageName = fullfile(folder, baseImageName);
    image{i + num} = imread(fullImageName);
end

for i = 1 : num
    baseFileName = sprintf('jose_%d.txt', i);
    fullFileName = fullfile(folder, baseFileName);
    fileID = fopen(fullFileName,'r');
    F{i + 2*num} = fscanf(fileID, '%u');%This is the positions for features in real images, 10*1
    F{i + 2*num} = reshape(F{i + 2*num}, [2,5]);% reshape to 2*5
    
    baseImageName = sprintf('jose_%d.JPG', i);
    fullImageName = fullfile(folder, baseImageName);
    image{i + 2*num} = imread(fullImageName);
end

num = 3*num;


%% Compute the first transformation (average locations)
p1 = [13;20];
p2 = [50;20];
p3 = [34;34]; 
p4 = [16;50];
p5 = [48;50];
Fp = [p1,p2,p3,p4,p5];%predetermined locations

% Compute the first average locations, which at first is the first images
b_tmp = reshape(Fp, [10,1]);%store b in Ax = b
A_tmp = [];%store A in Ax = b
for i = 1 : 5 %5 feature points
    % Put all the known variables in A, order is:
    % [x y 1 0 0 0;
    %  0 0 0 x y 1]
    % All five coordinates, so A is a 10*6 matrix
    A_tmp = [A_tmp;F{1}(1,i), F{1}(2,i), 1, 0 ,0 ,0; 0, 0, 0, F{1}(1,i), F{1}(2,i), 1];
end
[U, S, V] = svd(A_tmp);
A_tmp_inv = V * pinv(S) * U';
x = A_tmp_inv * b_tmp;%6 * 1

A1 = [x(1), x(2);x(4), x(5)]; % Get the first A (A in the pdf, not in Ax = b)
b1 = [x(3);x(6)];% Get the first b (b in the pdf, not in Ax = b)

% Get the first transformation
F_average = A1 * F{1} + [b1, b1, b1, b1, b1];%5*2
F_average = reshape(F_average, [10,1]);


%% Compute the best transformation for all faces

% Use SVD to get pseudo inverse A (A in Ax = b) for all faces, so we only compute
% once.
A_tmp_inv_all = [A_tmp_inv];% First include first image that we just calculate
for i = 2 : num % all the images except the first one
    A_tmp = [];
    for j = 1 : 5
        A_tmp = [A_tmp;F{i}(1,j), F{i}(2,j), 1, 0 ,0 ,0; 0, 0, 0, F{i}(1,j), F{i}(2,j), 1];
        
    end
    [U, S, V] = svd(A_tmp);
    A_tmp_inv = V * pinv(S) * U';
    A_tmp_inv_all = [A_tmp_inv_all; A_tmp_inv]; %Finally should be (5*6)*10
end

A{1} = A1;
b{1} = b1;

itr = 0;
dif = 1000.0;%threshold, which should be changed according to the number of images
while (dif > 10)
    F_all = [];% For keeping four transformation, in order to compute the mean value
    F_last = F_average;
    for i = 1 : num 
        % We will not include first image used for computing initial F_average
        if itr == 0 && i == 1 
            continue;
        else
        x = A_tmp_inv_all((6*i-5):6*i,:) * F_average;
        A{i} = [x(1), x(2);x(4), x(5)];
        b{i} = [x(3);x(6)];
        % store the best transformation for this face
        F_tmp = A{i} * F{i} + [b{i}, b{i}, b{i}, b{i}, b{i}];%5*2
        F_tmp = reshape(F_tmp, [10,1]); %reshape to 10*1
        
        F_all = [F_all, F_tmp];% finally this one will be 10*4
        end
    end
    F_average = mean(F_all, 2);%update F_average, Step 4
    dif = sum(abs(F_last - F_average));
    itr = itr + 1;
end

%Final average transformation.
display(F_average);

%% Yield affine transformation that maps the face to the 64*64 window
%image = imread('../all_faces/eric_3.JPG');
%t = 3 + 10;
% new = zeros(64,64,3);
% for i = 1 : 240
%     for j = 1 : 320
%         f = A{t - 1} * [j;i] + b;
%         if f(1) <= 1 || f(2) <= 1 || f(1) > size(image,2) || f(2) >
%         size(image,1)
%             continue;
%         else
%             f(1) = round(f(1));
%             f(2) = round(f(2));
%             new(f(2), f(1), 1) = image(i, j, 1);
%             new(f(2), f(1), 2) = image(i, j, 2);
%             new(f(2), f(1), 3) = image(i, j, 3);
%         end
%     end
% end
% imshow(uint8(new));%show mapped 64*64 image

% Compute the inverse transformation

mapped_path = '../mapped_images/';
for k = 1 : num
    
    new = zeros(64,64,3);
    for i = 1 : 64
        for j = 1 : 64
            f = A{k} \ ([i;j] - b{k});% inverse version
            if f(1) <= 1 || f(2) <= 1 || f(1) > size(image{k},2) || f(2) > size(image{k},1)
                continue;
            else
                f(1) = floor(f(1));
                f(2) = floor(f(2));
                new(j, i, 1) = image{k}(f(2), f(1), 1);
                new(j, i, 2) = image{k}(f(2), f(1), 2);
                new(j, i, 3) = image{k}(f(2), f(1), 3);
            end
        end
    end
    base = sprintf('%d.jpg', k);
    imwrite(uint8(new), fullfile(mapped_path, base));   
end


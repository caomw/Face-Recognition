clear all;
clc;
folder = '../all_faces/';
for i = 1 : 5
    baseFileName = sprintf('eric_%d.txt', i);
    fullFileName = fullfile(folder, baseFileName);
    fileID = fopen(fullFileName,'r');
    F{i} = fscanf(fileID, '%u');%This is the positions for features in real images, 10*1
    F{i} = reshape(F{i}, [2,5]);% reshape to 2*5
end
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
for i = 1 : 5
    % Put all the known variables in A, order is:
    % [x y 1 0 0 0;
    %  0 0 0 x y 1]
    % All five coordinates, so A is a 10*6 matrix
    A_tmp = [A_tmp;F{1}(1,i), F{1}(2,i), 1, 0 ,0 ,0; 0, 0, 0, F{1}(1,i), F{1}(2,i), 1];
end
[U, S, V] = svd(A_tmp);
A_tmp_inv = V * pinv(S) * U';
x = A_tmp_inv * b_tmp;%6 * 1

A1 = [x(1), x(2);x(4), x(5)];
b1 = [x(3);x(6)];

% Get the first transformation
F_average = [];
for i = 1 : 5
    F_average = [F_average; A1 * F{1}(:,i) + b1];%10*1
end 

%% Compute the best transformation for other faces

A_tmp_inv_all = [];%keep all the pseudo inverse A in Ax = b in every face
for i = 2 : 5 % rest four images for each person, this loop computes and keeps all the A_tmp
    A_tmp = [];
    for j = 1 : 5
        A_tmp = [A_tmp;F{i}(1,j), F{i}(2,j), 1, 0 ,0 ,0; 0, 0, 0, F{i}(1,j), F{i}(2,j), 1];
        
    end
    [U, S, V] = svd(A_tmp);
    A_tmp_inv = V * pinv(S) * U';
    A_tmp_inv_all = [A_tmp_inv_all; A_tmp_inv]; %Finally should be (4*6)*10
end

for i = 1 : 4
    A{i} = zeros(2,2);
    b{i} = zeros(2,1);
end

itr = 0;
dif = 1000.0;
while (dif > 10)
    F_all = [];% For keeping four transformation, in order to compute the mean value
    F_last = F_average;
    for i = 1 : 4
        x = A_tmp_inv_all((6*i-5):6*i,:) * F_average;
        A{i} = [x(1), x(2);x(4), x(5)];
        b{i} = [x(3);x(6)];
        % store the best transformation for this face
        F_tmp = A{i} * F{i + 1} + [b{i}, b{i}, b{i}, b{i}, b{i}];%5*2
        F_tmp = reshape(F_tmp, [10,1]); %reshape to 10*1
        
        F_all = [F_all, F_tmp];% finally this one will be 10*4
    end
    F_average = mean(F_all, 2);%update F_average, Step 4
    dif = sum(abs(F_last - F_average));
    itr = itr + 1;
end

%Final transformation.
F_average

%% Yield affine transformation that maps the face to the 64*64 window
image = imread('../all_faces/eric_2.JPG');
t = 2;
% new = zeros(64,64,3);
% for i = 1 : 240
%     for j = 1 : 320
%         f = A{t - 1} * [j;i] + b;
%         if f(1) <= 1 || f(2) <= 1 || f(1) > 64 || f(2) > 64
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

new = zeros(64,64,3);

for i = 1 : 64
    for j = 1 : 64
        f = inv(A{t - 1}) * ([i;j] - b{t - 1});
        if f(1) <= 1 || f(2) <= 1 || f(1) > size(image,2) || f(2) > size(image,1)
            continue;
        else
            f(1) = floor(f(1));
            f(2) = floor(f(2));
            new(j, i, 1) = image(f(2), f(1), 1);
            new(j, i, 2) = image(f(2), f(1), 2);
            new(j, i, 3) = image(f(2), f(1), 3);
        end
    end
end
imshow(uint8(new));%show mapped 64*64 image

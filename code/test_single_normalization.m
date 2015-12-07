clear all;
clc;
image = imread('../all_faces/Songyou_5.jpg');
fileID = fopen('../all_faces/Songyou_5.txt','r');
F = fscanf(fileID, '%u');%This is the positions for features in real images, 10*1
F = reshape(F, [2,5]);% reshape to 2*5

p1 = [13;20];
p2 = [50;20];
p3 = [34;34]; 
p4 = [16;50];
p5 = [48;50];
Fp = [p1,p2,p3,p4,p5];%predetermined locations


% Use SVD to get pseudo inverse A (A in Ax = b)
A_tmp = [];
for j = 1 : 5
    A_tmp = [A_tmp;F(1,j), F(2,j), 1, 0 ,0 ,0; 0, 0, 0, F(1,j), F(2,j), 1];       
end
[U, S, V] = svd(A_tmp);
A_tmp_inv = V * pinv(S) * U';

F_average = reshape(Fp, [10,1]);%store b in Ax = b
x = A_tmp_inv * F_average;%6 * 1        
A1 = [x(1), x(2);x(4), x(5)]; 
b1 = [x(3);x(6)];

F_average = A1 * F + [b1, b1, b1, b1, b1];%5*2
F_average = reshape(F_average, [10,1]);

display(F_average);

%% Map image
new = zeros(64,64,3);
    for i = 1 : 64
        for j = 1 : 64
            f = A1 \ ([i;j] - b1);% inverse version
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
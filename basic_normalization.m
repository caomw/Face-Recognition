clear('A');
folder = './all_faces';
for i = 1 : 5
    baseFileName = sprintf('Songyou_%d.txt', i);
    fullFileName = fullfile(folder, baseFileName);
    fileID = fopen(fullFileName,'r');
    F{i} = fscanf(fileID, '%u');%This is the positions for features in real images, 10*1
    F{i} = reshape(F{i}, [2,5]);% reshape to 2*5
end

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
x = A_tmp_inv * b_tmp;

A = [x(1), x(2);x(4), x(5)];
b = [x(3);x(6)];

% test
A * F{1}(:,1) + b
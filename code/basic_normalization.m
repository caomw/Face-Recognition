clear('A');
folder = './all_faces';
for i = 1 : 5
    baseFileName = sprintf('Songyou_%d.txt', i);
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
x = A_tmp_inv * b_tmp;

A = [x(1), x(2);x(4), x(5)];
b = [x(3);x(6)];

% Get the first transformation
F_average = [];
for i = 1 : 5
    F_average = [F_average; A * F{1}(:,i) + b];%10*1
end 

%% Compute the best transformation for other faces
itr = 0;

A_tmp_inv_all = [];%keep all the pseudo inverse A in Ax = b in every face
for i = 2 : 5 % rest four images for each person
    A_tmp = [];
    for j = 1 : 5
        A_tmp = [A_tmp;F{i}(1,j), F{i}(2,j), 1, 0 ,0 ,0; 0, 0, 0, F{i}(1,j), F{i}(2,j), 1];
        
    end
    [U, S, V] = svd(A_tmp);
    A_tmp_inv = V * pinv(S) * U';
    A_tmp_inv_all = [A_tmp_inv_all; A_tmp_inv]; %Finally should be (4*6)*10
end

while (itr < 7)
    F_all = [];% For keeping four transformation, in order to compute the mean value
    for i = 1 : 4
        x = A_tmp_inv_all((6*i-5):6*i,:) * F_average;
    
        A = [x(1), x(2);x(4), x(5)];
        b = [x(3);x(6)];
        
        % store the best transformation for this face
        F_tmp = [];
        for j = 1 : 5
            F_tmp = [F_tmp; A * F{i + 1}(:,j) + b];%10*1
        end 
        F_all = [F_all, F_tmp];
    end
    F_average = mean(F_all, 2);%update F_average
    itr = itr + 1;
end

%Final transformation.
F_average

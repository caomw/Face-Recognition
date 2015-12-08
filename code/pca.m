function p = pca()
    p.execute = @execute;
end

function list = execute( path , test_name )

    I = {};
    D = [];
    
    N = 64;
    M = 64;

    k = 33;
    A = [];
    
    files = dir( cat( 2, path , '*.jpg' ) );
    files = {files.name};
    number_pictures = size( files , 2 );
    
    for i = 1 : number_pictures                            
        baseImageName = files{i};                      
        image_name = fullfile(path, baseImageName);
        I{i} = double(rgb2gray(imread(image_name)));
        I{i} = reshape(I{i}', [1, N*M]);
        A = [A;I{i}];
    end
    
    %{
    
     files = dir( cat( 2, path , '*.JPG' ) );
    files = {files.name};
    size(files,2)
    
    x = 1;
    for i = (size(a,2)+1) : (size(a,2)+size(files,2))
        x
        baseImageName = files(x);
        %baseImageName = sprintf('%d.jpg', i);
        image_name = fullfile(path, baseImageName);
        I{x} = double(rgb2gray(imread(image_name)));
        I{x} = reshape(I{x}', [1, N*M]);
        A = [A;I{x}];
        x = x+1;
    end
    %}
    
    
    
    
    mean_X = mean(A,1);% Get mean value of every dimension
    D = [];
    for i = 1 : number_pictures
        D = [D;(A(i,:) - mean_X)];
    end

    %C =  (D' * D)./(p-1);
    %[U,S,V] = svd(C);
    %Phi = U(:, 1:k);


    C =  (D * D')./(number_pictures-1);
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
    for i = 1 : number_pictures
        F{i} = I{i} * Phi;
        %F{i} = D(i,:) * Phi;
    end

    
    
    
    %% Test
    
    test_image = double(rgb2gray(imread(test_name)));
    X_test = reshape(test_image',[1,N*M]);
    %X_test = X_test - mean_X;
    F_test = X_test * Phi;

    min_e = 10e24; % arrange this as the error of the first image
    num = 0;
    error =[];
    for i = 1 : number_pictures
        e = sum((F_test - F{i}).^2);
        error = [error,e];
    end
    
    % Compute and return sorted structure of names
    list = {};
    [~ , Idx] = sort( error );
    for i = 1:1:size( Idx , 2)
        list{ i , 1 } = i;
        tmp = files{ Idx(i) };
        list{ i , 2 } = tmp( 1 : size( tmp , 2 ) - 6 );                                        % This string should be truncated
        list{ i , 3 } = 'm / f';
        list{ i , 4 } = files{ Idx(i) };
    end   
end

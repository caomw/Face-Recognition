function g = gui()
    g.createGui = @createGui;
end

function handles = createGui()

    % Set the figure (origin at top-left corner)
    hFig = figure( 'NumberTitle' , 'off' , 'Name' , 'Face Recognition' , 'Position' , [500 , 300 , 710 , 450 ] , 'Resize' , 'off' , 'MenuBar' , 'none' );

    % Set the description
    description_text = sprintf(' \n  Usage of the software:\n\n    1) ''Browse database'' and ''Process database''\n    2) ''Browse picture'' and ''Identify Person''\n\n  The bottom-right table will list the results of the computation.\n  A gender filter can be applied by selecting the ''Male'' and/or\n  ''Female'' button ');
    description = uicontrol( 'Style' , 'text' , 'String' , description_text , 'HorizontalAlignment' , 'left' , 'Enable' , 'inactive' , 'Position' , [390 315 289 105] );
    
    % Set the train group
    train_group = uipanel( hFig , 'Units' , 'pixels' , 'Position', [30 315 330 105] );
    train_browser = uicontrol( 'Style' , 'pushbutton' , 'String' , 'Browse database' , 'Tag' , 'train_browse' , 'Units' , 'pixels' , 'Position' , [45 370 120 30] , 'Callback' , @train_browse );
    train_execute = uicontrol( 'Style' , 'pushbutton' , 'String' , 'Process database' , 'Tag' , 'train_execute' , 'Units' , 'pixels' , 'Position' , [225 370 120 30] );
    train_text = uicontrol( 'Style' , 'edit' , 'String' , 'Database path...' , 'Enable' , 'inactive' , 'Position' , [45 330 300 30] );
    
    % Set the pca buttons
    pca_group = uipanel( hFig , 'Units' , 'pixels' , 'Position', [30 195 330 105] );
    pca_browser = uicontrol( 'Style' , 'pushbutton' , 'String' , 'Browse picture' , 'Tag' , 'pca_browse' , 'Units' , 'pixels' , 'Position' , [45 250 120 30] , 'Callback' , @pca_browse );
    pca_execute = uicontrol( 'Style' , 'pushbutton' , 'String' , 'Identify person' , 'Tag' , 'pca' , 'Units' , 'pixels' , 'Position' , [45 210 120 30] );
    pca_male = uicontrol( 'Style' , 'radiobutton' , 'String' , 'Male', 'Value' , 1 , 'Position' , [240 251 120 30] );
    pca_female = uicontrol( 'Style' , 'radiobutton' , 'String' , 'Female', 'Value' , 1 , 'Position' , [240 211 120 30] );
    
    % Set the searched image area
    %im_search = imread( '/Users/ericpairet/Others/VIBOT/1st_semester/Applied mathematics/Homework 3/Face-Recognition/mapped_images/55.jpg' );
    %ax_search = axes( 'Units' , 'pixels' , 'Position' , [30 30 150 150] , 'Parent', hFig );
    %ha_search = imshow( im_search , 'Parent' , ax_search );
    
    % Set the found image area
    %im_found = imread( '/Users/ericpairet/Others/VIBOT/1st_semester/Applied mathematics/Homework 3/Face-Recognition/mapped_images/54.jpg' );
    %ax_found = axes( 'Units' , 'pixels' , 'Position' , [210 30 150 150] , 'Parent', hFig );
    %ha_found = imshow( im_found , 'Parent' , ax_found );
    
    % Set the table
    table = uitable( 'Data' , zeros(20,3) , 'ColumnWidth', {50} , 'RowName' , [] , 'ColumnWidth', {60 , 150 , 60} , 'ColumnName' , {'Ranking','Name','Gender'} , 'ColumnEditable' , [false false false] , 'Position' , [390 30 289 270] );
    
    % Save the items' handles
    handles = struct( 'hFig' , hFig , ...
                      'description' , description , ...
                      'train_group' , train_group , ...
                      'train_browse' , train_browser , ...
                      'train_execute' , train_execute , ...
                      'train_text' , train_text , ...
                      'pca_group' , pca_group , ...
                      'pca_browse' , pca_browser , ...
                      'pca_execute' , pca_execute , ...
                      'pca_male' , pca_male , ...
                      'pca_female' , pca_female , ...
                      'table' , table );
end

function train_browse( source , eventData )
    [FileName , PathName , FilterIndex] = uigetfile; 
    %Write restrictions!
    
    % save info somehow
end

function pca_browse( source , eventData )
    [FileName , PathName , FilterIndex] = uigetfile; 
    %Write restrictions!
    
    % save info somehow
end
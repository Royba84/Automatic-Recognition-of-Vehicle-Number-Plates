%some ease of use management commands:
clc;
close all;
clear;
load imgfildata;

%Get the file path in an interactive way
% [file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif','*.jpeg'},'Choose an image');
[file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif';'*.jpeg'},'Choose an image');

s=[path,file];
picture=imread(s);

%bwareaopen -the method uses every colomn as one unit
%to process the image. therfore we need to find how many columns we have in
%the image. the function - size -in the next syntax returns a value of:        
%[~ , (numCols * numberColors)] = size()
[~,cc]=size(picture);


%Resize the image to 300X500
picture=imresize(picture,[300 500]);

%3 means 3 color dimensions , meaning it is in RGB, converted to grayscale
if size(picture,3)==3
  picture=rgb2gray(picture);
end

%        were in comments in the first place - delete it if needed
%------------------------------------------------------------------
% se=strel('rectangle',[5,5]);
% a=imerode(picture,se);
% figure,imshow(a);
% b=imdilate(a,se);
%-------------------------------------------------------------------

%Find the treshold of the greyscale image
threshold = graythresh(picture);

%Convert the image to BW , according to the treshold we calculated before.
picture = imbinarize(picture,threshold);
figure; imshow(picture);
picture =~ picture;
figure; imshow(picture);


%removes all connected components (objects) that have fewer than 30 pixels
%from the binary image picture. 30 connectes pixels as 1 unit for all
%directions (there is no half letter/half number).
picture = bwareaopen(picture,30);
figure; imshow(picture);

if cc>2000
    picture1=bwareaopen(picture,3500);
else
    picture1=bwareaopen(picture,3000);
end

% Presenting the image without the number plate characters&numbers
figure,imshow(picture1)
% Substracting the images provides us a relatively clean image consisting
% the number plate characters&numbers with small noises
picture2=picture-picture1;
figure,imshow(picture2)

% Here we are presenting the number plates characters&numbers -only-



picture2=bwareaopen(picture2,200);
figure,imshow(picture2)

% L gives a matrix in which there is information of the number plate
% and Ne gives us the number of digits/characters in the number plate
% https://www.mathworks.com/help/images/ref/bwlabel.html
[L,Ne]=bwlabel(picture2);

%https://www.mathworks.com/help/images/ref/regionprops.html?s_tid=doc_ta#d123e240373
%Takes the matrix L and perform 'boundingbox' principle on it
%propied(i).boundingbox: returns a vector [ left top horizontal vertical ]
%for example, for propied(1) we got:    91.5000  133.5000   32.0000   39.0000
%disp(propied(1).BoundingBox);
propied=regionprops(L,'BoundingBox');
hold on

% Here we run all over the boundingboxes and mark them in our image
% this will result a rectangle around characters/numbers in the number plate
for n=1:size(propied,1)
  rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
end
hold off

final_output=[];

% Here we show each character/number from our number plate as a seperate
% image 
for n=1:Ne
    % We saw that L gives us matrix with regions (each region has its own
    % index), we find in each iteration the relevant region using that index.
    % Then, we  got the respective r,c = rows and coloms
    % For Each pixel in the region
    [r,c] = find(L==n);
    n1=picture(min(r):max(r),min(c):max(c));
    % We resize to our templates of characters/numbers dimensions
    n1=imresize(n1,[42,24]);
    figure;
    imshow(n1);
    x=[ ];

    % We store here the number of strings
    totalLetters=size(imgfile,2);

    %Check for correlation between the detected letters
    for k=1:totalLetters

        y=corr2(imgfile{1,k},n1);
        % x will be a vector which contains the correlation coefficient 
        % for each template in the directory
        x=[x y];

    end

    % We recognized the current digit/character if there is a template in
    % the directory which has a correlation coefficient bigger than 0.45.
    % The true template has the maximal correlation coefficient.
    if max(x)>0.45
        
        CorrelationIndex=find(x==max(x));
        % Out is the string of the template 
        out=cell2mat(imgfile(2,CorrelationIndex));
        % Final output is basically a vector of strings of the characters
        % in the number plate
%         disp(out);
        out = regexp(out,'\w','Match');
        final_output=[final_output string(out)];
    end
end


file = fopen('number_Plate.txt', 'wt');
    fprintf(file,'%s',final_output);
    fclose(file);
    % Here we tell Microsoft Windows to open to .txt file we've just
    % created
    winopen('number_Plate.txt')

clc;           
clear;        
close all;

%Storing the directory consisting our templates to the variable di
di=dir('dudi bmp');

% Creating cellarray which every 
% element is the name of character template as a string.
st={di.name}; 

% In places 1,2 in st, there are the strings: '.','..' 
% which we want to ignore
names=st(3:end);
% Creates cell array named imgfile. Inside it we will store all the
% characters templates. Each element will be a single template.

imgfile=cell(2,length(names));

% Run over all the templates in the directory and store them in imgfile :-)
for i=1:length(names)
   %Full name=letters_numbers+names(i), chaining 
   im=imread(['dudi bmp','\',cell2mat(names(i))]);
  
   temp=cell2mat(names(i));
   im = im2gray(im);
   figure; imshow(im);
   BW=imbinarize(im);
   figure;imshow(BW);
   BW =~(BW);
   figure; imshow(BW);
   imwrite(BW,['letters_numbers' , '\'  ,temp]);
end


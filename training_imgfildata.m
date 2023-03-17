clc;           
clear;        
close all;

%Storing the directory consisting our templates to the variable di
di=dir('letters_numbers');

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
   imgfile(1,i)={imread(['letters_numbers','\',cell2mat(names(i))])};
   % imgfile(1,i) - in index i, saves the image in the first row as a
   % cellarray because each element in a cellarray is a cellarray
   temp=cell2mat(names(i));
   % In the index i, in the second row saves the string - name of the
   % template
   imgfile(2,i)={temp(1)};
end
save('imgfildata.mat','imgfile');
clear;
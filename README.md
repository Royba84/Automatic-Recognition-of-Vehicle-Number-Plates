Automatic Recognition of Vehicle Number Plates
Background:
 In many places today, we are required to recognize license plates of various vehicles for a variety of reasons.
For example, automatic recognition of license plates in parking lots may help in a variety of ways. For example, instead of placing a guard at the entrance to the parking lot, it is possible to place cameras at the entrance and exit, so that the cameras will scan the vehicle number in order to automatically calculate the parking time to be paid.
Additional cases in which it may be necessary to identify license plates:
•Amount of vehicles that are on road (to regulate loads)
•Monitoring of public servants and so on.

image.png
The Challenge:
As mentioned, we are interested in identifying vehicle license plates. In different parts of the world, there are different standards of license plates: the size of the plate, the size and font type of the characters, the type of characters (letters and numbers, only letters/only numbers) as shown in the examples below:

image.png

DoD:
 • Implement an algorithm that identifies vehicle license numbers from color and grayscale images.
• Show successful performance of the algorithm on at least 7 images.
• Show partially working/failed performance of the algorithm on at least 7 images.
• explain the results obtained and draw conclusions.
Solution Method:

image.png
Preliminary requirements to implement the algorithm:
• A computer (PC/Mac) with MATLAB software installed.
• Image Processing Toolbox.
• A camera (for capturing license plates)
Step 1: Characters and numbers template creation
 1.First, find a license plate (2 or more are suggested) from the same kind, for example:

image.png


image.png

2.Extract from each license plate each letter/character in separate.
3.Save the extracted images into dedicated folder, make sure the dimensions are unified and the format of the images is .BMP.
4.Perform the following processing:
Original - bmp 
image.png
Im2gray

image.png
Imbinarize (before ~)

image.png
~Imbinarize

image.png

5.Save the template (“temp”): 

image.png

So far, we made it this far:

image.png
Step 2: User choose an image

image.png

image.png
Step 3: Processing
Step 3.1
 First, the image dimensions changed to 300x500, afterwards the image is converted to grayscale as shown below:

image.png

image.png

image.png
Step 3.2:
Now, let us find the threshold level using ‘graythresh’ function, the threshold level varies between [0,1]. After that, let us use the threshold level we’ve just found in order the transform our image to BW and then inverse it using ‘~’.

image.png

image.png

image.png
Step 3.3


image.png

image.png

image.png

image.png

Step 3.4

image.png

image.png
First, I cleaned all the noises from the image. After that, I used the function ‘bwlabel’, which gives in return two parameters:
L (Label matrix) – A matrix in which each white area will be presented by separated unit with unique characteristic index. Meaning, The pixels labeled 0 are the background. The pixels labeled 1 make up one object; the pixels labeled 2 make up a second object; and so on.
Ne – represents the number of connected objects (numbers/characters).
Then, I used the function ‘regionprops’ which gives in return a vector of ‘boundingboxes’ in the following configuration: [left top horizontal vertical] for each boundingbox.
Last, I drew using ‘rectangle’ function (in green) the boundingboxes on the spots I found.
Step 3.5

image.png
Final_output=[] is the vector that eventually hold the final result.
We’ll iterate inside the loop from 1 to the number of connected objects (Ne) which we’ve calculated in the last step.
Take each pixel that is included inside the boundingbox only and change it’s size to the size of the template we’ve created in the beginning of the algorithm.
Then we’ll save the number of templates inside the variable – ‘totalLetters’.
Note: variable ‘x’ which we’ve made is a vector and he will store the correlation levels between the detected object in each boundingbox to our pre-made templates.

Step 4:
 
image.png
In the loop we’ll check all of our pre-made templates and look for in each iteration what is the correlation between the current boundingbox to the templates.
I decided that detection of a character/number will be from correlation of at least 0.45.
The detected character will be the one with the highest correlation level to a certain pre-made template.
We’ll store the detected character in the variable ‘Final_output’.
For example, if I would like to detect the number ‘0’:

image.png

image.png
The character will be identified as ‘0’ because 0.96>0.88
Step 5 & 6: saving the results and exporting it to .txt
 
image.png


image.png

image.png

Some successful results
 
image.png

image.png

Less Successful results
 
image.png

image.png
Discussion and conclusions
 When did the algorithm perform well?
•When the license plate was spreaded all across the image.
•When the pre-made template were similar to those in the image.
•When the license plate was captured straight with no bias or tilt.
When did the algorithm performed worse?
•When the capture of the image made with bias which caused mismatch to the templates due distortions.
•When the license plate took small part from the whole image.
•When the license plate characters had different font from the pre-made templates.

How this algorithm can be improved?
 •Creating larger pre-made templates with variety of fonts.
•In cases which the license plate took small part from the whole image, an algorithm of image isolation can be used, and only after that to perform the recognition algorithm - as shown below:

image.png
•And lastly, making more tough noise filtering.

Full algorithm and images can be found in my Github account - royba84

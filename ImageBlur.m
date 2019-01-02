function varargout = ImageBlur(varargin)
% IMAGEBLUR MATLAB code for ImageBlur.fig
%      IMAGEBLUR, by itself, creates a new IMAGEBLUR or raises the existing
%      singleton*.
%
%      H = IMAGEBLUR returns the handle to a new IMAGEBLUR or the handle to
%      the existing singleton*.
%
%      IMAGEBLUR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEBLUR.M with the given input arguments.
%
%      IMAGEBLUR('Property','Value',...) creates a new IMAGEBLUR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageBlur_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageBlur_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageBlur

% Last Modified by GUIDE v2.5 11-Dec-2018 18:54:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageBlur_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageBlur_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Executes just before ImageBlur is made visible.
function ImageBlur_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageBlur (see VARARGIN)

% Choose default command line output for ImageBlur
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImageBlur wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = ImageBlur_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[baseName, folder] = uigetfile;%Change file filter to all file types.
%fullfileName = fullfile(folder, baseName)%This code allows the user to select an image from their computer by pushing hte select a picture button on the GUI. 
%image = imread(fullfileName);%Converts the file into a readable matrix so matlab can process the image a create an array of values from 0 to 255 that will display the image and allows us to alter the image by editing the values in the matrix.
%bimage=image;% this assigns the original image to another varibale so that we can maintain the values of the original image and creat a second image that is changed to  blurred image while mantaining the original.
[filename,filepath] = uigetfile({'*.*';'*.jpg';'*.png';'*.bmp'},'Search Image To Be Displayed');
fullname = fullfile(filepath,filename);
ImageFile = imread(fullname);
imagesc(ImageFile);
axis off
setGlobalImage(ImageFile)
%imshow(ImageFile, handles.originalimage);%Displays the original image on the left set of axes.
end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sliderVal = get(hObject,'Value');
set(hObject, 'Max', 100, 'Min', -2);
sliderVal = round(sliderVal);
image2Use = getGlobalImage;
blurredImage = adjustBlur(image2Use,sliderVal); %Calls function I created
imshow(blurredImage,'parent',handles.blurredimage);%Displays the blurred image on the right set of axes.
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

% --- Executes during object creation, after setting all properties.
function originalimage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to originalimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate originalimage
end
function output = adjustBlur(ImageFile,sliderVal)       %This function takes the image from the computer and allows it to blur                                        % Need to implement GUI so that the user can manually adjust the amount of blur.                           % Sets the blur level   
    THEIMAGE = ImageFile;     %Imports image into MATLAB
    [x,y,z] = size(THEIMAGE);      % Finds the dimensions of the image   
    output = zeros(size(THEIMAGE),class(THEIMAGE));         % Creates a 3D matrix of zeros matching the size of the input image
    
    
    blurValue = sliderVal;                   %Determines how much blur by considering how many neighbors to average the current pixel from. 
    if mod(blurValue,2) ~= 0         % Converts blur into an even value
        blurValue = blurValue + 1;
    else
        blurValue = blurValue;
    end
    
    borderLength = 2 + blurValue;                 % 2 creates 1 border. 4 creates 2 extra borders. 6 creates 3 extra borders.
    n = borderLength / 2;                         % Just some math to determine the starting index value. 
    start = 1 + n;                                %Creates starting index for the mean counting function
    
    stop = borderLength/2;                        %Creates a stop value for the index for the zeroRing function
    zeroBorderMatrix = zeroRing(THEIMAGE,start,stop,borderLength);   %Creates a ring of zero around matrix
    
    %Initiates the meanOfNeighbors Function
        for f = 1:z                          %Starting and ending coordinate within the Ringed Matrix (dimension/color)
            for q = start:(x+stop)           %Starting and ending coordinate within the Ringed Matrix (rows)
                for r = start:(y+stop)       %Starting and ending coordinate within the Ringed Matrix (columns)
                    mean = meanOfNeighbors(zeroBorderMatrix,q,r,f,borderLength,n);   %Calls a function I created to find the mean of it self and neighbors.            
                    output(q-stop,r-stop,f) = mean ;         %Stores the value of the neighboring mean in output matrix.     
                end
            end
        end 
        %imshow(output,handles.blurredimage)
end

%THIS FUNCTION IS COMPLETE AND GUCCI
function ringedMatrix = zeroRing(mat,start,stop,borderLength)   %This function gives us a border around our original function.
[x,y,z] = size(mat);                      %This line gives us the dimenions of the original matrix.  
for i = 1:z
    ringedMatrix = zeros(x+borderLength,y+borderLength,i);  %This line creates a matrix of zeros with x amount of borders (min 1).
end
for j = 1:z
    ringedMatrix(start:x+stop,start:y+stop,j) = mat(:,:,j);        %This line takes our original matrix and centers it into the new matrix. 
end 

end


function mean = meanOfNeighbors(zeroBorderMatrix,u,c,f,borderLength,n)     %This function finds the mean of neighbors. 
    count = 0;                                        %Total values of neighbots
    for a = u-n:u+n                               %This nested loop will count the values of the 8 surrounding cells including the target/center cell
        for b = c-n:c+n
            neighborValue = zeroBorderMatrix(a,b,f);             %Uses the coordinates in the for loop to count its neighbors. 
            count = count + neighborValue;                     %Counts the total alive neighbors
            
        end
    end                     
    mean = count / (borderLength + 1)^2;        % Determines how many neighbors it counted based off borderLength
                           
end 

function setGlobalImage(input)
global Image
Image = input;
end
function image2Use = getGlobalImage
global Image 
image2Use = Image;
end
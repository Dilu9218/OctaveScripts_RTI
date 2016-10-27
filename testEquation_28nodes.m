%#!/usr/bin/octave -qf

pkg load communications
pkg load statistics

% dimentions of the terrain
width=8;
height=8;

% N is the number of voxels in the image
N = width * height;

% W is the weight matrix which will get populated on the go
W=[];

% coordinates of the wireless nodes square 
coords=[1,1;2,1;3,1;4,1;5,1;6,1;7,1;8,1;
    	1,2;1,3;1,4;1,5;1,6;1,7;1,8;
	2,8;3,8;4,8;5,8;6,8;7,8;8,8;
	8,2;8,3;8,4;8,5;8,6;8,7;   	
];
% number of nodes
num_nodes=length(coords)
disp("num_nodes")
disp(num_nodes)

% number of links (this will get updated shortly)
num_links=0;

% link matrix (this will get updated shortly)
links=[];

%to store pixels
linkPixel=[];

%to store pixels
XdistMat=[];
YdistMat=[];

X = zeros(width, height);

%initialize count
count=1;


% generating weight matrix
for i=1:length(coords)
%Dilushi testing for ALL possible links including repeating links
	for j=1:length(coords)
		num_links=num_links+1;
    		%disp(num_links);
		% start and end point of line
		a=[coords(i,1), coords(i,2)];
		b=[coords(j,1), coords(j,2)];
		ab=[coords(i,1), coords(j,1);coords(i,2),coords(j,2)];
		% add the link to the links matrix for future use
		links=[links;a,b];
		%calculate euclidean link distance
		dlink=sqrt((coords(i,1)-coords(j,1))^2 +(coords(i,2)-coords(j,2))^2);
		%k and l represents all voxels
		for k=1:width
			for l=1:height
			currentPixel= [k,l];
			%check if inside ellipse, given two link nodes as foci 
			%calculate distance from current pixel to the two node locations. if less than d+lamda, weight is 1.then normalize
			points=[coords(i,1), coords(i,2);k,l];
			points2=[coords(j,1), coords(j,2);k,l];
			d1 = pdist(points,'euclidean');
			d2 = pdist(points2,'euclidean');
			%dlink=pdist(ab,'euclidean');
      			fflush(stdout);
			dsum=d1+d2;
			%initialize lamda, width of the ellipse
			lamda=dlink/100;
			if (dsum<(dlink+lamda))
				weight= 1/sqrt(dlink);
				linkPixel=[linkPixel;k,l];
				%draw image dinamically for each link
        			X(sub2ind(size(X), linkPixel(count, 1), linkPixel(count, 2))) = weight;
				count++;
			endif
			end
		end
		%to store linkPixel with 1
		%X = zeros(width, height);
      		if isempty(linkPixel)
	    		disp("empty");
      		else
			[mat,padded] = vec2mat(X,width);
			image(mat,'CDataMapping','scaled');
			caxis([0, 1])
			colorbar
			title('Radio Tomographic Imaging');
			pause(1)
          	endif
		%disp(X');
		W=[W;reshape(X', width*height, 1)'];
	end
end

%disp("weights");
%disp(W);

%disp("weighttranspose")
%disp(W');

disp("num_links");
disp(num_links);

function I = diffx( n )
    x=n^2;
    I = zeros( x,x );
    p = 2:x+1:(x^2-1);
    p2 = 1:x+1:(x^2); %1 to x^2
    I( p2 ) = -1;
    I( p ) = 1;
end

I = diffx(8)

%matlab is column major index so take  - this is dx
dx=I'

function Iy = diffy( n )
    x=n^2;
    Iy = zeros( x,x );
	%for circular
    p = n:x+1:(x^2-1);
    disp(p);
    p2 = 1:x+1:(x^2); %1 to x^2
    Iy( p2 ) = -1;
    Iy( p ) = 1;
    %I(p+1) =1;
end

Iy= diffy(8)
dy=Iy'

filename1='empty_1.csv';
filename2='s-3-3_1.csv';


%(filename,R1,C1,[R1 C1 R2 C2]

M1 = csvread(filename1,[0 1 27 28])
M2 = csvread(filename2,[0 1 27 28])

Mdif= M2-M1
disp("matrix Y");
Y = reshape(Mdif,[],1)
alpha=5;
midpart=(W'*W+ alpha*(dx'*dx + dy'*dy));
disp("midpart");
disp(midpart);
% dynamically drawing the image based on different Y vectors
for i=1:2
	
  size(Y);
	X= inv(midpart)*W'*Y;

	disp("X is");
	disp(X);
	[mat,padded] = vec2mat(X,width);
	%mat
	image(mat,'CDataMapping','scaled');
	%image(mat)
	colorbar
	title('Radio Tomographic Imaging');

	pause(1)
end

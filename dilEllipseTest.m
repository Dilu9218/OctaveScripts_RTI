%#!/usr/bin/octave -qf

pkg load communications

% dimentions of the terrain
width=16;
height=16;

% N is the number of voxels in the image
N = width * height;

% W is the weight matrix which will get populated on the go
W=[];

% coordinates of the wireless nodes
coords=[1,1;
	1,15;
	1,30;
	15,30;
	30,1;
	30,15;
	30,30;
	15,1];

% number of nodes
num_nodes=length(coords)

% number of links (this will get updated shortly)
num_links=0;

% link matrix (this will get updated shortly)
links=[];

%to store pixels
linkPixel=[];

% generating weight matrix
for i=1:length(coords)
	for j=i+1:length(coords)
		num_links=num_links+1;
		% start and end point of line
		a=[coords(i,1), coords(i,2)];
		b=[coords(j,1), coords(j,2)];
		%link points
		ab=[coords(i,1), coords(j,1);coords(i,2),coords(j,2)];
		% add the link to the links matrix for future use
		links=[links;a,b];
		%links;
		#ellipse
		%(x/a)^2+(y/b)^2<=1

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
			dlink=pdist(ab,'euclidean');
      			fflush(stdout);
			dsum=d1+d2;
      			%disp("sdf");
			%disp(d);
			%initialize lamda
			lamda=0;
			if (dsum<(dlink+lamda))
				linkPixel=[linkPixel;k,l];
			%else
				%disp("weight 0");
			endif
			end
		end
		%disp(linkPixel);
	end
end
disp(linkPixel);

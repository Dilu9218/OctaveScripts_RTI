%#!/usr/bin/octave -qf

pkg load communications

% dimentions of the terrain
width=30;
height=30;

% N is the number of voxels in the image
N = width * height;

% W is the weight matrix which will get populated on the go
W=[];

% coordinates of the wireless nodes
coords=[1,1;
	1,15;
	1,30;
	30,1;
	30,15;
	30,30;];

% number of nodes
num_nodes=length(coords)

% number of links (this will get updated shortly)
num_links=0;

% link matrix (this will get updated shortly)
links=[];

% generating weight matrix
for i=1:length(coords)
	for j=i+1:length(coords)
		num_links=num_links+1;
		% start and end point of line
		a=[coords(i,1), coords(i,2)];
		b=[coords(j,1), coords(j,2)];

		% add the link to the links matrix for future use
		links=[links;a,b];

		% get diffs
		ab = b - a;
		disp(ab);
		% find number of steps required to be "one pixel wide" in the shorter
		%#{
		% two dimensions
		n = max(abs(ab)) + 1;
		disp(n);
		% compute line
		s = repmat(linspace(0, 1, n)', 1, 2);
		for d = 1:2
			s(:, d) = s(:, d) * ab(d) + a(d);
		end

		% round to nearest pixel
		s = round(s);

		% if desired, apply to a matrix
		X = zeros(width, height);
		X(sub2ind(size(X), s(:, 1), s(:, 2))) = 1;

		% insert in to the weight matrix
		W=[W;reshape(X', width*height, 1)'];
		%#}
		
		#ellipse
		%(x/a)^2+(y/b)^2<=1
	end
end


% dynamically drawing the image based on different Y vectors
for i=1:10
	% generating a Y vector with sample RSSI change values
	Y=zeros(1, num_links);
	Y(1:15)=60;
	%Y(randi([20 60]):randi([70 90]))=1;
	
	% generating image matrix based on Y vector 
	X=Y*W;
	
	[mat,padded] = vec2mat(X,width);
	%mat

	image(mat,'CDataMapping','scaled');
	%image(mat)
	colorbar
	title('Radio Tomographic Imaging');

	pause(1)
end



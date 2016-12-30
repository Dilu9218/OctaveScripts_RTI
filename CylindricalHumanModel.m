%#!/usr/bin/octave -qf
pkg load communications
pkg load statistics
pkg load image


% Create a logical image of a circle with specified
% diameter, center, and image size.
% First create the image.
imageSizeX = 20;
imageSizeY = 20;
[columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
% Next create the circle in the image.
centerX = 9;
centerY = 9;
radius = 1.3;
circlePixels = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 <= radius.^2;
% circlePixels is a 2D "logical" array.
% Now, display it.
image(circlePixels) ;
colormap([0 0 0; 1 1 1]);
title('Binary image of a circle');
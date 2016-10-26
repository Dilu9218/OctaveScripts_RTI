%#!/usr/bin/octave -qf

pkg load communications
pkg load statistics

function I = diffx( n )
    x=n^2;
    I = zeros( x,x );
    p = 2:x+1:(x^2-1);
    p2 = 1:x+1:(x^2); %1 to x^2
    I( p2 ) = -1;
    I( p ) = 1;
end

I = diffx(4)

%matlab is column major index so take  - this is dx
I'




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

Iy= diffy(4)
%matlab is column major index so this is dy
Iy'

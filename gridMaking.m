%#!/usr/bin/octave -qf
pkg load communications
pkg load statistics
pkg load image


x = linspace(0,40);
y = x;
plot(x,y,'w')
grid on
grid minor
set(gca,'Xtick',0:1:40)
set(gca,'Ytick',0:1:40)
%set(gca,'Xtick',0:1:8)
%set(gca,'Ytick',0:1:8)

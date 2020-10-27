clear
clc
close all

r11=0;
r21=0;
r31=-1;
r14=1.4;
r24=-0.5;
r34=0.2;

a4 = 1.02;
d1 = 1.5;

%%

q1 = atan2(r24-a4*r21, r14-a4*r11);
rad2deg(q1)
q2 = atan2(r34-a4*r31-d1, sqrt((r24-a4*r21)^2 + (r14-a4*r11)^2));
rad2deg(q2)
q3 = sqrt((r24-a4*r21)^2 + (r14-a4*r11)^2 + (r34-a4*r31-d1)^2)
q4 = atan2(r31, sqrt(r11^2 + r21^2)) + q2;
rad2deg(q4)

%%


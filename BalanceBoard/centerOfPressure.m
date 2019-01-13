function [COPx,COPz] = centerOfPressure(s1, s2, s3, s4, BParam1, BParam2)
% Calculates center of pressre.
% Accepts data from four sensors and board parameters,  
% returns center of pressure X and center of pressure Z
ftotal = s1 + s2 + s3 + s4; % Total force

momentOfInertiaX = BParam1 * (s1-s2+s3-s4);
momentOfInertiaZ = BParam2 * (-s1-s2+s3+s4);

COPx = momentOfInertiaZ/ftotal;
COPz = momentOfInertiaX/ftotal;

COPx = round(COPx,2);
COPz = round(COPz,2);
end
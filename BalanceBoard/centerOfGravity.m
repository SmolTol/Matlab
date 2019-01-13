function [COGx,COGz] = centerOfGravity(s1, s2, s3, s4, s5, s6, s7, s8, ...
    COPLx, COPLz, COPRx, COPRz, offset)
% calculates coordinates of center of gravity
% Accepts info from sensors and COP coordinates
% Returns center of gravity X and center of gravity Z

% Offsets
xOffsetCOPL = COPLx - offset;
xOffsetCOPR = COPRx + offset;

% Weights from sensors
platformWeightLeft = s1 + s2 + s3 + s4;
platformWeightRight = s5 + s6 + s7 + s8;
platformsWeightTotal = platformWeightLeft + platformWeightRight;

% Moments of Inertia
xMomentLeft = platformWeightLeft * xOffsetCOPL;
xMomentRight = platformWeightRight * xOffsetCOPR;
zMomentLeft = platformWeightLeft * COPLz;
zMomentRight = platformWeightRight * COPRz;
xMomentTotal = xMomentLeft + xMomentRight;
zMomentTotal = zMomentLeft + zMomentRight;

% Center of gravity
COGx = xMomentTotal/platformsWeightTotal;
COGz = zMomentTotal/platformsWeightTotal;

COGx = round(COGx,2);
COGz = round(COGz,2);
end
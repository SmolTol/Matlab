% Cleans workspace
clc; clear all; close all;

% Analyzes data from the WiiBoard
% Gets: Weight data from WiiBoard
%       Format: Eight unsigned ints from 0 to 150
% Returns: Center of Gravity (COG)
%          Center of Pressure (COP)
%          Statistical information

% TODO: expected input, expected output check
% TODO: Time since script was started
% TODO: Gets 8 points of data, all amount to player weight
% Done: Return COP per each board of the platform, and total COP
% Done: Return COG
% Done: Save all points of data returned and gotten in Excel
% Done: Create matrix of data returns 
% TODO: For each data point return:
%       V1) Mean
%       V2) Median
%       V3) Standard Deviation
%       4) Percentile
%       5) Plots
%       6) Ellipse of Inertia
% TODO: Create a Timer Function
%%%%%%%%%%%%%%%%%%
% Board Parameters:
% Distance measurements and offsets in milimeters
%%%%%%%%%%%%%%%%%%
halfOfBoardLength = 433/2;
halfOfBoardWidth = 238/2;
distanceBetweenPlatforms = 77;
PlatformOffset = 157.5; % Distance from Total center to platform center (mm)

%%%%%%%%%%%%%%%%%%
% Test parameters:
% Mock data to be replaced with actual sensor
% data when the connection works
% line 12/41 excel
%%%%%%%%%%%%%%%%%%

% Left platform sensors data points
LPLT = 6;
LPLB = 14.9;
LPRT = 9.2;
LPRB = 14.8;

% Right platform sensors data points
RPLT = 6.5;
RPLB = 12.7;
RPRT = 5.2;
RPRB = 10.2;

%%%%%%%%%%%%%%%%%%
% Do the math
%%%%%%%%%%%%%%%%%%
% Center of pressure Left Board
[CoPLeftX, CoPLeftZ] = centerOfPressure(LPLT, LPLB, LPRT, LPRB, ...
    halfOfBoardLength, halfOfBoardWidth)

% Center of pressure on Right Board
[CoPRightX, CoPRightZ] = centerOfPressure(RPLT, RPLB, RPRT, RPRB, ...
    halfOfBoardLength, halfOfBoardWidth)

% Center of pressure Total
[CoPTotalx, CoPTotalZ] = centerOfPressure(LPLT, LPLB, RPRT, RPRB, ...
    halfOfBoardLength, (2*halfOfBoardWidth + distanceBetweenPlatforms/2))

% Center of gravity total
[CoGx, CoGz] = centerOfGravity(LPLT, LPLB, LPRT, LPRB,RPLT, RPLB, RPRT,...
    RPRB, CoPLeftX, CoPLeftZ, CoPRightX, CoPRightZ, PlatformOffset)

%%%%%%%%%%%%%%%%%%
% Write data in Excel and open the file
%%%%%%%%%%%%%%%%%%

vectorHeader = {'Time','LPLT','LPLB','LPRT','LPRB','RPLT','RPLB','RPRT','RPRB',...
'COPLx','COPLz','COPRx','COPRz','COGx','COGz'};
xlswrite('dataAnalyzerSheet.xlsx',vectorHeader,'A1:O1');

vectorOfResults = [0, LPLT,LPLB,LPRT,LPRB,RPLT, RPLB, RPRT, RPRB,CoPLeftX,...
CoPLeftZ,CoPRightX, CoPRightZ, CoGx, CoGz];
xlswrite('dataAnalyzerSheet.xlsx',vectorOfResults,'A2:O2');

winopen('dataAnalyzerSheet.xlsx')


numberOfCycles = 120;
matrixOfResults = zeros(numberOfCycles,length(vectorOfResults))

for n = 1:numberOfCycles
   matrixOfResults(n,1:length(vectorOfResults)) = vectorOfResults
    
end

%%%%%%%%%%%%%%%%%%
%Plotting
%%%%%%%%%%%%%%%%%%
dataFromColumns = xlsread(dataAnalyzerSheet.xls,1,J2:J121);

%%%%%%%%%%%%%%%%%%
%Statistical analysis
%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%
% Function definitions
%%%%%%%%%%%%%%%%%%
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

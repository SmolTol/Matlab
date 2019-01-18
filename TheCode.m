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
LPLT = 4.854;
LPLB = 6.181;
LPRT = 5.057;
LPRB = 6.338;

% Right platform sensors data points
RPLT = 4.634;
RPLB = 6.729;
RPRT = 5.539;
RPRB = 7.921;

%%%%%%%%%%%%%%%%%%
% Do the math
%%%%%%%%%%%%%%%%%%
% Center of pressure Left Board
[CoPLeftX, CoPLeftZ] = centerOfPressureLeft(LPRB, LPRT, LPLB, LPLT, ...
    halfOfBoardLength, halfOfBoardWidth)

% Center of pressure on Right Board
[CoPRightX, CoPRightZ] = centerOfPressureRight(RPLT, RPLB, RPRT, RPRB, ...
    halfOfBoardLength, halfOfBoardWidth)

% Center of pressure Total
%[CoPTotalx, CoPTotalZ] = centerOfPressure(LPLT, LPLB, RPRT, RPRB, ...
    %halfOfBoardLength, (2*halfOfBoardWidth + distanceBetweenPlatforms/2))

% Center of gravity total
[CoGx, CoGz] = centerOfGravity(LPRB, LPRT, LPLB, LPLT ,RPLT, RPLB, RPRT,...
    RPRB, CoPLeftX, CoPLeftZ, CoPRightX, CoPRightZ, PlatformOffset)

%%%%%%%%%%%%%%%%%%
% Write data in Excel and open the file
%%%%%%%%%%%%%%%%%%

vectorHeader = {'Time','LPLT','LPLB','LPRT','LPRB','RPLT','RPLB','RPRT','RPRB',...
'COPLx','COPLz','COPRx','COPRz','COGx','COGz'};
xlswrite('dataAnalyzerSheep.xlsx',vectorHeader,'A1:O1');

vectorSider = {'Mean','Median','S.D'};
xlswrite('dataAnalyzerSheep.xlsx',vectorSider(:),'I123:I125');
winopen('dataAnalyzerSheep.xlsx')
vectorOfResults = [0, LPLT,LPLB,LPRT,LPRB,RPLT, RPLB, RPRT, RPRB,CoPLeftX,...
CoPLeftZ,CoPRightX, CoPRightZ, CoGx, CoGz];
xlswrite('dataAnalyzerSheep.xlsx',vectorOfResults,'A2:O2');

xlswrite('dataAnalyzerSheep.xlsx',1,'J3:O120');

winopen('dataAnalyzerSheep.xlsx')

%%%%%%%%%%%%%%%%%%
%Plotting
%%%%%%%%%%%%%%%%%%
dataFromColumns = xlsread("dataAnalyzerSheet.xlsx" , "J2:O121");
COPLeftx = dataFromColumns(1:119,1);
COPLeftz = dataFromColumns(1:119,2);
COPRightx = dataFromColumns(1:119,3);
COPRightz = dataFromColumns(1:119,4);
COGravx = dataFromColumns(1:119,5);
COGravz = dataFromColumns(1:119,6);

figure(1)
plot(COPLeftx,COPLeftz, ':r')
xlabel('X [mm]');
ylabel('Z [mm]');
xlim([-120 120]);
ylim([-220 220]);
grid on
grid minor
ax.XTick = [-120:10:120];
ax.YTick = [-220:10:220];
title('Center of Pressure Left')

%Perc1 = prctile(COPLeftx,[25 50 75],1)

figure(2)
plot(COPRightx,COPRightz, '--xg' )
xlabel('X [mm]');
ylabel('Z [mm]');
xlim([-120 120]);
ylim([-220 220]);
grid on
grid minor
ax.XTick = [-120:10:120];
ax.YTick = [-220:10:220];
title('Center of Pressure Right')

figure(3)
plot(COGravx,COGravz, '-o')
xlabel('X [mm]');
ylabel('Z [mm]');
xlim([-242 242]);
ylim([-220 220]);
grid on
grid minor
ax.XTick = [-242:10:242];
ax.YTick = [-220:10:220];
title('Center of Gravity')

%%%%%%%%%%%%%%%%%%
%Statistical analysis
%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%
% Function definitions
%%%%%%%%%%%%%%%%%%
function [COPLx,COPLz] = centerOfPressureLeft(s1, s2, s3, s4, BParam1, BParam2)
% Calculates center of pressre of the Left Platform.
% Accepts data from four sensors and board parameters,  
% returns center of pressure X and center of pressure Z
FLtotal = s1 + s2 + s3 + s4; % Total force

momentOfInertiaLX = BParam1 * (-s1+s2-s3+s4);
momentOfInertiaLZ = BParam2 * (s1+s2-s3-s4);

COPLx = momentOfInertiaLZ/FLtotal;
COPLz = momentOfInertiaLX/FLtotal;

COPLx = round(COPLx,2);
COPLz = round(COPLz,2);
end

function [COPRx,COPRz] = centerOfPressureRight(s1, s2, s3, s4, BParam1, BParam2)
% Calculates center of pressre of the Right Platform.
% Accepts data from four sensors and board parameters,  
% returns center of pressure X and center of pressure Z
FRtotal = s1 + s2 + s3 + s4; % Total force

momentOfInertiaRX = BParam1 * (s1-s2+s3-s4);
momentOfInertiaRZ = BParam2 * (-s1-s2+s3+s4);

COPRx = momentOfInertiaRZ/FRtotal;
COPRz = momentOfInertiaRX/FRtotal;

COPRx = round(COPRx,2);
COPRz = round(COPRz,2);
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

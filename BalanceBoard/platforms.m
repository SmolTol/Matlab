% bb1 = actxserver('WiiLab.WiiLAB');
% bb1.Connect();
% bb2 = actxserver('WiiLab.WiiLAB');
% bb2.Connect();
clearvars -except bb1 bb2
OffsetL = bb1.GetBalanceBoardSensorState()/4;
OffsetR = bb2.GetBalanceBoardSensorState()/4;
i = 1;
%while 1==1
% sec = 60;
% fs = 30;
for j=1:1800;
PlatformL(i,:) = (bb1.GetBalanceBoardSensorState()/4)-OffsetL;
PlatformR(i,:) = (bb2.GetBalanceBoardSensorState()/4)-OffsetR;
PlatformTime(i,:) = clock;
i = i+1;
pause(1/30);
end
%%
%%%%%%%%%%%%%%%%%%
% Board Parameters:
% Distance measurements and offsets in milimeters
halfOfBoardLength = 433/2;
halfOfBoardWidth = 238/2;
distanceBetweenPlatforms = 77;
PlatformOffset = 157.5;% Distance from Total center to platform center (mm)

for n = 1:length(PlatformTime)
% Left platform sensors data points
LPLT = PlatformL(n,4) ;
LPLB = PlatformL(n,3) ;
LPRT = PlatformL(n,2) ;
LPRB = PlatformL(n,1) ;

% Right platform sensors data points
RPLT = PlatformR(n,1) ;
RPLB = PlatformR(n,2) ;
RPRT = PlatformR(n,3) ;
RPRB = PlatformR(n,4) ;
end %not sure if this is the right location
%%%%%%%%%%%%%%%%%%
% Do the math
%%%%%%%%%%%%%%%%%%
% Center of pressure Left Board
[CoPLeftX, CoPLeftZ] = centerOfPressureLeft(LPRB, LPRT, LPLB, LPLT, ...
    halfOfBoardLength, halfOfBoardWidth)

% Center of pressure on Right Board
[CoPRightX, CoPRightZ] = centerOfPressureRight(RPLT, RPLB, RPRT, RPRB, ...
    halfOfBoardLength, halfOfBoardWidth)

% Center of gravity total
[CoGx, CoGz] = centerOfGravity(LPRB, LPRT, LPLB, LPLT ,RPLT, RPLB, RPRT,...
    RPRB, CoPLeftX, CoPLeftZ, CoPRightX, CoPRightZ, PlatformOffset)

%%%%%%%%%%%%%%%%%%
% Write data in Excel and open the file
%%%%%%%%%%%%%%%%%%

vectorHeader = {'Time','LPLT','LPLB','LPRT','LPRB','RPLT','RPLB','RPRT','RPRB',...
'COPLx','COPLz','COPRx','COPRz','COGx','COGz'};
xlswrite('dataAnalyzerSheet.xlsx',vectorHeader,'A1:O1');

vectorOfResults = [0, LPLT,LPLB,LPRT,LPRB,RPLT, RPLB, RPRT, RPRB,CoPLeftX,...
CoPLeftZ,CoPRightX, CoPRightZ, CoGx, CoGz];
xlswrite('dataAnalyzerSheet.xlsx',vectorOfResults,'A2:O1801');

%xlswrite('dataAnalyzerSheet.xlsx',1,'J3:O120');

winopen('dataAnalyzerSheet.xlsx')

%%%%%%%%%%%%%%%%%%
%Plotting
%%%%%%%%%%%%%%%%%%
dataFromColumns = xlsread("dataAnalyzerSheet.xlsx" , "J2:O1801");
COPLeftx = dataFromColumns(1:1800,1);
COPLeftz = dataFromColumns(1:1800,2);
COPRightx = dataFromColumns(1:800,3);
COPRightz = dataFromColumns(1:800,4);
COGravityx = dataFromColumns(1:800,5);
COGravityz = dataFromColumns(1:800,6);




for n = 1:length(dataFromColumns)

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
plot(COGravityx,COGravityz, '-o')
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

%bb1.Disconnect();
%bb2.Disconnect();
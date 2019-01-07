%function initBB(app)
            bb1 = actxserver('WiiLab.WiiLAB');
            bb2 = actxserver('WiiLab.WiiLAB');
            bb1.Connect();
            bb2.Connect();
            
            app.BB1 = bb1;
            app.BB1Tara = bb1.GetBalanceBoardSensorState();
            app.BB2 = bb2;
            app.BB2Tara = bb2.GetBalanceBoardSensorState();
            %
%Left platform%
F1 = 8.8;
F2 = 20.4;
F3 = 8.4;
F4 = 15.7;
%LLT = F1%
%LLB = F2%
%LRT = F3%
%LRB = F4%
 
%dimensions [m]%
a = 0.433/2;
b = 0.238/2;
c = 0.077;
k = b+(c/2);

 
%Total force LP%
Fyl = (F1+F2+F3+F4);
 
%Moments of LP%
Mxl = a*(F1-F2+F3-F4);
Mzl = b*(-F1-F2+F3+F4);
 
%Location of COP LP%
Pxl = (Mzl/Fyl)
Pzl = (Mxl/Fyl)
 
%Right platform%
F5 = 6.8;
F6 = 13;
F7 = 10.9;
F8 = 19;
%RLT = F5%
%RLB = F6%
%RRT = F7%
%RRB = F8%
 
%dimensions [mm]%
a = 238/2;
b = 433/2;
c = 77;
 
%Total force RP%
Fyr = (F5+F6+F7+F8);
 
%Moments of RP%
Mxr = a*(F5-F6+F7-F8);
Mzr = b*(-F5-F6+F7+F8);
 
%Location of COP RP%
Pxr = (Mzr/Fyl)
Pzr = (Mxr/Fyl)

%change the axis system from seperate one for each platform to one main sys for the 2 platforms together%
COPLx = Pxl+k;
COPLz = Pzl+k;
COPRx = Pxr-k;
COPRz = Pzr-k;

%Calculate COG :distance = weight/moment%
COGx = (Fyl+Fyr)/((Fyl*COPLx)+(Fyr*COPRx))
COGz = (Fyl+Fyr)/((Fyl*COPLz)+(Fyr*COPRz))

header = {'Time','LLT','LLB','LRT','LRB','RLT','RLB','RRT','RRB','COPLx','COPLz','COPRx','COPRz','COGx','COGz'}
xlswrite ('Testcod',header,'Sheet1')
%for  %BB is recording?
    
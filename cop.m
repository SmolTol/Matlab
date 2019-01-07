function [ copX, copY ] = cop(sensors, bb)
%Pravá plo?ina 2, levá plo?ina 1
if sum(sensors) < 1
    copX = nan;
    copY = nan;
    
    return;
end

copXSingle = (433/2)*(((sensors(1)+sensors(3))-(sensors(2)+sensors(4)))/sum(sensors));
copYSingle = (238/2)*(((sensors(1)+sensors(2))-(sensors(3)+sensors(4)))/sum(sensors));

if bb == 2
    copX = ((77/2)+(238/2)) - copYSingle;
    copY = copXSingle;
elseif bb == 1
    copX = -((77/2)+(238/2)) + copYSingle;
    copY = -copXSingle;        
end


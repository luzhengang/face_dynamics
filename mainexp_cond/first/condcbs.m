clc;
close all;
clear all;
load subcondition_PT.mat;
for j=1:24
data=eval(['conditionrun' int2str(j)]);
for i=1:90
    if data(i,3)==1
        data(i,3)=3;
    elseif data(i,3)==2
        data(i,3)=4;
    end
end
for i=1:90
    if data(i,3)==3
        data(i,3)=2;
    elseif data(i,3)==4
        data(i,3)=1;
    end
end
eval(['conditionrun' num2str(j) '= data;']);
end
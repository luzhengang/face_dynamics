clc;
close all;
clear all;
load subcondition_PT.mat;
for j=1:24
    for i=1:45
data=eval(['conditionrun' int2str(j)]);
 u=0.18+(floor((i-1)./1)+1)*0.02;  
a(i,j)=length(find(data(:,2)==u));
    end
end
for j=1:24
data=eval(['conditionrun' int2str(j)]);
b(1,j)=length(find(data(:,3)==1&data(:,4)==1&data(:,5)==1));
b(2,j)=length(find(data(:,3)==1&data(:,4)==2&data(:,5)==1));
b(3,j)=length(find(data(:,3)==1&data(:,4)==1&data(:,5)==2));
b(4,j)=length(find(data(:,3)==1&data(:,4)==2&data(:,5)==2));
b(5,j)=length(find(data(:,3)==2&data(:,4)==1&data(:,5)==1));
b(6,j)=length(find(data(:,3)==2&data(:,4)==2&data(:,5)==1));
b(7,j)=length(find(data(:,3)==2&data(:,4)==1&data(:,5)==2));
b(8,j)=length(find(data(:,3)==2&data(:,4)==2&data(:,5)==2));
end
for j=1:24
data=eval(['conditionrun' int2str(j)]);
c(1,j)=length(find(data(:,3)==1));
c(2,j)=length(find(data(:,4)==1));
c(3,j)=length(find(data(:,5)==1));
end

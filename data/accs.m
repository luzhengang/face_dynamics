clc;
close all;
clear all;
cd './JR'
load data_JR_mainexp25.mat
answer=zeros(80,3);
answer(:,1)=presentations(:,4); % first face/house
answer(:,3)=botpress(:,1);
answer(:,2)=presentations(:,3); % second face/house
acc=zeros(80,1);
for i=1:80
    if answer(i,1) ==1 && answer(i, 2) == 1 && answer(i,3) ==49 % 1: left button:yes
        acc(i,1) =1;
    elseif answer(i,1) ==2 && answer(i, 2) == 2 && answer(i,3) ==49 % 1: left button:yes
        acc(i,1) =1;
    elseif answer(i,1) ==1 && answer(i, 2) == 2 && answer(i,3) == 50 % 2: right button: no
        acc(i,1) =1;
    elseif answer(i,1) ==2 && answer(i, 2) == 1 && answer(i,3) ==50 % 2: right button: no
        acc(i,1) =1;
    end
end
a=find(acc==1);
Acc=(length(a)/80)*100
%  Loads session parameters
%  Loads images
%  Initializes run and trials
%*********************************************
% Experimental session parameters:
filename=[];
while isempty(filename)
    filename=input('Enter name of data file: ', 's');
    if filename == ' '
        filename = [];
    end
end
run = [];
temprun = input('Enter run number:\n');
while isempty(run)
    sid = strcat(filename, '_mainexp', num2str(temprun));
    sd = exist(sprintf('data\\%s.mat', sid));
    if(sd > 0)
        temprun = input('You have already done this run, please pick a new run:\n');
    else
        run = temprun;
    end
end
DEBUG = input('Are we debugging? 0 or 1:\n');
    cd('mainexp_cond')
    eval(['load subcondition_' filename ';']);
    eval(['conditions = conditionrun' num2str(temprun) ';']);
    cd ..
%%%%%%%%%%timing 
cuetime = 0.1;
targettime = 0.1;
fixationtime = 4; 
TR = 2;
nimages=1;
totalNum=80;
%*************************************
load mainsti;
[stimheight, stimwidth] = size(hf4); 
waitingtext = 'READY';
pulse = [];
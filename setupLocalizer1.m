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
    sid = strcat(filename, '_local', num2str(temprun));
    sd = exist(sprintf('data\\%s.mat', sid));
    if(sd > 0)
        temprun = input('You have already done this run, please pick a new run:\n');
    else
        run = temprun;
    end
end
DEBUG = input('Are we debugging? 0 or 1:\n');
s = RandStream('mt19937ar','Seed', sum(100*clock));
RandStream.setGlobalStream(s);
%%%%%%timing
posttime = 0.5; % to allow either 15msec frames, or 10 msec
testtime = 0.5; %1 sec per face with 12 faces
TR = 2;
fixationtime = 16;
%*******************************
nreps = 5; % number of image repetitions per run
nconds = 2;
nimages = 12; 
noneback = 4;
%% Create List of Trial Parameters
    ntrials = nconds*(nimages+noneback)*nreps;
    conditions = zeros(ntrials,3);
    trialindex = 1;
    randruns=randperm(10);
    for rep = 1:nreps
        conds = [randruns(rep*2-1) randruns(rep*2)];
        for condindex = 1:nconds
            randimage = randperm(nimages); 
            temp = randperm(nimages);             
            randtrial =[temp(1),temp(2),temp(3),temp(4)];
            for i = 1:(nimages)
                conditions(trialindex,:) = [conds(condindex) randimage(i) 0];% fifth colum of conditions will indicate whether it is a repeat
                trialindex = trialindex+1;
                if randtrial(1) == i || randtrial(2) == i || randtrial(3) == i|| randtrial(4) == i  % IF this is the randomly selected trial to be repeated
                    conditions(trialindex,:) = [conds(condindex) randimage(i) 1];% fifth colum of conditions will indicate whether it is a repeat
                    trialindex = trialindex +1;
                end                
            end
        end
    end
%*************************************
%Load Stimuli
load sti
[stimheight, stimwidth] = size(face1); 
fixationtext = '+';
waitingtext = 'task is one back task';
waitingtextt = 'Ready';
pulse = [];
clear all;
close all;
clc;
filename = [];
while isempty(filename)
    filename = input('Enter name of data file: ', 's');
    if filename == ' '
        filename = [];
    end
end
for CycNum=1:6 % repeat 6 time for each trial
s = RandStream('mt19937ar','Seed', sum(100*clock));
RandStream.setGlobalStream(s);
%SOA_list=0.025:0.025:1; %%%%% in second
SOA_list = 2:2:80; %%%%% in refresh frame
% 1 trialNum 2 SOA 3  targetplace  4 targetshape 5 cue place 6 condtype(1-2,,valid,invalid) 
    totalNum = length(SOA_list)*8; % 2x2x2 = 8 experimental conditions
    orig_design = zeros(totalNum,6);
    orig_design(:,1) = [1:totalNum]';
    orig_design(:,3) = repmat([1 2 1 2 2 1 2 1],1,1*length(SOA_list));
    orig_design(:,4) = repmat([1 1 2 2 1 1 2 2],1,1*length(SOA_list));
    orig_design(:,5) = repmat([1 1 1 1 2 2 2 2],1,1*length(SOA_list));
    orig_design(:,6) = repmat([1 2],1,4*length(SOA_list));  
    %%%%SOA
    for i=1:totalNum
        %orig_design(i,2) = (floor((i-1)./8)+1)*0.025;
        orig_design(i,2) = (floor((i-1)./8)+1)*2;
    end;
    %%%%permutation
    trial_order=orig_design(:,1);
    trial_order = trial_order(randperm(totalNum));
    rand_design = orig_design; 
    for i=2:6
        rand_design(:,i)=orig_design(trial_order,i);
    end;
    design_cell{CycNum,1}=orig_design;
end
    %%%%permutation
    orig_matrix=cell2mat(design_cell);
    matrix_order=randperm(totalNum*6);
    rand_matrix = orig_matrix; 
    for i=1:6
        rand_matrix(:,i)=orig_matrix(matrix_order,i);
    end;
    for RunNum=1:24
        eval(['run_matrix' int2str(RunNum) '=rand_matrix(RunNum*80-79:RunNum*80,1:6)']);
    end
     randrun=randperm(24);
    for i=1:24
        l=randrun(i);
        eval(['conditions = run_matrix' num2str(l) ';']);
        eval(['conditionrun' num2str(i) '= conditions;']);
    end
    save(sprintf('mainexp_cond\\subcondition_%s.mat', filename), 'conditionrun*');
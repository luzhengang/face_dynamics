%Presents images in fMRI experiment
try
    clear all;
    close all;
    clc;
    AssertOpenGL;
    oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
    Screen('Preference','SkipSyncTests', 1);
    setupLocalizer1;    
    %% Prepare Screen for Experiment
    HideCursor;
    screenNumber=max(Screen('Screens'));
    gray=GrayIndex(screenNumber);
    black=BlackIndex(screenNumber);
    [window,screenRect]=Screen('OpenWindow',screenNumber,gray,[],8,2); % full SCREEN mode, in mid-level gray
    Screen('TextSize', window,30);
    facerect = [0 0 stimwidth stimheight];
    facerect = CenterRect(facerect, screenRect);
    %% Turn the images into Textures and Set Up Texture Order for Experiment
    faceindex=zeros(1,nimages);
    houseindex = zeros(1,nimages);
    for number = 1:nimages
        imagename = eval(strcat('face',num2str(number))); 
        faceindex(number)=Screen('MakeTexture', window, imagename); 
        imagename = eval(strcat('house',num2str(number))); 
        houseindex(number)=Screen('MakeTexture', window, imagename); 
    end
    testindex = zeros(size(conditions,1),1);
    for trial = 1:size(conditions,1)
        if conditions(trial,1) == 1 || conditions(trial,1) == 3 || conditions(trial,1) == 5 || conditions(trial,1) == 7 || conditions(trial,1) == 9
            testindex(trial) = faceindex(conditions(trial,2));
        elseif conditions(trial,1) == 2 || conditions(trial,1) == 4 || conditions(trial,1) == 6 || conditions(trial,1) == 8 || conditions(trial,1) == 10
            testindex(trial) = houseindex(conditions(trial,2));
        end
    end 
    %%%%%Prep Port
    if ~DEBUG
        [P4, openerror] = IOPort('OpenSerialPort', 'COM6','BaudRate=19200'); %opens port for receiving scanner pulse
        IOPort('Flush', P4); %flush event buffer
    end
    % SHOW READY TEXT
    DrawFormattedText(window, waitingtext, 'center', 'center', black);
    DrawFormattedText(window, waitingtextt, 'center', 460, black);
    Screen('Flip', window); % Shows 'READY'
    Screen('TextSize', window,40);
    %PREP FOR FIRST FIXATION
    DrawFormattedText(window, fixationtext, 'center', 'center', black);
    %% START TRIALS
    trial = 1;
    fixation = 1;
    presentations = zeros(ntrials,5);
    botpress = zeros(ntrials,1);
    timepress = zeros(ntrials,1);
    while 1
        if ~DEBUG
            [pulse,temptime,readerror] = IOPort('read',P4,1,1);
            scanstart = GetSecs;
        else
            [keyIsDown,secs,keyCode] = KbCheck; 
            if keyCode(53) % If 5 is pressed on the keyboard
                pulse = 53;
            end
            scanstart = GetSecs;
        end
        if ~isempty(pulse) && (pulse == 53)
            break;
        end
    end    
    begintime = GetSecs;
    while trial <= size(conditions,1) %plus one allows for final fixation   
            if fixation == 1; % PRESENT FIXATION BLOCK
                Screen('Flip', window); % Shows fixation
                starttime = GetSecs;
                while GetSecs - starttime < fixationtime-.2
                fixation =0;
                pluse =0;
                Screen('DrawTexture', window, testindex(trial), [], facerect);                
                Screen('DrawingFinished', window);
                end
        while 1
                 if ~DEBUG
                   [pulse,temptime,readerror] = IOPort('read',P4,1,1);
                   scanstart = GetSecs;
                 else
                   [keyIsDown,secs,keyCode] = KbCheck; 
                 if keyCode(53) % If 5 is pressed on the keyboard
                    pulse = 53;
                 end
                   scanstart = GetSecs;
                 end
                 if ~isempty(pulse) && (pulse == 53)
                   break;
                 end
        end         
            else % PRESENT IMAGE BLOCK                
                Screen('Flip', window);
                starttime1 = GetSecs;
                presentations (trial,:) = [conditions(trial,:), begintime, starttime1];
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
                if ~DEBUG              
                    while 1
                        while 1
                            pulse=IOPort('read',P4,0,1);
                            if ~isempty(pulse) && (pulse ~= 53)
                                botpress(trial,1)=pulse;
                                timepress(trial,1)=GetSecs-starttime1;
                                break
                            end
                            if GetSecs-starttime1>=testtime
                                break
                            end
                        end
                        if GetSecs-starttime1>=testtime
                                break
                        end
                    end
                else 
                     while 1
                        while 1
                           [keyIsDown,secs,keyCode] = KbCheck;
                           pulse = find(keyCode);
                            if ~isempty(pulse) && (pulse ~= 53)
                                botpress(trial,1)=pulse;
                                timepress(trial,1)=GetSecs-starttime1;
                                break
                            end
                            if GetSecs-starttime1>=testtime
                                break
                            end
                        end
                        if GetSecs-starttime1>=testtime
                                break
                        end
                     end 
                end
                Screen('Flip', window); % Hides image/shows fixation
                trial = trial+1;
                Screen('DrawTexture', window, testindex(trial), [], facerect);               
                Screen('DrawingFinished', window);
                if ~DEBUG                 
                    while 1
                        while 1
                            pulse=IOPort('read',P4,0,1);
                            if ~isempty(pulse) && (pulse ~= 53)
                                botpress(trial,1)=pulse;
                                timepress(trial,1)=GetSecs-starttime1;
                                break
                            end
                            if GetSecs-starttime1>=testtime+posttime
                                break
                            end
                        end
                        if GetSecs-starttime1>=testtime+posttime
                                break
                        end
                    end
                else 
                     while 1
                        while 1
                           [keyIsDown,secs,keyCode] = KbCheck;
                           pulse = find(keyCode);
                            if ~isempty(pulse) && (pulse ~= 53)
                                botpress(trial,1)=pulse;
                                timepress(trial,1)=GetSecs-starttime1;
                                break
                            end
                            if GetSecs-starttime1>=testtime+posttime
                                break
                            end
                        end
                        if GetSecs-starttime1>=testtime+posttime
                                break
                        end
                     end 
                end                           
                %Show Second Image
                Screen('Flip', window);
                starttime2 = GetSecs;            
                presentations (trial,:) = [conditions(trial,:), begintime, starttime2];
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
               if ~DEBUG            
                    while 1
                        while 1
                            pulse=IOPort('read',P4,0,1);
                            if ~isempty(pulse) && (pulse ~= 53)
                                botpress(trial,1)=pulse;
                                timepress(trial,1)=GetSecs-starttime2;
                                break
                            end
                            if GetSecs-starttime1>=testtime+testtime+posttime
                                break
                            end
                        end
                        if GetSecs-starttime1>=testtime+testtime+posttime
                                break
                        end
                    end
                else 
                     while 1
                        while 1
                           [keyIsDown,secs,keyCode] = KbCheck;
                           pulse = find(keyCode);
                            if ~isempty(pulse) && (pulse ~= 53)
                                botpress(trial,1)=pulse;
                                timepress(trial,1)=GetSecs-starttime2;
                                break
                            end
                            if GetSecs-starttime1>=testtime+testtime+posttime
                                break
                            end
                        end
                        if GetSecs-starttime1>=testtime+testtime+posttime
                                break
                        end
                     end 
               end
                Screen('Flip', window); % Hides image/shows fixation             
                if ~DEBUG
                    while 1
                        while 1
                            pulse=IOPort('read',P4,0,1);
                            if ~isempty(pulse) && (pulse ~= 53)
                                botpress(trial,1)=pulse;
                                timepress(trial,1)=GetSecs-starttime2;
                                break
                            end
                            if GetSecs-starttime1>=TR
                                break
                            end
                        end
                        if GetSecs-starttime1>=TR
                                break
                        end
                    end
                else 
                     while 1
                        while 1
                           [keyIsDown,secs,keyCode] = KbCheck;
                           pulse = find(keyCode);
                            if ~isempty(pulse) && (pulse ~= 53)
                                botpress(trial,1)=pulse;
                                timepress(trial,1)=GetSecs-starttime2;
                                break
                            end
                            if GetSecs-starttime1>=TR
                                break
                            end
                        end
                        if GetSecs-starttime1>=TR
                                break
                        end
                     end 
                end
                %End of current dynamic scan prep for next trial
                trial = trial+1;
                if mod(trial, nimages+noneback)== 1  %Will the next trial need a fixation
                    fixation = 1;
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                else
                    Screen('DrawTexture', window, testindex(trial), [], facerect);                    
                    Screen('DrawingFinished', window);
                end
            end
    end
    %% Final Fixation
    while 1
        if ~DEBUG
            [pulse,temptime,readerror] = IOPort('read',P4,1,1);
            scanstart = GetSecs;
        else
            [keyIsDown,secs,keyCode] = KbCheck; 
            if keyCode(53) % If 5 is pressed on the keyboard
                pulse = 53;
            end
            scanstart = GetSecs;
        end
        if ~isempty(pulse) && (pulse == 53)
            break;
        end
    end    
    DrawFormattedText(window, fixationtext, 'center', 'center', black);
    Screen('Flip', window); % Shows fixation
    starttime = GetSecs;
    while GetSecs - starttime < fixationtime
    end
    endtime = GetSecs;
    totalexptime = endtime - begintime;
    save(sprintf('data\\data_%s.mat', sid), 'presentations', 'botpress','timepress');    
catch ME
    display(sprintf('Error in Experiment. Please get experimenter.'));
    Priority(0);
    ShowCursor
    Screen('CloseAll');
end
ShowCursor
Screen('CloseAll');
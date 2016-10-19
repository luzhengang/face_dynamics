%Presents images in fMRI experiment
%Record responses of face/house task.
try
    clear all;
    close all;
    clc;
    AssertOpenGL;
    oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
    Screen('Preference','SkipSyncTests', 1);
    setupmainexp;     
    %% Prepare Screen for Experiment
    HideCursor;
    %%Prep Screen
    screenNumber=max(Screen('Screens'));
    black=BlackIndex(screenNumber);
    gray=GrayIndex(screenNumber);
    white=WhiteIndex(screenNumber);
    [window,screenRect]=Screen('OpenWindow',screenNumber,gray,[],8,2); % full SCREEN mode, in mid-level gray
    ifi = Screen('GetFlipInterval', window);
    Screen('TextSize', window,40);
    %SETUP RECTS FOR IMAGE
    mvH = 280;
    facerect = [0 0 stimwidth stimheight]/1.5;
    center=screenRect(3:4)/2;
    fix=15;
    fix_w=5;
    box=1;
    cue_w=5;
    loc(1, :) = CenterRect(facerect, screenRect) + [-mvH 0 -mvH 0]; %left
    loc(2, :) = CenterRect(facerect, screenRect) + [mvH 0 mvH 0]; % right
    %% Prep Port
    if ~DEBUG
        [P4, openerror] = IOPort('OpenSerialPort', 'COM6','BaudRate=19200'); %opens port for receiving scanner pulse
        IOPort('Flush', P4); %flush event buffer
    end
    % SHOW READY TEXT
    DrawFormattedText(window, waitingtext, 'center', 'center', white);
    Screen('Flip', window); % Shows 'READY'
    % Prep Fixation
    Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
    Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
    % Pre left box
%     Screen('DrawLine',window,white,loc(1,1)-box,loc(1,2)-box*6/5,loc(1,1)-box,loc(1,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(1,3)+box,loc(1,2)-box*6/5,loc(1,3)+box,loc(1,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(1,1)-box*6/5,loc(1,2)-box,loc(1,3)+box*6/5,loc(1,2)-box,box/2);
%     Screen('DrawLine',window,white,loc(1,1)-box*6/5,loc(1,4)+box,loc(1,3)+box*6/5,loc(1,4)+box,box/2);
%     % Pre right box
%     Screen('DrawLine',window,white,loc(2,1)-box,loc(2,2)-box*6/5,loc(2,1)-box,loc(2,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(2,3)+box,loc(2,2)-box*6/5,loc(2,3)+box,loc(2,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(2,1)-box*6/5,loc(2,2)-box,loc(2,3)+box*6/5,loc(2,2)-box,box/2);
%     Screen('DrawLine',window,white,loc(2,1)-box*6/5,loc(2,4)+box,loc(2,3)+box*6/5,loc(2,4)+box,box/2);
    %% START TRIALS  
    trial = 1;
    presentations = zeros(totalNum,9);
    botpress = zeros(totalNum,1);
    timepress = zeros(totalNum,1);
    % Prep Port
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
    Screen('Flip', window); % Shows fixation and box
    begintime = GetSecs;
    while GetSecs - begintime < fixationtime
    end
     while trial <= totalNum
         % Prep Fixation
    Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
    Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
    % Pre left box
%     Screen('DrawLine',window,white,loc(1,1)-box,loc(1,2)-box*6/5,loc(1,1)-box,loc(1,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(1,3)+box,loc(1,2)-box*6/5,loc(1,3)+box,loc(1,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(1,1)-box*6/5,loc(1,2)-box,loc(1,3)+box*6/5,loc(1,2)-box,box/2);
%     Screen('DrawLine',window,white,loc(1,1)-box*6/5,loc(1,4)+box,loc(1,3)+box*6/5,loc(1,4)+box,box/2);
    % Pre right box
%     Screen('DrawLine',window,white,loc(2,1)-box,loc(2,2)-box*6/5,loc(2,1)-box,loc(2,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(2,3)+box,loc(2,2)-box*6/5,loc(2,3)+box,loc(2,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(2,1)-box*6/5,loc(2,2)-box,loc(2,3)+box*6/5,loc(2,2)-box,box/2);
%     Screen('DrawLine',window,white,loc(2,1)-box*6/5,loc(2,4)+box,loc(2,3)+box*6/5,loc(2,4)+box,box/2);
%% column 4 is first stimulus category, column 5 is location
%% Prepare for the first stimulus
        if conditions(trial,4) == 1 && conditions(trial,5)==1 % left face 
            Screen('PutImage', window, hf4, loc(1,:));
            Screen('PutImage', window, pnoise1, loc(2,:));
            Screen('DrawingFinished', window);
        elseif conditions(trial,4) == 1 && conditions(trial,5)==2 % right face
            Screen('PutImage', window, hf4, loc(2,:));
            Screen('PutImage', window, pnoise1, loc(1,:));
            Screen('DrawingFinished', window);
        elseif conditions(trial,4) == 2 && conditions(trial,5)==1 % left house
            Screen('PutImage', window, hh4, loc(1,:));
            Screen('PutImage', window, pnoise1, loc(2,:));
            Screen('DrawingFinished', window);
        elseif conditions(trial,4) == 2 && conditions(trial,5)==2 % right house
            Screen('PutImage', window, hh4, loc(2,:));
            Screen('PutImage', window, pnoise1, loc(1,:));
            Screen('DrawingFinished', window);
        end
%         if conditions(trial,3) == 1
%             % Prep for First cue %%%% face
%             Screen('DrawLine',window,white,loc(1,1)-5*box,loc(1,2)-box*6/5,loc(1,1)-5*box,loc(1,4)+box*6/5,cue_w);
%             Screen('DrawingFinished', window);
%         elseif conditions(trial,3) == 2 %%%% house
%             % Prep for First cue
%             Screen('DrawLine',window,white,loc(2,3)+5*box,loc(2,2)-box*6/5,loc(2,3)+5*box,loc(2,4)+box*6/5,cue_w);
%             Screen('DrawingFinished', window);
%         end
        %%%%%%% location of pre-stimuli%%%%%%

         %%%%%%%%%%%%%%%%%%%%%%%%
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
        %%%%%%%%%%%%%%%%%%%%%%%%%
        starttime1 = GetSecs;
        %presentations (trial,:) = [conditions(trial,:), begintime, starttime1];
        presentations (trial,1:7) = [conditions(trial,:), starttime1];
        Soatime=conditions(trial,2);
        Screen('Flip', window); % first stimulus onset
        %while GetSecs - starttime1 < cuetime
    % Prep Fixation and noise mask
    Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
    Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
    Screen('PutImage', window, pnoise1, loc(1,:));
    Screen('PutImage', window, pnoise1, loc(2,:));
    Screen('DrawingFinished', window);
    % Pre left box
%     Screen('DrawLine',window,white,loc(1,1)-box,loc(1,2)-box*6/5,loc(1,1)-box,loc(1,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(1,3)+box,loc(1,2)-box*6/5,loc(1,3)+box,loc(1,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(1,1)-box*6/5,loc(1,2)-box,loc(1,3)+box*6/5,loc(1,2)-box,box/2);
%     Screen('DrawLine',window,white,loc(1,1)-box*6/5,loc(1,4)+box,loc(1,3)+box*6/5,loc(1,4)+box,box/2);
    % Pre right box
%     Screen('DrawLine',window,white,loc(2,1)-box,loc(2,2)-box*6/5,loc(2,1)-box,loc(2,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(2,3)+box,loc(2,2)-box*6/5,loc(2,3)+box,loc(2,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(2,1)-box*6/5,loc(2,2)-box,loc(2,3)+box*6/5,loc(2,2)-box,box/2);
%     Screen('DrawLine',window,white,loc(2,1)-box*6/5,loc(2,4)+box,loc(2,3)+box*6/5,loc(2,4)+box,box/2);
        %end
        %Screen('Flip', window);
        vbl = Screen('Flip', window, starttime1 + 6*ifi - 0.5*ifi); % noise mask onset after 6*ifi
        Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
        Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
        Screen('Flip', window, starttime1 + 6*ifi + 2*ifi - 0.5*ifi); % soa starts: fixation onset
        %while GetSecs - starttime1 < Soatime+cuetime
            % Prep Fixation
    Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
    Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
    % Pre left box
%     Screen('DrawLine',window,white,loc(1,1)-box,loc(1,2)-box*6/5,loc(1,1)-box,loc(1,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(1,3)+box,loc(1,2)-box*6/5,loc(1,3)+box,loc(1,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(1,1)-box*6/5,loc(1,2)-box,loc(1,3)+box*6/5,loc(1,2)-box,box/2);
%     Screen('DrawLine',window,white,loc(1,1)-box*6/5,loc(1,4)+box,loc(1,3)+box*6/5,loc(1,4)+box,box/2);
    % Pre right box
%     Screen('DrawLine',window,white,loc(2,1)-box,loc(2,2)-box*6/5,loc(2,1)-box,loc(2,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(2,3)+box,loc(2,2)-box*6/5,loc(2,3)+box,loc(2,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(2,1)-box*6/5,loc(2,2)-box,loc(2,3)+box*6/5,loc(2,2)-box,box/2);
%     Screen('DrawLine',window,white,loc(2,1)-box*6/5,loc(2,4)+box,loc(2,3)+box*6/5,loc(2,4)+box,box/2);
%% column 3 is second stimulus category, column 5 is location
            if conditions(trial,3) == 1 && conditions(trial,5)== 1 % face right (if 1st left)
                % Prep for First cue %%%% face
                Screen('PutImage', window, hf4, loc(2,:));
                Screen('PutImage', window, pnoise1, loc(1,:));
                Screen('DrawingFinished', window);
%                 Screen('DrawLine',window,white,loc(1,1)-5*box,loc(1,2)-box*6/5,loc(1,1)-5*box,loc(1,4)+box*6/5,cue_w);
%                 Screen('DrawingFinished', window);
            elseif conditions(trial,3) == 1 && conditions(trial,5)== 2 % face left
                Screen('PutImage', window, hf4, loc(1,:));
                Screen('PutImage', window, pnoise1, loc(2,:));
                Screen('DrawingFinished', window);
            elseif conditions(trial,3) == 2 && conditions(trial,5)== 1 %%%% house right
                Screen('PutImage', window, hh4, loc(2,:));
                Screen('PutImage', window, pnoise1, loc(1,:));
                Screen('DrawingFinished', window);
                % Prep for First cue
%                 Screen('DrawLine',window,white,loc(2,3)+5*box,loc(2,2)-box*6/5,loc(2,3)+5*box,loc(2,4)+box*6/5,cue_w);
%                 Screen('DrawingFinished', window);
            elseif conditions(trial,3) == 2 && conditions(trial,5)== 2 % house left
                Screen('PutImage', window, hh4, loc(1,:));
                Screen('PutImage', window, pnoise1, loc(2,:));
                Screen('DrawingFinished', window);
            %end
%             if conditions(trial,4) == 1 && conditions(trial,5)==1   
%                 Screen('PutImage', window, hf, loc(1,:));
%                 Screen('DrawingFinished', window);
%             elseif conditions(trial,4) == 1 && conditions(trial,5)==2
%                 Screen('PutImage', window, hf, loc(2,:));
%                 Screen('DrawingFinished', window);
%             elseif conditions(trial,4) == 2 && conditions(trial,5)==1
%                 Screen('PutImage', window, lh, loc(1,:));
%                 Screen('DrawingFinished', window);
%             elseif conditions(trial,4) == 2 && conditions(trial,5)==2
%                 Screen('PutImage', window, lh, loc(2,:));
%                 Screen('DrawingFinished', window);
             end
%        end
        % 2nd stimulus onset time
        starttime2 = Screen('Flip', window, vbl + Soatime*ifi - 0.5*ifi);
        %Screen('Flip', window);
        %starttime2 = GetSecs;
       % Prep Fixation
    Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
    Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
    Screen('PutImage', window, pnoise1, loc(1,:));
    Screen('PutImage', window, pnoise1, loc(2,:));
    Screen('DrawingFinished', window);
    % Pre left box
%     Screen('DrawLine',window,white,loc(1,1)-box,loc(1,2)-box*6/5,loc(1,1)-box,loc(1,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(1,3)+box,loc(1,2)-box*6/5,loc(1,3)+box,loc(1,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(1,1)-box*6/5,loc(1,2)-box,loc(1,3)+box*6/5,loc(1,2)-box,box/2);
%     Screen('DrawLine',window,white,loc(1,1)-box*6/5,loc(1,4)+box,loc(1,3)+box*6/5,loc(1,4)+box,box/2);
    % Pre right box
%     Screen('DrawLine',window,white,loc(2,1)-box,loc(2,2)-box*6/5,loc(2,1)-box,loc(2,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(2,3)+box,loc(2,2)-box*6/5,loc(2,3)+box,loc(2,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(2,1)-box*6/5,loc(2,2)-box,loc(2,3)+box*6/5,loc(2,2)-box,box/2);
%     Screen('DrawLine',window,white,loc(2,1)-box*6/5,loc(2,4)+box,loc(2,3)+box*6/5,loc(2,4)+box,box/2);
                if ~DEBUG
                    while 1
                        while 1
                            pulse=IOPort('read',P4,0,1);
                            if ~isempty(pulse) && (pulse ~= 53)
                                botpress(trial,1)=pulse;
                                timepress(trial,1)=GetSecs-starttime2;
                                break
                            end
                            % if subj presses button
                            if GetSecs-starttime1>=6*ifi+Soatime*ifi+6*ifi
                                break
                            end
                        end
                        % if sub doesn't press button
                        if GetSecs-starttime1>=6*ifi+Soatime*ifi+6*ifi
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
                            if GetSecs-starttime1>=6*ifi+Soatime*ifi+6*ifi
                                break
                            end
                        end
                        if GetSecs-starttime1>=6*ifi+Soatime*ifi+6*ifi
                                break
                        end
                     end 
                end
                Screen('Flip', window); % mask onset after 6 ifi
                Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
                Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
                Screen('Flip', window, starttime2 + 6*ifi + 2*ifi - 0.5*ifi); % fixation onset after 2 ifi

                 if ~DEBUG
                    while 1
                        while 1
                            pulse=IOPort('read',P4,0,1);
                            if ~isempty(pulse) && (pulse ~= 53)
                                botpress(trial,1)=pulse;
                                timepress(trial,1)=GetSecs-starttime2;
                                break
                            end
                            if GetSecs-starttime1>=fixationtime-0.5
                                break
                            end
                        end
                        if GetSecs-starttime1>=fixationtime-0.5
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
                            if GetSecs-starttime1>=fixationtime-0.5
                                break
                            end
                        end
                        if GetSecs-starttime1>=fixationtime-0.5
                                break
                        end
                     end 
                 end
               % End of current dynamic scan prep for next trial
               presentations (trial,8) = vbl;
               presentations (trial,9) = starttime2;
               trial = trial+1;
     end
     % Prep for First Fixation
    endtime1 = GetSecs;
    % Prep Fixation
    Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
    Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
    % Pre left box
%     Screen('DrawLine',window,white,loc(1,1)-box,loc(1,2)-box*6/5,loc(1,1)-box,loc(1,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(1,3)+box,loc(1,2)-box*6/5,loc(1,3)+box,loc(1,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(1,1)-box*6/5,loc(1,2)-box,loc(1,3)+box*6/5,loc(1,2)-box,box/2);
%     Screen('DrawLine',window,white,loc(1,1)-box*6/5,loc(1,4)+box,loc(1,3)+box*6/5,loc(1,4)+box,box/2);
    % Pre right box
%     Screen('DrawLine',window,white,loc(2,1)-box,loc(2,2)-box*6/5,loc(2,1)-box,loc(2,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(2,3)+box,loc(2,2)-box*6/5,loc(2,3)+box,loc(2,4)+box*6/5,box/2);
%     Screen('DrawLine',window,white,loc(2,1)-box*6/5,loc(2,2)-box,loc(2,3)+box*6/5,loc(2,2)-box,box/2);
%     Screen('DrawLine',window,white,loc(2,1)-box*6/5,loc(2,4)+box,loc(2,3)+box*6/5,loc(2,4)+box,box/2);
    Screen('Flip', window); % Shows fixation
    while GetSecs - endtime1 < fixationtime+0.5
    end
    endtime = GetSecs;
    totalexptime = endtime - begintime;
    presentations(:, 10) = presentations(:,9)-presentations(:,8);
    presentations(:, 11) = round(presentations(:,10)/ifi);
    save(sprintf('data\\data_%s.mat', sid), 'presentations', 'botpress','timepress');    
catch ME
    display(sprintf('Error in Experiment. Please get experimenter.'));
    Priority(0);
    ShowCursor
    Screen('CloseAll');
end
ShowCursor
Screen('CloseAll');
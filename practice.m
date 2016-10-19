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
    loc(1, :) = CenterRect(facerect, screenRect) + [-mvH 0 -mvH 0];
    %loc(2, :) = CenterRect(facerect, screenRect) + [-mvH 0 -mvH 0];
    loc(2, :) = CenterRect(facerect, screenRect) + [mvH 0 mvH 0];
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
    % Pre right box
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
     while GetSecs - begintime < fixationtime % 4 s for the first fixation
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
        if conditions(trial,4) == 1 && conditions(trial,5)==1 % 4 is first face(1)/house(2); 5 is left/right   
            Screen('PutImage', window, hf4, loc(1,:));
            %Screen('PutImage', window, pnoise1, loc(1,:));
            Screen('PutImage', window, pnoise1, loc(2,:));
            Screen('DrawingFinished', window);
        elseif conditions(trial,4) == 1 && conditions(trial,5)==2
            Screen('PutImage', window, hf4, loc(2,:));
            %Screen('PutImage', window, pnoise1, loc(2,:));
            Screen('PutImage', window, pnoise1, loc(1,:));
            Screen('DrawingFinished', window);
        elseif conditions(trial,4) == 2 && conditions(trial,5)==1
            Screen('PutImage', window, hh4, loc(1,:));
            %Screen('PutImage', window, pnoise1, loc(1,:));
            Screen('PutImage', window, pnoise1, loc(2,:));
            Screen('DrawingFinished', window);
        elseif conditions(trial,4) == 2 && conditions(trial,5)==2
            Screen('PutImage', window, hh4, loc(2,:));
            %Screen('PutImage', window, pnoise1, loc(2,:));
            Screen('PutImage', window, pnoise1, loc(1,:));
            Screen('DrawingFinished', window);
        end
%         if conditions(trial,3) == 1
%             % Prep for First cue
%             Screen('DrawLine',window,white,loc(1,1)-5*box,loc(1,2)-box*6/5,loc(1,1)-5*box,loc(1,4)+box*6/5,cue_w);
%             Screen('DrawingFinished', window);
%         elseif conditions(trial,3) == 2
%             % Prep for First cue
%             Screen('DrawLine',window,white,loc(2,3)+5*box,loc(2,2)-box*6/5,loc(2,3)+5*box,loc(2,4)+box*6/5,cue_w);
%             Screen('DrawingFinished', window);
%         end
        starttime1 = GetSecs; % trial start time
        %presentations (trial,:) = [conditions(trial,:), begintime, starttime1];
        presentations (trial,1:7) = [conditions(trial,:), starttime1];
        Soatime=conditions(trial,2);
        Screen('Flip', window); % first stimulus onset
        %while GetSecs - starttime1 < cuetime % 0.1 s for the first stimuli
            % Prep Fixation
            Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
            Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
            %if conditions(trial,4) == 1 && conditions(trial,5)==1 % 4 is first face(1)/house(2); 5 is left/right
            Screen('PutImage', window, pnoise1, loc(1,:));
            Screen('PutImage', window, pnoise1, loc(2,:));
            Screen('DrawingFinished', window);
            %elseif conditions(trial,4) == 1 && conditions(trial,5)==2
%                 Screen('PutImage', window, pnoise1, loc(2,:));
%                 Screen('DrawingFinished', window);
            %elseif conditions(trial,4) == 2 && conditions(trial,5)==1
%                 Screen('PutImage', window, pnoise1, loc(1,:));
%                 Screen('DrawingFinished', window);
            %elseif conditions(trial,4) == 2 && conditions(trial,5)==2
%                 Screen('PutImage', window, pnoise1, loc(2,:));
%                 Screen('DrawingFinished', window);
            %end
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
        %vbl = Screen('Flip', window, starttime1 + 0.1);
        vbl = Screen('Flip', window, starttime1 + 6*ifi - 0.5*ifi); % noise mask onset
        Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
        Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
        Screen('Flip', window, starttime1 + 6*ifi + 2*ifi - 0.5*ifi); % soa starts
        %while GetSecs - starttime1 < Soatime+cuetime % soa seconds for fixation
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
            if conditions(trial,3) == 1 && conditions(trial,5)== 1 % col 3 is second face(1)/house(2); 5 is left/right
                % Prep for First cue %%%% face
                Screen('PutImage', window, hf4, loc(2,:));
                Screen('PutImage', window, pnoise1, loc(1,:));
                Screen('DrawingFinished', window);
                %                 Screen('DrawLine',window,white,loc(1,1)-5*box,loc(1,2)-box*6/5,loc(1,1)-5*box,loc(1,4)+box*6/5,cue_w);
                %                 Screen('DrawingFinished', window);
            elseif conditions(trial,3) == 1 && conditions(trial,5)== 2
                Screen('PutImage', window, hf4, loc(1,:));
                Screen('PutImage', window, pnoise1, loc(2,:));
                Screen('DrawingFinished', window);
            elseif conditions(trial,3) == 2 && conditions(trial,5)== 1 %%%% house
                Screen('PutImage', window, hh4, loc(2,:));
                Screen('PutImage', window, pnoise1, loc(1,:));
                Screen('DrawingFinished', window);
                % Prep for First cue
                %                 Screen('DrawLine',window,white,loc(2,3)+5*box,loc(2,2)-box*6/5,loc(2,3)+5*box,loc(2,4)+box*6/5,cue_w);
                %                 Screen('DrawingFinished', window);
            elseif conditions(trial,3) == 2 && conditions(trial,5)== 2
                Screen('PutImage', window, hh4, loc(1,:));
                Screen('PutImage', window, pnoise1, loc(2,:));
                Screen('DrawingFinished', window);
            end
            %             if conditions(trial,4) == 1 && conditions(trial,5)==1
            %             Screen('PutImage', window, hf, loc(1,:));
            %             Screen('DrawingFinished', window);
            %             elseif conditions(trial,4) == 1 && conditions(trial,5)==2
            %             Screen('PutImage', window, hf, loc(2,:));
            %             Screen('DrawingFinished', window);
            %             elseif conditions(trial,4) == 2 && conditions(trial,5)==1
            %             Screen('PutImage', window, lh, loc(1,:));
            %             Screen('DrawingFinished', window);
            %             elseif conditions(trial,4) == 2 && conditions(trial,5)==2
            %             Screen('PutImage', window, lh, loc(2,:));
            %             Screen('DrawingFinished', window);
            %             end
        %end
        % 2nd stimulus onset time
        starttime2 = Screen('Flip', window, vbl + Soatime*ifi - 0.5*ifi);
        %starttime2 = GetSecs; 
       % Prep Fixation
    Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
    Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
    %if conditions(trial,4) == 1 && conditions(trial,5)==1 % 4 is first face(1)/house(2); 5 is left/right
    Screen('PutImage', window, pnoise1, loc(1,:));
    Screen('PutImage', window, pnoise1, loc(2,:));
    Screen('DrawingFinished', window);
    %elseif conditions(trial,4) == 1 && conditions(trial,5)==2
%         Screen('PutImage', window, pnoise1, loc(1,:));
%         Screen('DrawingFinished', window);
    %elseif conditions(trial,4) == 2 && conditions(trial,5)==1
%         Screen('PutImage', window, pnoise1, loc(2,:));
%         Screen('DrawingFinished', window);
    %elseif conditions(trial,4) == 2 && conditions(trial,5)==2
%         Screen('PutImage', window, pnoise1, loc(1,:));
%         Screen('DrawingFinished', window);
    %end
%     Screen('Flip', window, starttime2 + 0.1);

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
                            if GetSecs-starttime1>=6*ifi+Soatime*ifi+6*ifi % targettime seconds for the 2nd stimulus
                                break
                            end
                        end
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
                Screen('Flip', window); % Hides image/shows fixation
                Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
                Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
                Screen('Flip', window, starttime2 + 6*ifi + 2*ifi - 0.5*ifi);

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
                            if GetSecs-starttime1>=fixationtime-0.5 % w
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
     % Prep for last Fixation
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
    %save(sprintf('data\\data_%s.mat', sid), 'presentations', 'botpress','timepress');    
catch ME
    display(sprintf('Error in Experiment. Please get experimenter.'));
    Priority(0);
    ShowCursor
    Screen('CloseAll');
end
ShowCursor
Screen('CloseAll');
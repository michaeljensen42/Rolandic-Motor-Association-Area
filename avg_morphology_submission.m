function avg_morphology_submission(beh, srate, BB, channel)

hand_start = [];
tongue_start= [];
foot_start = [];

for n=1:length(beh)
    if beh(n) == 1 && beh(n)~=beh(n-1)
        hand_start = [hand_start n];
    elseif beh(n) == 3 && beh(n)~=beh(n-1)
        foot_start = [foot_start n];
    elseif beh(n) == 2 && beh(n)~=beh(n-1)
        tongue_start = [tongue_start n];
    end
end

%% getting averages for all
% hand BB average shape
    % if you wish to plot all trials neural activity 
        for n = 1:length(hand_start)
            hmvnt_BB(n,:) = BB((hand_start(n)-0.5*srate):(hand_start(n)+4*srate));
        end

    % plotting average 
    h_avg = (sum(hmvnt_BB))/(size(hmvnt_BB,1));

% foot BB average shape
    % if you wish to plot all trials neural activity 
        for n = 1:length(foot_start)
            fmvnt_BB(n,:) = BB((foot_start(n)-0.5*srate):(foot_start(n)+4*srate));
        end
    
    % plotting average 
    f_avg = (sum(fmvnt_BB))/(size(fmvnt_BB,1));

% tongue BB average shape
    % if you wish to plot all trials neural activity 
        for n = 1:length(tongue_start)
            tmvnt_BB(n,:) = BB((tongue_start(n)-0.5*srate):(tongue_start(n)+4*srate));
        end
    
    % plotting average 
    t_avg = (sum(tmvnt_BB))/(size(tmvnt_BB,1));
    
if channel == 1
    %% hand
    % plotting all to check, if desired
    %     figure
    %     for n = 1:size(hmvnt_BB,1) 
    %         hold on, plot(hmvnt_BB(n,:)) 
    %     end
    
    %selective plot
    figure, plot(h_avg); box off; title('avg peri-movement sel for hand'); xline(0.5*srate); xline(3.5*srate)
    
elseif channel == 2
    %% tongue    
    %plotting all to check, if desired
    %         figure
    %         for n = 1:size(tmvnt_BB,1) 
    %             hold on, plot(tmvnt_BB(n,:)) 
    %         end
    
    %selective plot
    figure, plot(t_avg); box off; title('avg peri-movement sel for tongue'); xline(0.5*srate); xline(3.5*srate)
    
elseif channel == 3
    %% foot    
    %plotting all to check, if desired
    %     figure
    %     for n = 1:size(fmvnt_BB,1) 
    %         hold on, plot(fmvnt_BB(n,:)) 
    %     end
    
    % selective plot
    figure, plot(f_avg); box off; title('avg peri-movement sel for foot'); xline(0.5*srate); xline(3.5*srate)

elseif channel == 4
    
    %RMA plot
    figure, plot(h_avg); box off; title('avg peri-movement RMA for hand'); xline(0.5*srate); xline(3.5*srate)

    %RMA plot for tongue
    figure, plot(t_avg); box off; title('avg peri-movement RMA for tongue'); xline(0.5*srate); xline(3.5*srate)

    %RMA plot for foot
    figure, plot(f_avg); box off; title('avg peri-movement RMA for foot'); xline(0.5*srate); xline(3.5*srate)

end
end

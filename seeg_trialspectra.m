function [ps, mps, nps,f,tr_sc]=seeg_trialspectra(data,stim,srate)
%% catalogue trials
    trialnr=0*stim; tr_sc=0; %initialize
    trtemp=1; 
    trialnr(1)=trtemp; %start variable
    for n=2:length(stim)
        if stim(n)~=stim(n-1)
            trtemp=trtemp+1; tr_sc=[tr_sc stim(n)];
        end
        trialnr(n)=trtemp;
    end
    clear n trtemp
    trials=unique(trialnr);

%% determine if trials are too short

figure;
lengthtrial = [];
for k = 1:length(trials)
    plot(k, length(find(trialnr == k)), 'ko')
    lengthtrial = [lengthtrial; length(find(trialnr == k))];
    hold on;
end 

%nullify if any epochs are < 2 seconds so that these aren't taken into account for stats 
tr_sc(find(lengthtrial < 2400)) = -1;

    
%% calculate power spectra - for simple blocks, no locking to stimulation with specific windows yet
    disp('calculating power spectra')
    num_chans=size(data,2);
    f=1:300; % frequencies
    
    win_fxn=hann(srate); % windowing function
    noverlap=floor(srate/2); %overlap between calculations
    %win_fxn=hann(srate/2); % windowing function
    %noverlap=floor(srate/4); %overlap between calculations

    ps=[]; mps=[];
    for chan=1:num_chans    
        [mps(chan,:),f] = pwelch(data(:,chan),win_fxn,noverlap,f,srate); % mean power spectrum across whole experiment
    for curr_trial=1:max(trials) %calculate spectra for each trial
        curr_data=data(find(trialnr==curr_trial),chan);
        if length(curr_data)<(length(win_fxn)) % zero pad to window size if needed
            curr_data=[curr_data; zeros(length(win_fxn)-length(curr_data),1)];
            %curr_data = nan(1, length(curr_data));
        end   
%         if any(curr_data) == nan
%             ps(chan,:,curr_trial) = nan;
%             nps(chan,:,curr_trial)= nan;
%         else
        [ps(chan,:,curr_trial),f] = pwelch(curr_data,win_fxn,noverlap,f,srate); % single trial power spectra
        nps(chan,:,curr_trial)=ps(chan,:,curr_trial)./mps(chan,:); % normalized single trial power spectra
        
    end
    end
    
    % normalize power spectral densities
%     ps_mean=mean(ps(:,ccep_p>0),2);

    clear noverlap win_fxn ps_window curr_trial chan
end
%% determine if trials are too short

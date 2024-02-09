function maj_bb_submission_selective_chans(data, srate, chno, stim, beh, ss, emg)

% data = re-referenced data from experiment, double
% srate is the sampling rate of amplifier during experiment
% chno vector of channels of which one should take BB of; double; e.g. [123 87 75 45]
    % this is in README document as cross correlation channels
% ss is the samples used during the smoothing process
% stim is the vector of stim codes corresponding to each channel number in order 1234
	 %overlap channels should include all 3 stim; e.g. [1 2 3 4] where 4 = RMA, 1,2,3 = Hand,Tongue,Foot
% emg is the emg used for segmentation loaded in emg_seg variable

%%  set up pt code, whether to save, and the channels to take cross product of 

pt_task = 'emg-sel';

prompt2 = 'movement type:';
sel = input(prompt2);

if length(stim) ~= length(chno), error('channel and stim lengths do not correspond'), end
     
if nargin < 9 
    frange = [65 75;75 85;85 95;95 105;105 115];
end

disp('working on it...')

%% extract normalized power, smoothed power, average power across trial types and the raw power immediately after Hilbert wrap into powers struct

    [filtemg] = get_smooth_z_emg_v3(emg, beh, ss, srate);
    [powers] = get_smooth_z_bb_v6(data, srate, chno, beh, ss, frange);


%% average peri-movement plots 

if strcmp(pt_task,'emg-bb')
    avg_morphology_submission(beh, srate,  powers.BB(4,:), 4)
end 

if strcmp(pt_task,'emg-sel')
    avg_morphology_submission(beh, srate,  powers.BB(sel,:), sel)
end 

%% sliding dot product (manual xcorr)

if strcmp(pt_task,'emg-bb')
BBo = powers.BB(4,:);
else 
BBo = powers.BB(sel,:);
end

    % RMA channel and emg dot product 
    if strcmp(pt_task,'emg-bb')
        for chan = 1:3
            if contains(pt_task, 'emg')
            BBs = filtemg(chan,:); 
            else
            BBs = powers.BB(chan,:);
            end
    
            [~, truePeak,] = maj_BB_slidingDot_v1(BBs, BBo, srate, chan);
    
            truePeaks(chan, 1) = truePeak;
        
        end
    end

    % selective channel and emg dot product
    if strcmp(pt_task,'emg-sel')
        chan = sel;
        if contains(pt_task, 'emg')
        BBs = filtemg(chan,:); 
        else
        BBs = powers.BB(chan,:);
        end
        [~, truePeak] = maj_BB_slidingDot_v1(BBs, BBo, srate, chan);

        truePeaks(chan, 1) = truePeak;
    end

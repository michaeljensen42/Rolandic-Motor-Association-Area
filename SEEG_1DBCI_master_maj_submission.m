function []=SEEG_1DBCI_master_maj_submission

% visualization is a huge problem for SEEG
% family of canonical views to examine motor network (to be processed and extracted from images for each patient)
% axial, coronal, sagittal, volume-averaged 
% assure that directory is set to the RMA_toolbox folder
pt = 'ROR'; % set up paitent 3-letter code
pt_task = 'mot'; % set up task ('mot' for all subjects)
addpath('./data') % add path to data

%% load motor bipolar re-referenced data from patient    
    
    load(['data/' pt filesep pt '_' pt_task])
    
%% load brain volume and  for plotting code 

    load(['data/' pt filesep pt '_brain'])

%% load EMG timeseries and EMG start and stop indices
    
    load(['data/' filesep pt filesep pt '_emg_seg'])

%% calculate trial-by-trial spectra

   [psds_dp.ps, psds_dp.mps, psds_dp.nps,psds_dp.f,psds_dp.tr_sc]=seeg_trialspectra(dp_data, beh, srate);  

%% statistics using normalized power spectra to generate r^2 values

   [rvals] =seegmot_stats_submission(psds_dp.nps,psds_dp.f,psds_dp.tr_sc); 

%% plotting significant channels for hand tongue and foot; plotting seletive and shared channels on native patients brain

   SEEG_brainplot_submission(pt,pt_task, dp_locs, rvals)

%% plotting power spectra for significant channels
    % keep in mind all r^2 values with pvalues < 0.01 and rvals > 0.40 are plotted
    
   %handplot_work_submission

%% time series analysis and average morphology for selective channels (if present) and RMA channel
   
    %smoothing_window = 600; %500ms smoothing window at 1200 srate

    % HTFR is the input channels of interest as 'hand' 'tongue' 'foot' 'RMA' vector.
        % e.g. maj_bb_master_v4(dp_data, srate, HTFR, [1 2 3 4], beh, smoothing_window, display_emg)
        % these are input below as best selective and RMA channels were selected for analysis
        % in case there are not selective channels for hand tongue or foot, placeholders HTFR inputs are made and indices of those in the HTFR vector are noted as "placeholder" comment
        % only carried out for subjects with high-fidelity data (1-11)

switch pt 

    case 'ROR' % placeholder: 2 3
        HTFR = [101 1 2 66];

    case 'NMB' % placeholder: 
        HTFR = [25 156 1 10];

    case 'MNY-L' % placeholder: 2
        HTFR = [67 1 17 95];

    case 'MNY-R' % placeholder: 1 2
        HTFR = [1 2 106 95];

    case 'TOS' % placeholder: 3
        HTFR = [60 44 1 56];

    case 'DIS' % placeholder:
        HTFR = [113 85 37 21];

    case 'MOM' % placeholder: 2
        HTFR = [138 1 104 135];

    case 'BRB' % placeholder: 3
        HTFR = [35 81 1 32];

    case 'JBG' % placeholder: 1 2 3
        HTFR = [1 2 3 119];

    case 'TYL' % placeholder: 2
        HTFR = [92 1 135 61];

    case 'WFR' % placeholder: 1 2 3
        HTFR = [1 2 3 73];

    case 'POC' % placeholder: 3
        HTFR = [64 85 1 31];
end
        
        % cross correlation and average neural activity for RMA channel
        maj_bb_submission_RMA(dp_data, srate, HTFR, [1 2 3 4], beh, smoothing_window, display_emg)

        % cross correlation and average neural activity for selective channels
            % when prompted 'movement type:', input stimcode corresponding to movement of interest (1 = hand, 2 = tongue, 3 = foot)
            % run this for each movement type of interest
        maj_bb_submission_selective_chans(dp_data, srate, HTFR, [1 2 3 4], beh, smoothing_window, display_emg)

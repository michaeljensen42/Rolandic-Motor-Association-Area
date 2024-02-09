function [filtemg] = get_smooth_z_emg_v3(display_emg, beh, ss, srate)

% Purpose: to obtain the logpower, z-scored, and re-exponentiated of the broadband power

    % data = double samples x 1 time series
    % srate = sample rate from exp
    % frange = 1D vector of frequency ranges, can be chunked e.g. [65 75;75 85;85 95;95 105]
    % chno = channel number from which we are taking power
    % chname = channel name from which we are taking power
    % smooth = samples to smooth across
    % beh = emg based time segmentation

    intertrial = beh == -1; % set all invalid data to the mean of the power to nullify
    filtemg = zeros(3, size(display_emg,1));

    for n = 1:3

      if n == 1, modality = 'hand'; 
          elseif n == 2, modality = 'tongue'; 
          elseif n == 3, modality = 'foot'; 
      end
 
    
    time = (1:71:length(display_emg))/srate;
    startdata = (display_emg(:,n));
    startdata(1:srate) = mean(startdata); % set artifact at beggining to mean
    startdata(end-srate:end) = mean(startdata); % set artifact at end to mean
    startdata(189.5*srate:190.5*srate) = mean(startdata); % set artifact at end to mean
    startdata = abs(startdata); % rectify
    
    %% Absolut EMG
    abslogemg = log(startdata);

    abslogemg(beh == -1) = 0;
    abslogemg(1:3*srate) = 0;
    abslogemg(end-3*srate:end) = 0;
    
%     figure, plot(time, abslogemg(1:71:end)), title('logged EMG'); box off
%     kjm_printfig(['figs/' pt '/' pt sprintf('_loggedEMG_%s',modality)],10*[3 2])
    
    %% z-score
    Z = (abslogemg-mean(abslogemg))/std(abslogemg);

    Z(beh == -1) = 0;
    Z(1:3*srate) = 0;
    Z(end-3*srate:end) = 0;
    
%     figure, plot(time, Z(1:71:end)), title('Z-emg'); box off
%     kjm_printfig(['figs/' pt '/' pt sprintf('_Z_EMG_%s',modality)],10*[3 2])
    
    %% smooth
    
    Z(beh == -1) = 0;
    Z(1:3*srate) = 0;
    Z(end-3*srate:end) = 0;
    
    sdata = smooth(Z, ss);
%     figure, plot(time, sdata(1:71:end)), title('smoothEMG'); box off
%     kjm_printfig(['figs/' pt '/' pt sprintf('_smoothEMG_%s',modality)],10*[3 2])
    
    %% exponentiate
    EMGpre = exp(sdata);

    EMGpre(beh == -1) = 0;
    EMGpre(1:3*srate) = 0;
    EMGpre(end-3*srate:end) = 0;
    
%     figure, plot(time, EMGpre(1:71:end)), title('exponentiated'); box off
%     kjm_printfig(['figs/' pt '/' pt sprintf('_exponentiatedEMG_%s',modality)],10*[3 2])

    filtemg(n, :) = EMGpre;
    
    end


end
function [powers] = get_smooth_z_bb_v6(data, srate, chno, beh, ss, frange)

% Purpose: to obtain the logpower, z-scored, and re-exponentiated of the broadband power

    % data = double samples x 1 time series
    % srate = sample rate from exp
    % frange = 1D vector of frequency ranges, can be chunked e.g. [65 75;75 85;85 95;95 105]
    % chno = channel number from which we are taking power
    % chname = channel name from which we are taking power
    % smooth = samples to smooth across
    % beh = emg based time segmentation

%% extract power using Hilbert
[startpower, ~] = ieeg_getHilbert(data(:,chno), frange, srate, 'power');

intertrial = beh == -1; % set all invalid data to the mean of the power to nullify

for ch = 1:4
modality = ch;

if modality == 1, modality = 'hand'; 
  elseif modality == 2, modality = 'tongue'; 
  elseif modality == 3, modality = 'foot'; 
  elseif modality == 4, modality = 'overlap'; 
end

time = (1:100:length(data))/srate;

%% sEEG signal for figure 
%figure, plot(time, dp_data(1:100:end, chno)), title('raw voltage'); box off
%kjm_printfig(['figs/' pt '/' pt sprintf('_raw_signal_%s',modality)],10*[3 2])

%% Square of the magnitude of the Hilbert Transform 
power = startpower(:,ch);

power(189.5*srate:190.5*srate) = mean(power);
power(1:3*srate) = mean(power);
power(end-3*srate:end) = mean(power);

%figure, plot(time, power(1:100:end)), title('power'); box off
%kjm_printfig(['figs/' pt '/' pt sprintf('_power_%s',modality)],10*[3 2])

%% Log of hilbert power 

logpower = log(power);
%figure, plot(time, logpower(1:100:end)), title('log of raw power'); box off
%kjm_printfig(['figs/' pt '/' pt sprintf('_logged_raw_power_%s',modality)],10*[3 2])
 
%% z-score
Z = (logpower-mean(logpower))/std(logpower);

%figure, plot(time, Z(1:100:end)), title('z-scored power'); box off
% kjm_printfig(['figs/' pt '/' pt sprintf('_Z_power_%s',modality)],10*[3 2])

%% smooth
spower = smooth(Z, ss);

power(189.5*srate:190.5*srate) = 0;
power(1:3*srate) = 0;
power(end-3*srate:end) = 0;

%figure, plot(time, spower(1:100:end)), title('smoothed z-scored power at 500ms'); box off
% kjm_printfig(['figs/' pt '/' pt sprintf('_smoothZ_power_500ms_%s',modality)],10*[3 2])

%% exponentiate
BB = exp(spower) - 1;

%figure, plot(time, BBpre(1:100:end)), title('exponentiated smoothed z-scored power'); box off
%kjm_printfig(['figs/' pt '/' pt sprintf('_exp_smoothZ_power_%s',modality)],10*[3 2])

%% remove artifact 
BB(189.5*srate:190.5*srate) = 0;
BB(1:1*srate) = 0;
BB(end-1*srate:end) = 0;

%figure, plot(time, BB(1:100:end)), title('remove artifact'); box off
%kjm_printfig(['figs/' pt '/' pt sprintf('_final_product_%s',modality)],10*[3 2])

%% wrap into struct

powers.BB(ch,:) = BB';
powers.stim = [1 2 3 4];
powers.chno = chno;

end
end







function [timelag, cpPeak, modality] = maj_BB_slidingDot_v1(BBs, BBo, srate, modality)
%% Dot product
cpsize = 4; %2 sec before and after onset of movement 

b = BBs(1, ((cpsize/2 * srate + 1):(end - cpsize/2 * srate))); %eliminate 1/2 sliding window size from each end of BBs - stationary signal

for k = 1: cpsize * srate
    cp(k) = dot(BBo(k + 1:end - (cpsize * srate) + k), b); %take dot product of BBs -stationary- and BBo -sliding - for all sliding windows
end

timelag = (find(cp == max(cp)) - (size(cp,2)/2))/1.2;
cpPeak = max(cp);

%% Plotting cross correlation latency plot
   
figure; plot(cp); 
  title(sprintf('Stimcode:%d Timelag: %.2fms' , modality, timelag));
  set(gca, 'XTick', [0:srate/2:cpsize*srate]); 
  xticklabels({'-2', '-1.5', '-1', '-0.5', '0', '0.5', '1', '1.5', '2'}); hold on; 
  xline(find(cp == max(cp)), '--r'); 
  xline(length(cp)/2); ylabel('overalp arb. units');
  xlabel('Latency(s)'); 
  set(gca, FontSize = 28);
  box off;
      
  if modality == 1, modality = 'hand';, 
  elseif modality == 2, modality = 'tongue';, 
  elseif modality == 3, modality = 'foot'; 
  end
 

end
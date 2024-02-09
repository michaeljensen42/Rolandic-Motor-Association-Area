
pthresh = 0.01;

%% plot PSD for significant hand channels
a=find((rvals.p_hand_HFB<.01) & (rvals.r_hand_HFB>0.4))  ;
for k=a
figure, 
%semilogy(psds_dp.mps(k,:),'k'), hold on
semilogy(mean(psds_dp.ps(k,:,find(psds_dp.tr_sc==0)),3),'b'), hold on
semilogy(mean(psds_dp.ps(k,:,find(psds_dp.tr_sc==1)),3),'r'), hold on
title([sprintf('Channel %d', k)  ' - hand, r^2=' num2str(rvals.r_hand_HFB(k))  ', p=' num2str(rvals.p_hand_HFB(k))])
end

%% plot PSD for significant tongue channels
a=find((rvals.p_tongue_HFB<.01) & (rvals.r_tongue_HFB>0.4)) ;
for k=a
figure, 
%semilogy(mps(k,:),'k'), hold on
semilogy(mean(psds_dp.ps(k,:,find(psds_dp.tr_sc==0)),3),'b'), hold on
semilogy(mean(psds_dp.ps(k,:,find(psds_dp.tr_sc==2)),3),'r'), hold on
title([sprintf('Channel %d', k)  ' - tongue, r^2=' num2str(rvals.r_tongue_HFB(k))  ', p=' num2str(rvals.p_tongue_HFB(k))])
end

%% plot PSD for significant foot channels
a=find((rvals.p_foot_HFB<.01) & (rvals.r_foot_HFB>0.4));
for k=a
figure, 
%semilogy(mps(k,:),'k'), hold on
semilogy(mean(psds_dp.ps(k,:,find(psds_dp.tr_sc==0)),3),'b'), hold on
semilogy(mean(psds_dp.ps(k,:,find(psds_dp.tr_sc==3)),3),'r'), hold on
title([sprintf('Channel %d', k)  ' - foot, r^2=' num2str(rvals.r_foot_HFB(k))  ', p=' num2str(rvals.p_foot_HFB(k))])
end



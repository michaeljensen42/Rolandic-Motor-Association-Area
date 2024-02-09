function [rvals] = seegmot_stats_submission(nps,f,tr_sc)


%%
    HFB_range=[65:115];
    LFB_range=[8:32];

%%
    num_chans=size(nps,1);
    HFB_trials=squeeze(mean(nps(:,HFB_range,:),2));
    LFB_trials=squeeze(mean(nps(:,LFB_range,:),2));

%% find rest conditions specific to behavior that preceded them
    tr_sc(find(and(tr_sc==0,[0 tr_sc(1:(end-1))]==1)))=10; % rest after hand block
    tr_sc(find(and(tr_sc==0,[0 tr_sc(1:(end-1))]==2)))=20; % rest after tongue block
    tr_sc(find(and(tr_sc==0,[0 tr_sc(1:(end-1))]==3)))=30; % rest after tongue block


%% comparisons - signed r-squared and unpaired t-test
for chan=1:num_chans
    % hand (tr_sc==1)        
        r_hand_HFB(chan)=rsa(HFB_trials(chan,find(tr_sc==1)),HFB_trials(chan,find(tr_sc==10)));
        r_hand_LFB(chan)= rsa(LFB_trials(chan, find(tr_sc==1)), LFB_trials(chan,find(tr_sc==10)));   
        [temp, p_hand_HFB(chan)]=ttest2(HFB_trials(chan,find(tr_sc==1)),HFB_trials(chan,find(tr_sc==10)));
        [temp, p_hand_LFB(chan)]= ttest2(LFB_trials(chan,find(tr_sc==1)), LFB_trials(chan, find(tr_sc==10))); 

    %tongue (tr_sc==2)        
        r_tongue_HFB(chan)=rsa(HFB_trials(chan,find(tr_sc==2)),HFB_trials(chan,find(tr_sc==20)));
        r_tongue_LFB(chan)= rsa(LFB_trials(chan, find(tr_sc==2)), LFB_trials(chan,find(tr_sc==20)));        
        [~, p_tongue_HFB(chan)]=ttest2(HFB_trials(chan,find(tr_sc==2)),HFB_trials(chan,find(tr_sc==20)));
        [~, p_tongue_LFB(chan)]= ttest2(LFB_trials(chan,find(tr_sc==2)), LFB_trials(chan, find(tr_sc==20)));  

    % foot (tr_sc==3)        
        r_foot_HFB(chan)=rsa(HFB_trials(chan,find(tr_sc==3)),HFB_trials(chan,find(tr_sc==30)));
        r_foot_LFB(chan)= rsa(LFB_trials(chan, find(tr_sc==3)), LFB_trials(chan,find(tr_sc==30)));        
        [~, p_foot_HFB(chan)]=ttest2(HFB_trials(chan,find(tr_sc==3)),HFB_trials(chan,find(tr_sc==30)));
        [~, p_foot_LFB(chan)]= ttest2(LFB_trials(chan,find(tr_sc==3)), LFB_trials(chan, find(tr_sc==30)));          

    % hand vs tongue
        r_HvsT_HFB(chan)=rsa(HFB_trials(chan,find(tr_sc==1)),HFB_trials(chan,find(tr_sc==2)));    
        r_HvsT_LFB(chan)=rsa(LFB_trials(chan,find(tr_sc==1)),LFB_trials(chan,find(tr_sc==2)));    
        [~, p_HvsT_HFB(chan)]=ttest2(HFB_trials(chan,find(tr_sc==1)),HFB_trials(chan,find(tr_sc==2)));
        [~, p_HvsT_LFB(chan)]= ttest2(LFB_trials(chan,find(tr_sc==1)), LFB_trials(chan, find(tr_sc==2)));  
        
    % hand vs foot
        r_HvsF_HFB(chan)=rsa(HFB_trials(chan,find(tr_sc==1)),HFB_trials(chan,find(tr_sc==3)));    
        r_HvsF_LFB(chan)=rsa(LFB_trials(chan,find(tr_sc==1)),LFB_trials(chan,find(tr_sc==3)));    
        [~, p_HvsF_HFB(chan)]=ttest2(HFB_trials(chan,find(tr_sc==1)),HFB_trials(chan,find(tr_sc==3)));
        [~, p_HvsF_LFB(chan)]= ttest2(LFB_trials(chan,find(tr_sc==1)), LFB_trials(chan, find(tr_sc==3)));  
        
    % tongue vs foot
        r_TvsF_HFB(chan)=rsa(HFB_trials(chan,find(tr_sc==2)),HFB_trials(chan,find(tr_sc==3)));    
        r_TvsF_LFB(chan)=rsa(LFB_trials(chan,find(tr_sc==2)),LFB_trials(chan,find(tr_sc==3)));    
        [~, p_TvsF_HFB(chan)]=ttest2(HFB_trials(chan,find(tr_sc==2)),HFB_trials(chan,find(tr_sc==3)));
        [~, p_TvsF_LFB(chan)]= ttest2(LFB_trials(chan,find(tr_sc==2)), LFB_trials(chan, find(tr_sc==3)));  

end 
disp('hi')

%% wrap into a structure
    rvals.HFB_range=HFB_range;
    rvals.LFB_range=LFB_range;
    
    rvals.HFB_trials=HFB_trials;
    rvals.LFB_trials=LFB_trials;
    
    rvals.r_hand_HFB=r_hand_HFB;
    rvals.r_hand_LFB=r_hand_LFB;
    rvals.p_hand_HFB=p_hand_HFB;
    rvals.p_hand_LFB=p_hand_LFB;
    
    rvals.r_tongue_HFB=r_tongue_HFB;
    rvals.r_tongue_LFB=r_tongue_LFB;
    rvals.p_tongue_HFB=p_tongue_HFB;
    rvals.p_tongue_LFB=p_tongue_LFB;
    
    rvals.r_foot_HFB=r_foot_HFB;
    rvals.r_foot_LFB=r_foot_LFB;
    rvals.p_foot_HFB=p_foot_HFB;
    rvals.p_foot_LFB=p_foot_LFB;
    %
    rvals.r_HvsT_HFB=r_HvsT_HFB;
    rvals.r_HvsT_LFB=r_HvsT_LFB;
    rvals.p_HvsT_HFB=p_HvsT_HFB;
    rvals.p_HvsT_LFB=p_HvsT_LFB;
    %
    rvals.r_HvsF_HFB=r_HvsF_HFB;
    rvals.r_HvsF_LFB=r_HvsF_LFB;
    rvals.p_HvsF_HFB=p_HvsF_HFB;
    rvals.p_HvsF_LFB=p_HvsF_LFB;
    %
    rvals.r_TvsF_HFB=r_TvsF_HFB;
    rvals.r_TvsF_LFB=r_TvsF_LFB;
    rvals.p_TvsF_HFB=p_TvsF_HFB;
    rvals.p_TvsF_LFB=p_TvsF_LFB;
    

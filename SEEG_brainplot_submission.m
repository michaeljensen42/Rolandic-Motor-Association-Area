function SEEG_brainplot_submission(pt,pt_task, dp_locs, rvals)

%% save figs?

    figsave = 'n';

%% load brains, segmentation, and data
    
    pt_task = 'mot';
    load(['data/' pt filesep pt '_' pt_task])
    load(['data/' pt filesep pt '_brain'])
    load(['data/' pt filesep pt '_emg_seg'])

%% set parameters for slice plots and rendering angles 

    slicethickness = 10; % thickness of each plotted slice, in mm
    mr_clims=[0 1.1]; % adjusts brightness of plots
    pthresh= 0.05; % defines which rvals are significant
    threshFrac = 0.01; % abs(values) below threshFrac*wmaximum weight are not plotted with color

%% Plot slice of brain image with weighted, unlabelled electrodes

    wts = rvals.r_foot_HFB.*(rvals.p_foot_HFB<pthresh); % set weights F
    [x_slice, y_slice, z_slice] = seegview_sliceplot(dp_locs, bvol, x, y, z, slicethickness,mr_clims);
    sv_weight_add(dp_locs, wts, x_slice, threshFrac); set(gcf,'Name',[pt ' foot ' pt_task ', sagittal, slice thickness ' num2str(slicethickness) 'mm']);
    sv_weight_add(dp_locs, wts, y_slice, threshFrac); set(gcf,'Name',[pt ' foot ' pt_task ', coronal, slice thickness ' num2str(slicethickness) 'mm']);
    sv_weight_add(dp_locs, wts, z_slice, threshFrac); set(gcf,'Name',[pt ' foot ' pt_task ', axial, slice thickness ' num2str(slicethickness) 'mm']);
    
    if figsave=='y'
     axes(x_slice.ha(1)); kjm_printfig(['data/' pt '/' pt '_foot_2_sec_nobon_' pt_task '_sag_' num2str(slicethickness) 'mm'],10*[3 2]) 
     axes(y_slice.ha(1)); kjm_printfig(['data/' pt '/' pt '_foot_2_sec_nobon_' pt_task '_cor_' num2str(slicethickness) 'mm'],10*[3 2]) 
     axes(z_slice.ha(1)); kjm_printfig(['data/' pt '/' pt '_foot_2_sec_nobon_' pt_task '_ax_' num2str(slicethickness) 'mm'],10*[3 2]) 
    end

    wts = rvals.r_hand_HFB.*(rvals.p_hand_HFB<pthresh); %set weights H
    [x_slice, y_slice, z_slice] = seegview_sliceplot(dp_locs, bvol, x, y, z, slicethickness,mr_clims);
    sv_weight_add(dp_locs, wts, x_slice, threshFrac); set(gcf,'Name',[pt ' hand ' pt_task ', sagittal, slice thickness ' num2str(slicethickness) 'mm']);
    sv_weight_add(dp_locs, wts, y_slice, threshFrac); set(gcf,'Name',[pt ' hand ' pt_task ', coronal, slice thickness ' num2str(slicethickness) 'mm']);
    sv_weight_add(dp_locs, wts, z_slice, threshFrac); set(gcf,'Name',[pt ' hand ' pt_task ', axial, slice thickness ' num2str(slicethickness) 'mm']);

    if figsave=='y'
     axes(x_slice.ha(1)); kjm_printfig(['data/' pt '/' pt '_hand_2_sec_nobon_' pt_task '_sag_' num2str(slicethickness) 'mm'],10*[3 2]) 
     axes(y_slice.ha(1)); kjm_printfig(['data/' pt '/' pt '_hand_2_sec_nobon_' pt_task '_cor_' num2str(slicethickness) 'mm'],10*[3 2]) 
     axes(z_slice.ha(1)); kjm_printfig(['data/' pt '/' pt '_hand_2_sec_nobon_' pt_task '_ax_' num2str(slicethickness) 'mm'],10*[3 2]) 
    end

    wts = rvals.r_tongue_HFB.*(rvals.p_tongue_HFB<pthresh); %set weights T
    [x_slice, y_slice, z_slice] = seegview_sliceplot(dp_locs, bvol, x, y, z, slicethickness,mr_clims);
    sv_weight_add(dp_locs, wts, x_slice, threshFrac); set(gcf,'Name',[pt ' tongue ' pt_task ', sagittal, slice thickness ' num2str(slicethickness) 'mm']);
    sv_weight_add(dp_locs, wts, y_slice, threshFrac); set(gcf,'Name',[pt ' tongue ' pt_task ', coronal, slice thickness ' num2str(slicethickness) 'mm']);
    sv_weight_add(dp_locs, wts, z_slice, threshFrac); set(gcf,'Name',[pt ' tongue ' pt_task ', axial, slice thickness ' num2str(slicethickness) 'mm']);

    if figsave=='y'
        axes(x_slice.ha(1)); kjm_printfig(['data/' pt '/' pt '_tongue_2_sec_nobon_' pt_task '_sag_' num2str(slicethickness) 'mm'],10*[3 2]) 
        axes(y_slice.ha(1)); kjm_printfig(['data/' pt '/' pt '_tongue_2_sec_nobon_' pt_task '_cor_' num2str(slicethickness) 'mm'],10*[3 2]) 
        axes(z_slice.ha(1)); kjm_printfig(['data/' pt '/' pt '_tongue_2_sec_nobon_' pt_task '_ax_' num2str(slicethickness) 'mm'],10*[3 2]) 
    end
    %% Setting overlap weights 
    
    for k = 1:length(rvals.r_hand_HFB) % only plot channels with increase in power at each modality, set all channels to zero if r^2 < 0
    if rvals.r_hand_HFB(k) < 0, rvals.r_hand_HFB(k) = 0;end
    if rvals.r_tongue_HFB(k) < 0, rvals.r_tongue_HFB(k)  = 0;end
    if rvals.r_foot_HFB(k) < 0, rvals.r_foot_HFB(k) = 0; end
    end 
    
    wts_overlap = (rvals.r_hand_HFB .* rvals.r_tongue_HFB .* rvals.r_foot_HFB).^(1/3);

%% Plotting overlapping elecs for HTF

    [x_slice, y_slice, z_slice] = seegview_sliceplot(dp_locs, bvol, x, y, z, slicethickness,mr_clims);
    sv_weight_add_overlap(dp_locs, wts_overlap, x_slice, threshFrac); set(gcf,'Name',[pt ' shared ' pt_task ', sagittal, slice thickness ' num2str(slicethickness) 'mm']);
    sv_weight_add_overlap(dp_locs, wts_overlap, y_slice, threshFrac); set(gcf,'Name',[pt ' shared ' pt_task ', coronal, slice thickness ' num2str(slicethickness) 'mm']);
    sv_weight_add_overlap(dp_locs, wts_overlap, z_slice, threshFrac); set(gcf,'Name',[pt ' shared ' pt_task ', axial, slice thickness ' num2str(slicethickness) 'mm']);

     if figsave=='y'
         axes(x_slice.ha(1)); kjm_printfig(['data/' pt '/' pt '_overlap_no_cutoff_minsize_0.5msize_' pt_task '_sag_' num2str(slicethickness) 'mm'],10*[3 2]) 
         axes(y_slice.ha(1)); kjm_printfig(['data/' pt '/' pt '_overlap_no_cutoff_minsize_0.5msize_Fig3' pt_task '_cor_' num2str(slicethickness) 'mm'],10*[3 2]) 
         axes(z_slice.ha(1)); kjm_printfig(['data/' pt '/' pt '_overlap_no_cutoff_minsize_0.5msize_Fig3' pt_task '_ax_' num2str(slicethickness) 'mm'],10*[3 2]) 
     end

%% plot using complex color map
    
    % plot on native brain slices
    [mag, RGB] =complexplot_3fold_v3(rvals, dp_locs); % this function serves to assign a complex number to each channel's r^2 value and assign a uniqe RBG value

    [x_slice, y_slice, z_slice] = seegview_sliceplot(dp_locs, bvol, x, y, z, slicethickness,mr_clims); hold on;
    sv_weight_add_complex(dp_locs, x_slice, RGB, mag); set(gcf,'Name',[pt ' selective ' pt_task ', sagittal, slice thickness ' num2str(slicethickness) 'mm'])
    sv_weight_add_complex(dp_locs, y_slice, RGB, mag); set(gcf,'Name',[pt ' selective ' pt_task ', coronal, slice thickness ' num2str(slicethickness) 'mm'])
    sv_weight_add_complex(dp_locs, z_slice, RGB, mag); set(gcf,'Name',[pt ' selective ' pt_task ', axial, slice thickness ' num2str(slicethickness) 'mm'])
    
     if figsave=='y'
        axes(x_slice.ha(1)); kjm_printfig(['data/' pt '/' pt '_linear_(1-r)_colorshift_2sec_' pt_task '_sag_' num2str(slicethickness) 'mm'],10*[3 2]) 
        axes(y_slice.ha(1)); kjm_printfig(['data/' pt '/' pt '_linear_(1-r)_colorshift_2sec_' pt_task '_cor_' num2str(slicethickness) 'mm'],10*[3 2]) 
        axes(z_slice.ha(1)); kjm_printfig(['data/' pt '/' pt '_linear_(1-r)_colorshift_2sec_' pt_task '_ax_' num2str(slicethickness) 'mm'],10*[3 2])
    end


end
     


    

    



function sv_weight_add_complex(dp_locs, slice, RGB, mag, threshFrac)
    
    if nargin < 5, threshFrac = 0.1; end % abs(values) below threshFrac*wm deemed not significant


    %% scale to maximum across slices
%     rad_scale = nan(size(dp_locs,1), 1);
%     rad_scale = 1-(RGB(:,1).* RGB(:,2) .* RGB(:,3));
    wm = max(mag);

    %% plotting add - cycle through slices
    for k=1:length(slice.values)    
        axes(slice.ha(k))
        tmp_inds = slice.locs==k;
        sv_weight_ax(dp_locs(tmp_inds,slice.perm), RGB(tmp_inds,:), mag(tmp_inds,:), wm, threshFrac)
    end
end
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
function sv_weight_ax(elecs, RGB, mag, wm, threshFrac)

msize= 6;
pthresh = threshFrac .* wm;

%% plot weights
    hold on
    for q=1:size(elecs,1)

                if mag(q) <= pthresh
                    plot(elecs(q,1),elecs(q,2),'o',...
                    'MarkerSize',msize,...
                    'LineWidth',.5,...
                    'MarkerEdgeColor',.33*[1 1 1],... 
                    'MarkerFaceColor',.98*[1 1 1])
                end

                 if mag(q) > pthresh
                    plot(elecs(q,1),elecs(q,2),'o',...
                    'MarkerSize',msize*(mag(q)).^2/wm+msize,...
                    'LineWidth',.5,...
                    'MarkerEdgeColor',.98*[1 1 1],... 
                    'MarkerFaceColor',[RGB(q,1) RGB(q,2) RGB(q,3)])  
                 end
    end
    hold off
end
        
% %                 'MarkerFaceColor',[rbgs(q,1) rbgs(q,2) rbgs(q,3)])  
function sv_weight_add_overlap(locs, plot_wts, slice, threshFrac)
    
    if nargin < 4, threshFrac = 0.01; end % abs(values) below threshFrac*wm deemed not significant

    plot_wts(isnan(plot_wts)) = 0;
    
    %% scale to maximum across slices
    wm=max(abs(plot_wts));

    %% plotting add - cycle through slices
    for k=1:length(slice.values)    
        axes(slice.ha(k))
        tmp_inds = slice.locs==k;
        sv_weight_ax(locs(tmp_inds,slice.perm), plot_wts(tmp_inds), wm, threshFrac)
    end
end
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
function sv_weight_ax(els, wts, wm, threshFrac)

msize = 10;
%%
% wm=max(abs(wts));
els(isnan(els))=0;
pthresh = threshFrac*wm;

   hold on
    for q=1:size(els,1)% add activity colorscale
            %msize_scale = (wts(q))/wm;
            if abs(wts(q))<pthresh % not significant
                % circle w border
%                 pgon = nsidedpoly(5,'Center',[els(q,1) els(q,2)],'SideLength',(2 + wts(q)));
%                 pg = plot(pgon);
%                 pg.FaceColor = 'w';
%                 pg.FaceAlpha = 1;

                plot(els(q,1),els(q,2),'*',...
                'MarkerSize',msize,...
                'LineWidth',0.5,...
                'MarkerEdgeColor',.99*[1 1 1],... 
                'MarkerFaceColor',.98*[1 1 1])  
                %
            elseif wts(q)>=pthresh
                % white circle
%                 pgon = nsidedpoly(5,'Center',[els(q,1) els(q,2)],'SideLength',(msize .* wts(q)/wm));
%                 pg = plot(pgon);
%                 pg.FaceColor = 'r';
%                 pg.FaceAlpha = 1;
                plot(els(q,1),els(q,2),'*',...
                'MarkerSize',msize*abs(wts(q))/wm+msize,...
                'LineWidth',0.5,...
                'MarkerEdgeColor',.99*[1 1-wts(q)/wm 1-wts(q)/wm],... 
                'MarkerFaceColor',.99*[1 1-wts(q)/wm 1-wts(q)/wm])
                 hold on;
            end
%         end
    end
    hold off
end
%                 'MarkerSize',msize*abs(wts(q))/wm+msize,...
%'MarkerSize',(msize_scale .* msize),... 
 %'MarkerSize',(msize_scale * msize)+(0.5*msize),... 
        
function [mag, RGB]=complexplot_3fold_v3(rvals, dp_locs)
% this function returns RGB values for a 3 fold plot in the complex plane
% pure R=0, pure G=2*pi/3, pure B=4*pi/3,
% magnitude of w is assumed to be <=1 (returns error if not? or scale to 1?)
%
% kjm and maj 4/2022
%%
for k = 1:size(dp_locs,1)
     if rvals.r_tongue_HFB(k) < 0, rvals.r_tongue_HFB(k) = 0, end %only positive values (increasing power)
     if rvals.r_foot_HFB(k) < 0, rvals.r_foot_HFB(k) = 0, end  %only positive values 
     if rvals.r_hand_HFB(k) < 0, rvals.r_hand_HFB(k) = 0, end   %only positive values 
  
%      plot(0 + 0.001i, 'o','MarkerEdgeColor','w', 'LineWidth',.9);

     w(k) = (rvals.r_hand_HFB(k) +  rvals.r_tongue_HFB(k).*exp(1i*(2*pi/3)) + rvals.r_foot_HFB(k).*exp(1i*(4*pi/3))).*exp(1i*(pi/6)); 
end

%% unpack w into magnitude and phase
RGB = zeros(length(w), 3);
for j = 1:length(w)
    r=abs(w(j));
    phi=angle(w(j));
    mag(j,:) = r;

%% get maximum RGB from phi -- go in 6 "wedges" of complex plane (named zones 1-6)

    if and(phi<(pi/3), phi>=(0)) % zone 1
        R=1;
        G=RGB_intermediate(phi-0); 
        B=0;

    elseif and(phi<(2*pi/3), phi>=(pi/3)) % zone 2
        R=1-RGB_intermediate(phi-(pi/3)); 
        G=1; 
        B=0;

    elseif and(phi<(pi), phi>=(2*pi/3)) % zone 3
        R=0;
        G=1; 
        B=RGB_intermediate(phi-(2*pi/3)); 

    elseif and(phi<(-2*pi/3), phi>=(-pi)) % zone 4
        R=0;
        G=1-RGB_intermediate(phi-(-pi)); 
        B=1;

    elseif and(phi<(-pi/3), phi>=(-2*pi/3)) % zone 5
        R=RGB_intermediate(phi-(-2*pi/3)); 
        G=0; 
        B=1;

    elseif and(phi<(0), phi>=(-pi/3)) % zone 6
        R=1;
        G=0; 
        B=1-RGB_intermediate(phi-(-pi/3)); 

    else disp('error in phase angle sent')
        R=NaN; G=NaN; B=NaN;
    end

    RGB0 =[R G B]; % RGB if r is 1


%% Fade to white as r goes to 0

    rgb_res=[1 1 1]-RGB0; % residual "color" between full value and white. 

    % first test if r is <=1
    if r > 1
        disp('error, magnitude is r>1, returning RGB for r=1')
        r=1;
    end


    % this is where we pick the scalingfactor as a function of r
    % it should be 0 when r=1, 
    % it should go to 1 when you want white
    %
    % linear 
%     r_scalefactor=(1-r);
    
    % square-root
%     r_scalefactor=(1-r).^.5;
    
    %nth power inside
     n = 1;
     r_scalefactor = (1 - r^n);
    
    %nth power outside
%      n = 2;
%      r_scalefactor = (1 - r)^n;

    RGB(j,:) =RGB0 +(r_scalefactor*rgb_res); 
end
clear RGB0

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tmp_out=RGB_intermediate(phi0)
% this function takes phi0 and returns a value over the range 0 to 1
% phi0 needs to be on range 0 to pi/3
% comment type in and out to get what colorscale you want
%kjm and maj 4/2022


%% linear
     tmp_out=phi0*(3/pi);

%% sine
%    tmp_out=sin(phi0*3/2);

%% square
%     tmp_out=(phi0*(3/pi))^2;
    
%% make sure not an error
    if or(phi0<0,phi0>(pi/3))
        disp('error - phase angle sent to variable range is not on 0 to pi/3 interval')
        tmp_out=NaN; 
    end
    
    




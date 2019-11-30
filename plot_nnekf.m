function plot_nnekf(parameter,truth,meas,est)

range = parameter.max_range;
p_truth_1 = [];
p_truth_2 = [];
p_meas = [];
p_est= [];
p_est_1 = [];
p_est_2 = [];

%%%%%%calculate target_truth_1 & target_truth_2
[truth_1,truth_2] = find_truth_target_num(parameter,truth);

%%%%%calculate target_estimate_1 & target_truth_2
[estimate_1,estimate_2] = find_estimate_target_num(parameter,truth_1,truth_2,est.est_x);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot truth/measurement/estimate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plot the ground truth
for k1 = 1:truth.K
   if isempty(truth_1{k1})
       continue;
   end
   
   tru_1 = [];
   tru_1 = [truth_1{k1}(1,:); truth_1{k1}(3,:)];
   p_truth_1 = [p_truth_1 tru_1];   
    
end

for k2 = 1:truth.K
   if isempty(truth_2{k2})
       continue;
   end
   
   tru_2 = [];
   tru_2 = [truth_2{k2}(1,:); truth_2{k2}(3,:)];
   p_truth_2 = [p_truth_2 tru_2];   
    
end

%plot the measurement
for k = 1:truth.K
   if isempty(meas.Z{k})
       continue;
   end
   
   mea = []; 
   mea = polar_to_xy(meas.Z{k});
   p_meas = [p_meas mea]; 
end

%plot the estimate
for k = 1:truth.K
   if isempty(est.est_x{k})
       continue;
   end
   
   es = [];
   es = [est.est_x{k}(1,:); est.est_x{k}(3,:)];
   p_est = [p_est es];   
    
end

for k1 = 1:truth.K
   if isempty(estimate_1{k1})
       continue;
   end
   
   es_1 = [];
   es_1 = [estimate_1{k1}(1,:); estimate_1{k1}(3,:)];
   p_est_1 = [p_est_1 es_1];   
    
end

for k2 = 1:truth.K
   if isempty(estimate_2{k2})
       continue;
   end
   
   es_2 = [];
   es_2 = [estimate_2{k2}(1,:); estimate_2{k2}(3,:)];
   p_est_2 = [p_est_2 es_2];   
    
end

figure; truth= gcf; hold on;
h_truth_1 = plot(p_truth_1(1,:),p_truth_1(2,:),'k*','markersize',10);
h_truth_2 = plot(p_truth_2(1,:),p_truth_2(2,:),'k+','markersize',10);
h_meas = plot(p_meas(1,:),p_meas(2,:),'b+','markersize',2);
h_est = plot(p_est(1,:),p_est(2,:),'ro','markersize',6); 
h_est_1 = plot(p_est_1(1,:),p_est_1(2,:),'b','markersize',12);
h_est_2 = plot(p_est_2(1,:),p_est_2(2,:),'m','markersize',12);
legend([h_truth_1 h_truth_2 h_meas h_est h_est_1 h_est_2],'Ground Truth 1','Ground Truth 2','Measurement','Estimated','Track 1','Track 2');
title('Nearest Neighbor');
xlabel('X-axis');
ylabel('Y-axis');
xlim=[-range range];
ylim=[-range range];
set(gca,'XLim',xlim);
set(gca,'YLim',ylim);



function x_y_pos = polar_to_xy(measurement)
   
r = measurement(1,:);
th = measurement(2,:);

x_pos = r.*cos(th);
y_pos = r.*sin(th);

x_y_pos = [x_pos; y_pos];

end


end
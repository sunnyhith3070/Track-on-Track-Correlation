function est = run_PDA_filter(parameter,meas)

%=== Setup

%output variables
% est.X= cell(meas.K,1);
% est.N= zeros(meas.K,1);
% est.L= cell(meas.K,1);
% measG.Z= cell(meas.K,1);

%filter parameters

gate= parameter.gate;       %gate size

%structer of tracker
est.P = cell(meas.K,1);    %covariance
est.x = cell(meas.K,1);    %state
est.q = cell(meas.K,1);    %quality
est.est_x = cell(meas.K,1);
est.est_q = cell(meas.K,1);
% tracker.H = cell(meas.K,1);

% est.tracker = est;
%=== Filtering

%recursive filtering
for k=1:meas.K
   s2 = size(meas.Z{k});
   S2 = s2(2); %number of measurement in each time k
   if k == 1
       for j = 1:S2
           [P_temp, x_temp, q_temp]= track_initial_single(parameter, meas.Z{k}(:,j));
           est.P{k}(:,j) = P_temp;
           est.x{k}(:,j) = x_temp;
           est.q{k}(:,j) = q_temp;
       end
%            est.tracker = tracker;
   else    
       %%%%%prediction
       s3 = size(est.P{k-1});
       S3 = s3(2);
       for g = 1:S3
           [P_predict, x_predict, q_predict]=ekf_predict_single(parameter,est.P{k-1}(:,g),est.x{k-1}(:,g),est.q{k-1}(:,g));
           est.P{k}(:,g) = P_predict;
           est.x{k}(:,g) = x_predict;
           est.q{k}(:,g) = q_predict;
       
       end
       
       %%%%%gate and data association
       [P_update, x_update, q_update,z_unvalid]= gate_meas_pda(meas.Z{k},gate,parameter,est.P{k},est.x{k},est.q{k});         
       
%        %%%%%gate and data association
%        [z_valid,z_unvalid,valid_idx_x,unvalid_idx_x]= gate_meas_pda(meas.Z{k},gate,parameter,est.P{k},est.x{k},est.q{k});       
       
%        %%%%%update
%        [P_update, x_update, q_update]= ekf_update_pda(meas.Z{k},parameter,est.P{k},est.x{k},est.q{k},z_valid,valid_idx_x,unvalid_idx_x);
       
       
       
       %%%%%promote tentative to confirm
       q_update_confirm = promote_tentative_to_confirm(parameter,q_update);
       
       %%%%%delete confirm
       [P_confirm_delete,x_confirm_delete,q_confirm_delete ]= confirm_delete(parameter,P_update,x_update,q_update_confirm);
       
       %%%%%delete tentative
       [P_update, x_update, q_update] = delete_tentative(parameter,P_confirm_delete,x_confirm_delete,q_confirm_delete);

%        idx_q = find(q_update > pparameter.delete_tentative);  %survival ?
%        x_update = x_update(:,idx_q);
%        P_update = P_update(:,idx_q);
%        q_update = q_update(:,idx_q);
       
       %%%%%record the estimate based on confirm status
       [x_est,q_est] = record_confirm(x_update,q_update);
%        idx_com = find(q_update > parameter.confirm);
%        x_est = x_update(:,idx_com);
%        q_est = q_update(:,idx_com);
       

       %%%%%initialze when k > 1      
       P_te =[];
       x_te =[];
       q_te =[];

       for b = 1:size(z_unvalid,2)
           [P_tem, x_tem, q_tem]= track_initial_single(parameter, z_unvalid(:,b));
           P_te = [P_te P_tem];
           x_te = [x_te x_tem];
           q_te = [q_te q_tem];
%            tracker.P{k} = [P_update P_tem];
%            tracker.x{k} = [x_update x_tem];
%            tracker.q{k} = [q_update q_tem];
       end
       
       est.P{k} = [P_update P_te];
       est.x{k} = [x_update x_te];
       est.q{k} = [q_update q_te];
       est.est_x{k} = x_est;
       est.est_q{k} = q_est;
%        valid_idx_x
   end

   
end    


end

            
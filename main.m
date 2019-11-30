clc;
close all;
clear all;

parameter= gen_parameter;
truth= gen_truth(parameter);

for k = 1:parameter.MC_num
    meas=  gen_meas(parameter,truth);
    est_NNEKF= run_NNEKF_filter(parameter,meas);
    est_PDA= run_PDA_filter(parameter,meas);

    %calculate and plot truth/measurement/estimate
        if k == 1
            plot_nnekf(parameter,truth,meas,est_NNEKF);
            plot_pda(parameter,truth,meas,est_PDA);
        end
    
    %%%%%calculate RMSE
    [rmse_1_position_nn(:,k),rmse_1_velocity_nn(:,k),N_k_1_nn(:,k),rmse_2_position_nn(:,k),rmse_2_velocity_nn(:,k),N_k_2_nn(:,k)]= calcu_rmse(parameter,truth,meas,est_NNEKF);
    [rmse_1_position_pda(:,k),rmse_1_velocity_pda(:,k),N_k_1_pda(:,k),rmse_2_position_pda(:,k),rmse_2_velocity_pda(:,k),N_k_2_pda(:,k)]= calcu_rmse(parameter,truth,meas,est_PDA);

    %%%%%calculate confirm and termination latency
    [confirm_latency_nn(:,k),termination_latency_nn(:,k)]=calcu_latency(parameter,truth,meas,est_NNEKF);
    [confirm_latency_pda(:,k),termination_latency_pda(:,k)]=calcu_latency(parameter,truth,meas,est_PDA);

    %%%%%calculate false track number
    false_track_num_nn(:,k)= calcu_false_track(parameter,truth,meas,est_NNEKF);
    false_track_num_pda(:,k)= calcu_false_track(parameter,truth,meas,est_PDA);

end

%%%%%plot RMSE 
plot_rmse_nn(parameter,rmse_1_position_nn,rmse_1_velocity_nn,N_k_1_nn,rmse_2_position_nn,rmse_2_velocity_nn,N_k_2_nn);
plot_rmse_pda(parameter,rmse_1_position_pda,rmse_1_velocity_pda,N_k_1_pda,rmse_2_position_pda,rmse_2_velocity_pda,N_k_2_pda);

%%%%%print Latency table
T_c_nn_ave = sum(confirm_latency_nn',1)./parameter.MC_num;
T_t_nn_ave = sum(termination_latency_nn',1)./parameter.MC_num;
T_c_pda_ave = sum(confirm_latency_pda',1)./parameter.MC_num;
T_t_pda_ave = sum(termination_latency_pda',1)./parameter.MC_num;

T_c_nn =[parameter.MC_num parameter.confirm T_c_nn_ave];
T_t_nn =[parameter.MC_num parameter.confirm T_t_nn_ave];
T_c_pda =[parameter.MC_num parameter.confirm T_c_pda_ave];
T_t_pda =[parameter.MC_num parameter.confirm T_t_pda_ave];

T_confirm_nn = array2table(T_c_nn,...
    'VariableNames',{'MonteCarlotimes','ProbabilityofConfirm','ConfirmLatencyTarget1_NN','ConfirmLatencyTarget2_NN'})

T_termination_nn = array2table(T_t_nn,...
    'VariableNames',{'MonteCarlotimes','ProbabilityofConfirm','TerminationLatencyTarget1_NN','TerminationLatencyTarget2_NN'})

T_confirm_pda = array2table(T_c_pda,...
    'VariableNames',{'MonteCarlotimes','ProbabilityofConfirm','ConfirmLatencyTarget1_PDA','ConfirmLatencyTarget2_PDA'})

T_termination_pda = array2table(T_t_pda,...
    'VariableNames',{'MonteCarlotimes','ProbabilityofConfirm','TerminationLatencyTarget1_PDA','TerminationLatencyTarget2_PDA'})

%%%%%plot false track number
figure;
plot(false_track_num_nn);
title('False track number(Nearest Neighbor)');
xlabel('Monte Carlo times');
ylabel('False track number');
ylim=[0 5];
set(gca,'YLim',ylim);

figure;
plot(false_track_num_pda);
title('False track number(Probabilistic Data Association)');
xlabel('Monte Carlo times');
ylabel('False track number');
ylim=[0 5];
set(gca,'YLim',ylim);


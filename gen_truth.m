function truth= gen_truth(parameter)

%variables
truth.T = parameter.T;
truth.K= parameter.K;                 %length of data/number of scans
truth.X= cell(truth.K,1);             %ground truth for states of targets  
truth.N= zeros(truth.K,1);            %ground truth for number of targets
truth.L= cell(truth.K,1);             %ground truth for labels of targets (k,i)
truth.track_list= cell(truth.K,1);    %absolute index target identities (plotting)
truth.total_tracks= 0;                %total number of appearing tracks

%target initial states and birth/death times
nbirths= 2;

xstart(:,1)  = parameter.target1_initial_state;        
tbirth(1)  = parameter.target1_start_time;     
tdeath(1)  = parameter.target1_end_time;

xstart(:,2)  = parameter.target2_initial_state;        
tbirth(2)  = parameter.target2_start_time;    
tdeath(2)  = parameter.target2_end_time;

G = parameter.G;
F = parameter.F;

mean_noise=[0 0 0 0];
state_var = diag([0.01 0.01 0.01 0.01]);
k1 = min(tdeath(1),truth.K);
noise_1 = mvnrnd(mean_noise, state_var,k1);
k2 = min(tdeath(2),truth.K);
noise_2 = mvnrnd(mean_noise, state_var,k2);



%generate the tracks
for targetnum=1:nbirths
    %targetstate = xstart(:,targetnum);
    if targetnum == 1
        noise = noise_1;
    else
        noise = noise_2;
    end
    
    for k=tbirth(targetnum):min(tdeath(targetnum),truth.K)
        if k == tbirth(targetnum)
            targetstate = xstart(:,targetnum) + G*noise(k,:)';
        else
            targetstate= F * targetstate + G*noise(k,:)';
        end
        %targetstate = gen_newstate_fn(parameter,targetstate,'noiseless')
        truth.X{k}= [truth.X{k} targetstate];
        truth.track_list{k} = [truth.track_list{k} targetnum];
        truth.N(k) = truth.N(k) + 1;
     end
end
truth.total_tracks= nbirths;



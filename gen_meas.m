function meas= gen_meas(parameter,truth)

%variables
meas.K= truth.K;
meas.Z= cell(truth.K,1);

%generate measurements
for k=1:truth.K
    if truth.N(k) > 0
        idx= find( rand(truth.N(k),1) <= parameter.P_D );         %detected target indices
        meas.Z{k}= gen_observation_fn(parameter,truth.X{k}(:,idx));   %single target observations if detected         
    end
    N_fa= poissrnd(parameter.lambda_c);   %number of false alarm
    C= repmat(parameter.range_c(:,1),[1 N_fa])+ diag(parameter.range_c*[ -1; 1 ])*rand(parameter.z_dim,N_fa);
    meas.Z{k}= [ meas.Z{k} C ];            %measurement is union of detections and clutter
end
    
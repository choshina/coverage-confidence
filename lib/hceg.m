clear;
%addpath(genpath('/home/zhenya/MCTS-Falsification/src/main/matlab/basic'));
%addpath(genpath('/home/zhenya/MCTS-Falsification/src/model/benchmark_ARCH19/transmission'));
%addpath(genpath('/home/zhenya/breach/'));
InitBreach;


mdl = 'Autotrans_shift';

Br = BreachSimulinkSystem(mdl);
br = Br.copy();


phi_str = 'alw_[0,20] (speed[t] < 120)';
phi = STL_Formula('phi1',phi_str);
tspan = 0:.01:30;
controlpoints = 6;


input_name = {'throttle','brake'};
input_range = [[0.0 100.0];[0.0 350.0]];

filename = 'mctsbasic_AT1_6_0.2_3_5_40_cmaes_45';
algorithm = 'random';


total_time = [];
budget = 30;

arg = 100;
solver = 'cmaes';


trials = 1;
min_rob = [];
coverage = [];
time_cov = [];

for i = 1:trials
	 
	 log = phi_falsify(br, budget, phi, controlpoints, tspan, input_name, input_range, solver);
	 
     
     tic
     range_t = get_full_range(input_range, controlpoints);
     ct = CoverageTester(range_t,  arg, log);

	 time = toc;
     min_rob = [min_rob; ct.min_rob];
     coverage = [coverage; ct.coverage];
     time_cov = [time_cov; time];
	 
	 
end

%phi_str = {phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str};

%filename = {filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename};

%controlpoints = controlpoints*ones(trials,1);


%N_max = N_max*ones(trials,1);


%result = table(filename, phi_str, algorithm, controlpoints, budget, min_rob, coverage, time_cov);
result = table(min_rob, coverage, time_cov);
writetable(result,'$csv','Delimiter',';');
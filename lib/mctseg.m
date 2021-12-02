clear;

InitBreach;


mdl = 'Autotrans_shift';
Br = BreachSimulinkSystem(mdl);
br = Br.copy();

N_max =40;
scalar = 0.2;
phi_str = 'alw_[0, 10](RPM[t] < 4750.0)';
phi = STL_Formula('phi1',phi_str);
T = 30;
controlpoints = 6;
hill_climbing_by = 'cmaes';
T_playout = 45;
input_name = {'throttle','brake'};
input_range = [[0.0 100.0];[0.0 350.0]];
partitions = [3 5];
filename = 'mctsbasic_AT2_6_0.2_3_5_40_cmaes_45';
algorithm = 'mctsbasic';
falsified_at_all = [];
total_time = [];
falsified_in_preprocessing = [];
time_for_preprocessing = [];
falsified_after_preprocessing = [];
time_for_postpreprocessing = [];
best_robustness = [];
simulation_pre = [];
simulation_after = [];
simulations = [];
trials =30;
min_rob = [];
coverage = [];
time_cov = [];
for i = 1:trials
	 
	 m = MCTS(br, N_max, scalar, phi, T, controlpoints, hill_climbing_by, T_playout, input_name, input_range, partitions);
     log = m.log;
     
     tic
     
     range_t = get_full_range(input_range, controlpoints);
     ct = CoverageTester(range_t,  arg, log);

	 time = toc;
     min_rob = [min_rob; ct.min_rob];
     coverage = [coverage; ct.coverage];
     time_cov = [time_cov; time];
	 
	 time = toc;
	 
	 
end
falsified_at_all = falsified_after_preprocessing;
total_time = time_for_preprocessing + time_for_postpreprocessing;
simulations = simulation_pre + simulation_after;
phi_str = {phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str;phi_str};
algorithm = {algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm;algorithm};
hill_climbing_by = {hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by;hill_climbing_by};
filename = {filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename;filename};
controlpoints = controlpoints*ones(trials,1);
scalar = scalar*ones(trials,1);
partis = [];
for u = 1:numel(partitions)
	partis = [partis partitions(u)*ones(trials,1)];
end
T_playout = T_playout*ones(trials,1);
N_max = N_max*ones(trials,1);
result = table(filename, phi_str, algorithm, hill_climbing_by, controlpoints, scalar, partis, T_playout, N_max, falsified_at_all, total_time, simulations, best_robustness, falsified_in_preprocessing, time_for_preprocessing, falsified_after_preprocessing, time_for_postpreprocessing);
writetable(result,'$csv','Delimiter',';');
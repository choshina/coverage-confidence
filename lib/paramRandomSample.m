function [logs, vars, ranges] = paramRandomSample(br, budget, phi, tspan, input_name, input_range)
    br.Sys.tspan = tspan;

%    input_gen.type = 'UniStep';
%    input_gen.cp = cp;
%    br.SetInputGen(input_gen);


    rng('default')
    rng('shuffle')
    
    logs = [];
    logs.X_log = [];
    logs.obj_log = [];

    for i = 1: budget

        x_list = [];
        [dim, ~] = size(input_range);
        for j = 1:dim
%            for h = 1:cp
                x_temp = (input_range(j, 2) - input_range(j, 1))*rand + input_range(j, 1);
                x_list = [x_list x_temp];
%            end
        end
        
        
%        for cpi = 1:cp
            for j = 1:dim
                br.SetParam({input_name(j)}, x_list(j));
            end
%        end

        
%        logs.X_log = [logs.X_log x_list'];


        br.Sim(tspan);
        obj = br.CheckSpec(phi)
	if obj > 0
        	logs.X_log = [logs.X_log x_list'];
        	logs.obj_log = [logs.obj_log obj];
	end
	vars = br.GetSysVariables();
	ranges = br.GetParamRanges(vars);

    end

end

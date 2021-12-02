%the starting file is phi_falsify
function testCoverage(phi, phiname, range_t, arg, bd, solver)
    %phi = STL_Formula('phi1','alw_[0,30] (speed[t] < 150)');
    objective = [];
    
    coverage = [];
    
    for i = 1:20
        %randomSample(phi, 300);
        phi_falsify(phi, 200, solver);
        %testexec();
        %randomexec();
        cov_sub = [];
        obj_sub = [];
        for bound = bd
            
           % objective = [objective; obj];

            filename = 'test.mat';
            ps = ParseSampling(filename, bound);
            ps.parse();
            obj_sub = [obj_sub; ps.getObj()];

            
            range = Range(range_t);
            point_set = ps.point_set;

            par = Partition(range, 0, point_set);

            aw = arg;
            cov_instance = Coverage(par, aw);
            cov = cov_instance.getCoverage()
            %cov_instance.draw_figure();
            
            cov_sub = [cov_sub;cov];
        end
        objective = [objective obj_sub];
        coverage = [coverage cov_sub];
    end
    
    for j = 1:numel(bd)
        rob = objective(j, :)';
        cov = coverage(j, :)';
        result = table(rob, cov);
        file = strcat(phiname, '_',int2str(j), '_', int2str(arg), '_', solver,  '.csv');
        writetable(result,file,'Delimiter',';');
    end
end
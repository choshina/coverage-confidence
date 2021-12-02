classdef CoverageTester< handle
    
    properties
        %phi
        range
        arg
        
        %filename
        logname
        
        bound
        
        min_rob
        coverage
    end
    
    methods
        function this = CoverageTester(range, arg, logname, bound)
            %this.phi = phi;
            this.range = range;
            this.arg = arg;
            this.logname = logname;
            this.bound = bound;
            
            this.run();
        end
        
        function run(this)
            ps = ParseSampling(this.logname, this.bound);
            ps.parse();
            this.min_rob = ps.getObj();
            
            input_range = Range(this.range);
            point_set = ps.point_set;
            
            par = Partition(input_range, 0, point_set);
            
            cov_instance = Coverage(par, this.arg);
            
            this.coverage = cov_instance.getCoverage();
            
            
        end
        
        
    end
    
end
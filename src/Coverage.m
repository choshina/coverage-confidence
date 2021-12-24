classdef Coverage < handle
    properties
        %algorithm
        %coverage
        
        %model
        %input_range
        %point_set
        
        p_root
        P_total
        arg_w
        dim
    end
    
    
    methods
        function this = Coverage(par, aw)
            
            this.p_root = par;
            this.P_total = [];
            this.arg_w = aw;
            this.dim = this.p_root.range.dim;
        end
        
        function num_par = weightFunction(this, rob)
            %concretely it should be dependent on the distribution
            
            num_par = floor(this.arg_w*1.0/rob);
        end
        
        function cov = getCoverage(this)
            %sorted
            %while ~this.Q_proc.empty()
            %    par = this.Q_proc.pop();
            %    pt_par = par.getHead();
            %    w = this.weightFunction(pt_par.robustness);
                
            %    this.add_partition(w);
            %end
            this.partition(this.p_root)
            cov = this.computeCoverage();
        end
        
        function partition(this, par)
            s_head = par.getHead();
            if isempty(s_head)
                return
            else             
                w = this.weightFunction(s_head.robustness);
                if w > par.level  %is this true?
                    p_local = [];   %p_local includes the partitions at the same level

                    rg_set = par.range.split_comp();
                    for rg = rg_set    
                        new_ps = [];
                        for p = par.point_set
                            if rg.check_point(p, this.p_root.range.range(:, 2))
                                new_ps = [new_ps p];
                            end
                        end
                        p_new = Partition(rg, par.level + 1, new_ps);
                        p_new
                        p_local = [p_local p_new];
                    end

                    for p = p_local
                        this.partition(p);
                    end
                else
                    this.P_total = [this.P_total par];
                end
            end
        end
        
        
        function cov = computeCoverage(this)
            cov = 0;
            for p = this.P_total
                if ~p.empty()
                    cov = cov + 1.0/((2^this.dim)^p.level);
                end
            end
        end
        
        function draw_figure(this)
            this.p_root.drawPartition();
            for p = this.P_total
                p.range.draw();
            end
        end
  
    end
end
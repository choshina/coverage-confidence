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
                    %step_i = (par.range(1,2)-par.range(1,1))/2.0;
                    %step_j = (par.range(2,2)-par.range(2,1))/2.0;
                    %steps = [];
                    %[~, dim] = size(par.range);
                    %for d = 1:dim
                    %    ss = (par.range(d, 2) - par.range(d, 1))/2.0;
                    %    steps = [steps ss];
                    %end
                    
                   %for idx_i = [0 1]
                        %for idx_j = [0 1]
                    %for idx = 1:2^dim
                    rg_set = par.range.split_comp();
                        %new_range = [par.range(1,1)+step_i*idx_i par.range(1,1)+step_i*(idx_i+1); par.range(2,1)+step_j*idx_j par.range(2,1)+step_j*(idx_j+1)];
                    for rg = rg_set    
                        new_ps = [];
                        for p = par.point_set
                            if rg.check_point(p)
                                new_ps = [new_ps p];
                            end
                        end
                        p_new = Partition(rg, par.level + 1, new_ps);
                        p_local = [p_local p_new];
                    end
                    %end
                        %end
                    %end

                    for p = p_local
                        this.partition(p);
                    end
                else
                    this.P_total = [this.P_total par];
                end
            end
        end
        
        %function in = check_ptin(this, p, r)
        %    in = false;
        %    if p.x_1>=r(1,1) && p.x_1<=r(1,2) && p.x_2 >= r(2,1) && p.x_2<=r(2,2)
        %        in = true; 
        %    end
        %end
        
        
        
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
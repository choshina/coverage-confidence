classdef Range < handle
    properties
        dim
        range
    end
    
    methods
        
        function this = Range(range)
            
            this.range = range;
            [this.dim, ~] = size(range);
        end
        
        function rg_set = divide22(this, idx)
            
            step = (this.range(idx, 2) - this.range(idx, 1))/2.0;
            r1 = this.range;
            r1(idx,:) = [this.range(idx, 1), this.range(idx, 1) + step];
            r2 = this.range;
            r2(idx,:) = [this.range(idx, 1)+ step, this.range(idx, 2)];
            rg_set = [Range(r1) Range(r2)];
        end
        
        function rg_set = split_comp(this)
            rg_set = this.split(this, this.dim);
        end
        
        function rg_set = split(this, range, idx)
            if idx == 0
                rg_set = range;
            else
                rg_set_t = range.divide22(idx);
                rg_set = [];
                for r = rg_set_t
                    rg_set =[rg_set this.split(r, idx -1)];
                end
            end
        end
        
        function in = check_point(this, p, most_ub)
            in = true;
            for i = 1:this.dim
               if  this.range(i,2) == most_ub(i)
                    if p.x(i) < this.range(i,1) 
                        in = false;
                        break;
                    end
               else
                    if p.x(i) < this.range(i,1) || p.x(i) >= this.range(i, 2)
                        in = false;
                        break;
                    end
               end
            end
        end
        
        function draw(this)
            if this.dim == 2
                
                plot(this.range(1,1)*ones(size(this.range(2, :))), this.range(2, :));
                hold on;
                line(this.range(1,2)*ones(size(this.range(2, :))), this.range(2, :));
                hold on;
                line(this.range(1,:), this.range(2, 1)*ones(size(this.range(1,:))));
                hold on;
                line(this.range(1,:), this.range(2, 2)*ones(size(this.range(1,:))));
                hold on;
            else
                
            end
        end
    end
end
classdef Partition <handle
    properties
        range
        level
        point_set
        
    end
    
    methods
        function this = Partition(range, level, point_set)
            this.range = range;
            this.level = level;
            this.point_set = point_set;
            
        end
        
        function head = getHead(this)
            min_rob = Inf;
            min_pt = [];
            for p = this.point_set
                if p.robustness<min_rob
                    min_rob = p.robustness;
                    min_pt = p;
                end
            end
            head = min_pt;
        end
        
        function emp = empty(this)
            emp = isempty(this.point_set);
        end
        
        %function drawRange(this)
        %    plot(this.range(1,1)*ones(size(this.range(2, :))), this.range(2, :));
        %    hold on;
        %    line(this.range(1,2)*ones(size(this.range(2, :))), this.range(2, :));
        %    hold on;
        %    line(this.range(1,:), this.range(2, 1)*ones(size(this.range(1,:))));
        %    hold on;
        %    line(this.range(1,:), this.range(2, 2)*ones(size(this.range(1,:))));
        %    hold on;
        %end
        
        function drawPartition(this)
            this.range.draw();
            
            ps = [this.point_set.x];
            scatter([ps(1,:)], [ps(2,:)]);
            
            anno = cellstr(num2str([this.point_set.robustness]'));
            text([ps(1,:)], [ps(2,:)], anno);
        end
        

    end
end
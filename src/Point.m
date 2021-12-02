classdef Point <handle
    properties
        x
        robustness
        dim
        
    end
    
    methods
        function this = Point(x, robustness)
            this.x = x;
            this.robustness = robustness;
            this.dim = numel(x);
        end
        
        
    end
end
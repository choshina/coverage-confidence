classdef ParseSampling <handle
    properties
        %filename
        logname
        logcontent
         
        point_set
        
        bound
        
        
    end
    
    methods
        function this = ParseSampling(logname, bound)
            %this.filename = filename;
            this.logname = logname;
            this.point_set = [];
            this.bound = bound;
            this.logcontent = [];
        end
        
        function parse(this)
			
            load(this.logname, 'log');

			
            this.logcontent = log;

            %falsif_pb.X_log=[0 2 5 10;0 3 2 24];
            %falsif_pb.obj_log = [30 144 144 144];
            
            %size(falsif_pb.obj_log)
            %for i = 1: length(falsif_pb.obj_log)
            sum = this.bound;
            if numel(this.logcontent.obj_log) < this.bound
                sum = numel(this.logcontent.obj_log);
            end
            
            %this.log = log;
            %sum = numel(this.log.obj_log);
            
            for i = 1: sum
                
                x= this.logcontent.X_log(:, i);
                rob = this.logcontent.obj_log(i);
                this.point_set = [this.point_set Point(x, rob)];
            end
            
            
        end
        
        function obj = getObj(this)
            obj = min([this.point_set.robustness]);
        end
        
        
        
    end
end

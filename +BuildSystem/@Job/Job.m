classdef Job < handle
    %JOB Summary of this class goes here
    %   Detailed explanation goes here
    
    properties %(Access = private)
        TaskGraph (1,1) digraph = digraph();
    end    
    
    events (NotifyAccess = private)
        TaskStatusChange
        TaskConnectionChange
        TaskAdded
        TaskRemoved
    end   
   
    methods(Access = private)
        validateDigraphAttributes(obj);
    end
    
    methods(Static)
        obj = fromFile(filename);
    end
    
    methods
        toFile(obj,filename);
    end
        
    methods
        function obj = Job()
            %BUILDSYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            
        end
        
        obj = addTask(obj,task);
        obj = removeTask(obj,taskName);
        obj = connectTasks(obj,startTaskName,endTaskName);
        obj = disconnectTasks(obj,startTaskName,endTaskName);
        
        obj = run(obj,info); 
        obj = show(obj);
        
        Data = data(obj);
        
        validate(obj); 
        
        function num = numberOfTasks(obj)
            num = obj.TaskGraph.numnodes();
        end
    end
end


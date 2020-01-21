classdef BuildSystem
    %BUILDSYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        TaskDigraph = digraph();
        Data = [];
    end
    
    properties (Access = private)
        Display = [];
        
    end
    
    methods(Static, Access = private)
        validateTaskFunctionSignature(functionName);        
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
        function obj = BuildSystem()
            %BUILDSYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            
        end
        
        obj = addTask(obj,taskFunctionName);
        obj = removeTask(obj,taskFunctionName);
        obj = connectTasks(obj,startTask,endTask)
        obj = disconnectTasks(obj,startTask,endTask)
        
        obj = run(obj,info);        
        
        validate(obj); 
        
        show(obj);
        
    end
end

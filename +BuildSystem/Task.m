classdef Task < handle
    %TASK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = immutable)
        Name(1,1) string       
    end
    
    properties
        Description(1,1) string
        Function(1,1) string  
        Data(1,1) cell
        ExpectedOutput(1,:) string
    end
    
    properties (SetAccess = private)
        StartTime(1,1) datetime 
        EndTime(1,1) datetime 
        Status(1,1) BuildSystem.TaskStates...
            = BuildSystem.TaskStates.Unset;
    end
    
    methods
        function obj = Task(Name,Description,Function)
            %TASK Construct an instance of this class
            %   Detailed explanation goes here 
            arguments
                Name (1,1) string
                Description (1,1) string
                Function (1,1) string
            end
            
            obj.Name = Name;
            obj.Description = Description;
            obj.Function = Function;            
        end
        
        function outData = run(obj,info,inData)
            arguments
                obj (1,1) BuildSystem.Task                
                info (1,1) BuildSystem.Info
                inData (1,1) containers.Map
            end            
            
            try
                obj.Status = BuildSystem.TaskStates.Running;                              
                obj.StartTime = datetime("now");
                obj.StartTime.Format = 'dd-MMM-uuuu HH:mm:ss.SSSS';
                
                outData = feval(...
                    obj.Function,...
                    info,...
                    inData);
                
                obj.verify();
                
                obj.EndTime = datetime("now");
                obj.EndTime.Format = 'dd-MMM-uuuu HH:mm:ss.SSSS';  
                
            catch ME
                obj.EndTime = datetime("now");
                obj.EndTime.Format = 'dd-MMM-uuuu HH:mm:ss.SSSS';                
                obj.Status = Buildsystem.TaskStates.Failed;
                rethrow(ME)
            end 
        
            obj.Data = {outData};
            obj.Status = Buildsystem.TaskStates.Passed;
        end
        
        function duration = duration(obj)
            duration = obj.EndTime - obj.StartTime;
            duration.Format = "hh:mm:ss.SSSS";
        end       
        
        function verify(obj)   
            arguments
                obj (1,1) BuildSystem.Task
            end  
            
            for i = 1:numel(obj.ExpectedOutput) 
                filename = obj.ExpectedOutput(i);
                if filename.endsWith("/")
                    assert(fullfile(pwd,obj.ExpectedOutput(i)),...
                        obj.Name + " did not generate folder """ + obj.ExpectedOutput(ii) + """.");
                else                
                    fileList = dir(fullfile(pwd,obj.ExpectedOutput(i)));
                    assert(~isempty(fileList),...
                        obj.Name + " did not generate file """ + obj.ExpectedOutput(ii) + """.");
                end
            end
        end
        
        function validateFunctionSignature(obj)
            
            arguments
                obj (1,1) BuildSystem.Task
            end  
            
            assert(nargin(obj.Function) == -3,...
                "HIGHLEVELTARGET:buildSystem:invalidTaskInputArguments",...
                "Task function requires the following signature: result = <taskName>(buildInfo,codeInfo,varargin).");
            
            assert(nargout(obj.Function) == 1,...
                "HIGHLEVELTARGET:buildSystem:invalidTaskOutputArguments",...
                "Task function requires the following signature: result = <taskName>(buildInfo,codeInfo,varargin).");   
            
        end
        
    end
end
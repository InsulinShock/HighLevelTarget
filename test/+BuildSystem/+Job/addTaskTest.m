classdef addTaskTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testIfOneTaskAlreadyInJob(testCase)
            
            job = BuildSystem.Job();
            task1 = BuildSystem.Task('Foo','Sample description.','foo');                   
            job.addTask(task1);
            
            testCase.verifyError(...
                @() job.addTask(task1),...
                char("BUILDSYSTEM:TASK:TaskAlreadyMember"));            
        end         
        
    end
    
end


classdef removeTaskTest < matlab.unittest.TestCase
    
    methods (Test)
        function testRemovingTaskFromEmptyJob(testCase)            
            job = BuildSystem.Job();
            
            testCase.verifyWarning(...
                @()job.removeTask('Foo'),...
                'BUILDSYSTEM:removeTask:NoTaskInJob');            
        end
        
        function testRemovingTaskFromJob(testCase)            
            job = BuildSystem.Job();
            task1 = BuildSystem.Task('Foo','Sample description.','foo');
            job.addTask(task1);
            job.removeTask('Foo');
            testCase.verifyEqual(0,job.numberOfTasks);            
        end
        
    end
    
end


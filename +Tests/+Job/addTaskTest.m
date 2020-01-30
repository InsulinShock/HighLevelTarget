classdef addTaskTest < matlab.unittest.TestCase
    
    methods (Test)
        function testAddingTaskToEmptyJob(testCase)            
            job = BuildSystem.Job();
            task1 = BuildSystem.Task('Foo','Sample description.','foo');
            job.addTask(task1);            
            testCase.verifyEqual(1,job.numberOfTasks);            
        end
        
        function testAddingTasksToEmptyJob(testCase)
            job = BuildSystem.Job();
            tasks = [...
                BuildSystem.Task('Foo','Sample description','foo');...
                BuildSystem.Task('Bar','Sample description','bar')];
            job.addTask(tasks);
            testCase.verifyEqual(2,job.numberOfTasks); 
        end        
        
        function testAddingTaskToJob(testCase)
            job = BuildSystem.Job();
            task1 = BuildSystem.Task('Foo','Sample description.','foo');
            job.addTask(task1);
            task2 = BuildSystem.Task('Bar','Sample description.','bar');
            job.addTask(task2);
            testCase.verifyEqual(2,job.numberOfTasks); 
        end        
        
        function testAddingTaskAlreadyInJob(testCase)
            
            job = BuildSystem.Job();
            task1 = BuildSystem.Task('Foo','Sample description.','foo');                   
            job.addTask(task1);
            
            testCase.verifyError(...
                @() job.addTask(task1),...
                char("BUILDSYSTEM:TASK:TaskAlreadyMember"));            
        end
        
        function testAddingTasksWithTaskAlreadyInJob(testCase)
            
            job = BuildSystem.Job();
            task1 = BuildSystem.Task('Foo','Sample description.','foo');                   
            job.addTask(task1);
            
            tasks = [...
                task1;...
                BuildSystem.Task('Bar','Sample description','bar')];
                        
            testCase.verifyError(...
                @() job.addTask(tasks),...
                char("BUILDSYSTEM:TASK:TaskAlreadyMember"));            
        end
        
        function testAddingTasksWithTasksAlreadyInJob(testCase)
            
            job = BuildSystem.Job();
            tasks = [...
                BuildSystem.Task('Foo','Sample description.','foo');...
                BuildSystem.Task('Bar','Sample description','bar')];
            job.addTask(tasks);                        
            
            testCase.verifyError(...
                @() job.addTask(tasks),...
                char("BUILDSYSTEM:TASK:TaskAlreadyMember"));            
        end
        
    end
    
end


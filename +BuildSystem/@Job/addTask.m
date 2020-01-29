function obj = addTask(obj,task)
%ADDTASK Summary of this function goes here
%   Detailed explanation goes here

arguments
    obj (1,1) BuildSystem.Job
    task (:,1) BuildSystem.Task
end

if ~isempty(obj.TaskGraph.Nodes)
    nodes = obj.TaskGraph.Nodes.Task;
    taskNames = [nodes.Name]';
    
    Lia = ismember([task.Name]',taskNames);
    assert(~any(Lia),...
        "BUILDSYSTEM:TASK:TaskAlreadyMember",...
        "Tasks: (" + join(taskNames(Lia),", ") + ...
        ") are already included in the job.");
end

nodes = table([task.Name]', task, ...
    'VariableNames', {'Name' 'Task'});

obj.TaskGraph = addnode(obj.TaskGraph,nodes);

end
function obj = addTask(obj,task)
%ADDTASK Summary of this function goes here
%   Detailed explanation goes here

arguments
    obj (1,1) BuildSystem.Job
    task (:,1) BuildSystem.Task
end

if ~isempty(obj.TaskGraph.Nodes)
    Lia = ismember([task.Name]',[obj.TaskGraph.Nodes.Task.Name]);
    assert(~any(Lia),...
        "BUILDSYSTEM:TASK:TaskAlreadyMember",...
        "Tasks: (" + join(task(Lia).Name,", ") + ...
        ") are already included in the job.");
end

nodes = table([task.Name]', task, ...
    'VariableNames', {'Name' 'Task'});

obj.TaskGraph = addnode(obj.TaskGraph,nodes);

end
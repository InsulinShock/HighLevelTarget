function obj = removeTask(obj,taskName)
%ADDTASK Summary of this function goes here
%   Detailed explanation goes here

arguments
    obj (1,1) BuildSystem.Job
    taskName (1,1) string
end

if obj.TaskGraph.numnodes == 0
    warning("BUILDSYSTEM:removeTask:NoTaskInJob",...
        "BuildSystem contains no tasks; taking no action.");
    return;
end

if ~isempty(findnode(obj.TaskGraph,taskName))
    obj.TaskGraph = rmnode(obj.TaskGraph,taskName);
else
    warning("BuildSystem does not contain task (" + taskName + "); taking no action.");
end

end

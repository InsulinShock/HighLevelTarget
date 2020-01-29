function obj = removeTask(obj,taskName)
%ADDTASK Summary of this function goes here
%   Detailed explanation goes here

arguments
    obj (1,1) highleveltarget.BuildSystem.Job
    taskName (1,1) highleveltarget.BuildSystem.Task
end

obj.TaskDigraph = rmnode(obj.TaskDigraph,taskName);

end

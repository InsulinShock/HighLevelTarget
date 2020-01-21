function obj = removeTask(obj,taskName)
%ADDTASK Summary of this function goes here
%   Detailed explanation goes here

obj.TaskDigraph = rmnode(obj.TaskDigraph,taskName);

end

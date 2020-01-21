function obj = removeTask(obj,taskFunctionName)
%ADDTASK Summary of this function goes here
%   Detailed explanation goes here

obj.TaskDigraph = rmnode(obj.TaskDigraph,taskFunctionName);

end

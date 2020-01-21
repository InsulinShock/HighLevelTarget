function obj = addTask(obj,taskFunctionName)
%ADDTASK Summary of this function goes here
%   Detailed explanation goes here

obj.TaskDigraph = addnode(obj.TaskDigraph,taskFunctionName);

end
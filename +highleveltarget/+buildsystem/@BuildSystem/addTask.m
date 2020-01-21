function obj = addTask(obj,taskName,funcName)
%ADDTASK Summary of this function goes here
%   Detailed explanation goes here

node.Name = {char(taskName)};
node.Function = string(funcName);

obj.TaskDigraph = addnode(obj.TaskDigraph,struct2table(node));

end
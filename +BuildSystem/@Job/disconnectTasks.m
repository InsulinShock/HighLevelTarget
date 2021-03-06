function obj = disconnectTasks(obj,startTask,endTask)
%CONNECTTASKS Summary of this function goes here
%   Detailed explanation goes here

assert( numel(startTask) == numel(endTask),...
        "BUILDSYSTEM:connectTasks:tasksUnmatched",...
        "Number of startTaskFunctionName and endTaskFunctionName must be equal.");
    
k = find(findnode(obj.TaskDigraph,startTask) == 0);
assert(isempty(k),...
        "BUILDSYSTEM:connectTasks:taskNotFound",...
        "Start tasks: '" + join(startTask(k),",") + "' were not found."); 

k = find(findnode(obj.TaskDigraph,endTask) == 0);       
assert(isempty(k),...
        "BUILDSYSTEM:connectTasks:taskNotFound",...
        "End tasks: '" + join(endTask(k),",") + "' were not found.");
    
obj.TaskDigraph = rmedge(obj.TaskDigraph,startTask,endTask);

end
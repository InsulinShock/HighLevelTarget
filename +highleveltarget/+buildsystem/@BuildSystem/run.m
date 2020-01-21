function obj = run(obj,info)

N = toposort(obj.TaskDigraph,'Order','stable');
obj.Data = containers.Map;

for ii = 1:numel(N)
    
    tmp = inputDigraph.Nodes.Variables;
    currentID = tmp{N(ii)};    
    
    preIDs = predecessors(obj.TaskDigraph,currentID);    
    
    obj.Data(currentID) = feval(currentID,info,deal(obj.Data.values(preIDs)));
end

end


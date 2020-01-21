function runDigraph(inputDigraph,buildInfo,codeInfo)
%RUNDIGRAPH Summary of this function goes here
%   Detailed explanation goes here


highleveltarget.buildsystem.validateDigraphAttributes(inputDigraph);

N = toposort(inputDigraph,'Order','stable');
data = containers.Map;

for ii = 1:numel(N)
    
    tmp = inputDigraph.Nodes.Variables;
    currentID = tmp{N(ii)};    
    
    preIDs = predecessors(inputDigraph,currentID);    
    
    data(currentID) = feval(currentID,buildInfo,codeInfo,deal(data.values(preIDs)));
end

end
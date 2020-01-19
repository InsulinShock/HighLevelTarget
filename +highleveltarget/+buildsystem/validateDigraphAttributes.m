function validateDigraphAttributes(inputDigraph)
%VALIDATEDIGRAPH Summary of this function goes here
%   Detailed explanation goes here

assert(isdag(inputDigraph),...
    "HIGHLEVELTARGET:buildSystem:digraphNotAcyclic",...
    "Build system digraph must be acyclic; cannot contain loops.");

indeg = indegree(inputDigraph);

assert(indeg(1) == 0,...
    "HIGHLEVELTARGET:buildSystem:digraphNode1OutputOnly",...
    "First node of build system digraph can only have output edges.");


end


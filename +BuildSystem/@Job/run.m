function obj = run(obj,info)

taskOrder = toposort(obj.TaskDigraph,'Order','stable');

num = numnodes(obj.TaskDigraph);



obj.Display.Children.Children 

for ii = 1:numel(taskOrder)
        
    currentTask = obj.TaskDigraph.Nodes.Name(taskOrder(ii));
    
    
    
    
    
    
    currentFunc = obj.TaskDigraph.Nodes.Function(taskOrder(ii));
    
    predecessorTasks = predecessors(obj.TaskDigraph,currentTask); 
        
    try
        highlight(obj.Display.Children.Children,taskOrder(ii),'NodeColor','blue');
        out = feval(...
            currentFunc,...
            info,...
            deal(obj.Data.values(predecessorTasks)));       
        obj.Data(string(currentTask)) = out;        
        highlight(obj.Display.Children.Children,taskOrder(ii),'NodeColor','green');       
    catch ex
        msg = "Build Task: " + string(currentTask) + newline() + ...
            string(ex.message) + newline();
        highlight(obj.Display.Children.Children,taskOrder(ii),'NodeColor','red');
        fprintf(2,msg);
        break; 
    end  
    
end

end




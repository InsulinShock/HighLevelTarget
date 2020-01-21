function obj = run(obj,info)

N = toposort(obj.TaskDigraph,'Order','stable');
obj.Data = containers.Map;

obj.Display.Children.Children 

for ii = 1:numel(N)
        
    currentTask = obj.TaskDigraph.Nodes.Name(N(ii));
    currentFunc = obj.TaskDigraph.Nodes.Function(N(ii));
    
    predecssorTasks = predecessors(obj.TaskDigraph,currentTask); 
        
    try
        highlight(obj.Display.Children.Children,N(ii),'NodeColor','blue');
        out = feval(...
            currentFunc,...
            info,...
            deal(obj.Data.values(predecssorTasks)));       
        obj.Data(string(currentTask)) = out;        
        highlight(obj.Display.Children.Children,N(ii),'NodeColor','green');       
    catch ex
        msg = "Build Task: " + string(currentTask) + newline() + ...
            string(ex.message);
        highlight(obj.Display.Children.Children,N(ii),'NodeColor','red');
        display(msg);
        break;            
    end  
    
end

end




function obj = show(obj)
%DISPLAY Summary of this function goes here
%   Detailed explanation goes here

graphPlot = plot(obj.TaskDigraph);
graphPlot.Marker = 's';
graphPlot.MarkerSize = 8;
graphPlot.NodeColor = 'black';
ax = graphPlot.Parent;
obj.Display = ax.Parent;
obj.Display.Name = "Build System";
obj.Display.NumberTitle = "off";

dcm_obj = datacursormode;
dcm_obj.UpdateFcn = @(x,event_obj) highleveltarget.buildsystem.BuildSystem.digraphCustomDataTip(...
    x,event_obj,obj.TaskDigraph.Nodes);

end


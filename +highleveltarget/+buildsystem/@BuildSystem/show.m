function show(obj)
%DISPLAY Summary of this function goes here
%   Detailed explanation goes here

h = plot(obj.TaskDigraph);
ax = h.Parent;
fig = ax.Parent;
fig.Name = "Build System";
fig.NumberTitle = "off";

end
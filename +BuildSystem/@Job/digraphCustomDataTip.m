function txt = digraphCustomDataTip(~,event_obj,NodeProperties)

h = get(event_obj,'Target');
pos = get(event_obj,'Position');
ind = find(h.XData == pos(1) & h.YData == pos(2), 1);


txt = {"Task: " + string(NodeProperties.Name(ind)), ...
    "Function: " + NodeProperties.Function(ind)};
end
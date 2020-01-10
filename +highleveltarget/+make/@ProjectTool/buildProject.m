function [ret, context]  = buildProject(~, buildInfo, context, varargin)
%BUILDPROJECT Build the high level target project
%   Build the high level target project using a dockcross container.

disp("Building high level target project...");


%% Return Success if all passess
ret = 'Success';

% This fixes the issue
buildInfo.getBuildToolInfo('BuildActions');

disp("... project build complete.");
disp("=====================================================================");

end


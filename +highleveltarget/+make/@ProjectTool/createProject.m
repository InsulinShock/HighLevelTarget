function [ret, context] = createProject(~, buildInfo, context, varargin) 
%CREATEPROJECT Create an high level target project 
%   Create a high level target project including CMake files, main.cc, and
%   additional build files.

disp("Creating high level target project...");

%% Get the ToolchainInfo
toolchainInfo = varargin{1};

%% Get the CodeInfo
codeInfo = matfile('codeInfo.mat');

%% Returning the Model Name 
ret = buildInfo.ModelName;

context.ActiveBuildConfiguration

disp(ret)
disp("... project creation complete.");
disp("=====================================================================");

end
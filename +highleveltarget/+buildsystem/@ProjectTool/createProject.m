function [ret, context] = createProject(~, buildInfo, context, varargin) 
%CREATEPROJECT Create an high level target project 
%   Create a high level target project including CMake files, main.cc, and
%   additional build files.

%% Get the ToolchainInfo
toolchainInfo = varargin{1};

codeInfoFile = matfile('codeInfo.mat');
codeInfo = codeInfoFile.codeInfo;



context.ActiveBuildConfiguration


comp = varargin{3};

disp(comp.ToolchainFlags.getValue('Visualization').custom.value);
disp(comp.ToolchainFlags.getValue('Directed Graph (digraph) MAT File').custom.value);



digraphFile = matfile(comp.ToolchainFlags.getValue('Directed Graph (digraph) MAT File').custom.value);
buildSystemDigraph = digraphFile.buildSystemDigraph;

highleveltarget.buildsystem.runDigraph(digraphFile.buildSystemDigraph,buildInfo,codeInfo);



ret = buildInfo.ModelName;

end








function [ret, context] = initialize(~, buildInfo, context, varargin)  
%INITIALIZER Initialize High Level Target Project
%   Initialize the project generation
ret = true;

% buildInfo.setBuildToolInfo('BuildActions',...
%     [coder.make.enum.BuildAction.GENERATE_ARTIFACT,...  
%     coder.make.enum.BuildAction.BUILD,...
%     coder.make.enum.BuildAction.EXECUTE,...
%     coder.make.enum.BuildAction.DOWNLOAD]);
            
disp("Initializing project generation and running code generation checks...");
buildInfo.BuildTools.CustomToolchainOptions;

disp("... project initialization complete.");
disp("=====================================================================");

end


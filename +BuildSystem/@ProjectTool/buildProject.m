function [ret, context]  = buildProject(~, buildInfo, context, varargin)
%BUILDPROJECT Build the high level target project
%   Build the high level target project using a dockcross container.

toolchainInfo = varargin{1};

codeInfoFile = matfile('codeInfo.mat');
codeInfo = codeInfoFile.codeInfo;

disp(context.ActiveBuildConfiguration);





%% Return Success if all passess (Legacy)
ret = 'Success';

end


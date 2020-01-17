function rtwTargetInfo(tr)
%   Copyright 2018 The MathWorks, Inc.
% To reset toolchains, RTW.TargetRegistry.getInstance('reset')
tr.registerTargetInfo(@loc_createToolchain);

end

function config = loc_createToolchain

config = coder.make.ToolchainInfoRegistry; % initialize
archName = computer('arch');

config(end+1).Name             = 'Cross Compiler';
config(end).TargetHWDeviceType = {'*'};
config(end).FileName           = fullfile(highleveltarget.utilities.getRootFolder, 'registry', 'toolchain.mat');
config(end).Platform           = {archName};

end
function rtwTargetInfo(tr)
%RTWTARGETINFO Register toolchain and target
 
% Copyright 2013-2016 The MathWorks, Inc.
tr.registerTargetInfo(@loc_createToolchain);
tr.registerTargetInfo(@loc_createPILConfig);

doNotEvaluateFcnHandlesImmediately = false;
codertarget.TargetRegistry.addToTargetRegistry(@loc_registerThisTarget, doNotEvaluateFcnHandlesImmediately);
codertarget.TargetBoardRegistry.addToTargetBoardRegistry(@loc_registerBoardsForThisTarget, doNotEvaluateFcnHandlesImmediately);
end

%--------------------------------------------------------------------------
function config = loc_createToolchain
rootDir = fileparts(mfilename('fullpath'));
config = coder.make.ToolchainInfoRegistry; % initialize
archName = computer('arch');


% LINARO GNUARM 4.8
config(end+1).Name              = 'Linaro Toolchain v4.8';
config(end).Alias               = ['LINARO_GNU_ARM_LINUX_4_8_', upper(archName)];
config(end).TargetHWDeviceType	= {'*'};
config(end).FileName            = fullfile(rootDir, ['gcc_linaro_arm_linux_gnueabihf_gmake_', archName, '_v4.8.mat']);
config(end).Platform            = {archName};

% Wind River Workbench GNU ARM
config(end+1).Name              = 'Wind River Workbench GNU ARM 4.8.1';
config(end).Alias               = ['WRVXWORKS7GNUARM_481_', upper(archName)];
config(end).TargetHWDeviceType	= {'*'};
config(end).FileName            = fullfile(rootDir, ['wrworkbenchgnuarm_gmake_', archName, '_v4.8.1.mat']);
config(end).Platform            = {archName};

% Wind River Workbench DIAB
config(end+1).Name              = 'Wind River Workbench DIAB 5.9.4.0';
config(end).Alias               = ['WRVXWORKS7DIAB_5940_', upper(archName)];
config(end).TargetHWDeviceType	= {'*'};
config(end).FileName            = fullfile(rootDir, ['wrworkbenchdiabarm_gmake_', archName, '_v5.9.4.0.mat']);
config(end).Platform            = {archName};


end

% -------------------------------------------------------------------------
function ret = loc_registerThisTarget()
ret.Name = 'ARM Cortex-A (AArch32)';
ret.ShortName = 'armcortexa';
[targetFilePath, ~, ~] = fileparts(mfilename('fullpath'));
targetFilePath = fullfile(targetFilePath, '..');
ret.TargetFolder = targetFilePath;
ret.AliasNames = {'ARM Cortex-A'};

[~, sppkgNameTagDir] = codertarget.arm_cortex_a.internal.getInstallDir();
tgtDir = fullfile(sppkgNameTagDir, 'resources');
if isdir(tgtDir)
    a = registerrealtimecataloglocation(sppkgNameTagDir); %#ok<NASGU>
end
end
 
% -------------------------------------------------------------------------
function boardInfo = loc_registerBoardsForThisTarget()
target = 'ARM Cortex-A';
[targetFolder, ~, ~] = fileparts(mfilename('fullpath'));
targetFolder = fullfile(targetFolder, '..');
boardFolder = codertarget.target.getTargetHardwareRegistryFolder(targetFolder);
boardInfo = codertarget.target.getTargetHardwareInfo(targetFolder, boardFolder, target);
end

% -------------------------------------------------------------------------
function config = loc_createPILConfig
config(1) = rtw.connectivity.ConfigRegistry;
config(1).ConfigName = 'ARM Cortex-A9 (QEMU)';
config(1).ConfigClass = 'codertarget.arm_cortex_a.pil.ConnectivityConfig';
config(1).HardwareBoard = {'ARM Cortex-A9 (QEMU)'};
end

% [EOF]

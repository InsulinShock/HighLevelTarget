function rtwTargetInfo(tr)
%RTWTARGETINFO Register toolchain and target
 
% Copyright 2013-2016 The MathWorks, Inc.
tr.registerTargetInfo(@loc_register_toolchain);
tr.registerTargetInfo(@loc_register_hardware);

end


function config = loc_register_toolchain

config      =       coder.make.ToolchainInfoRegistry;
config.Name =       'Dockcross';
config.FileName =   fullfile(...
    highleveltarget.utilities.getRootFolder,...
    'registry','toolchain.mat');
end

function hw = loc_register_hardware
    hw = RTW.HWDeviceRegistry;
    hw.Vendor = 'MyManufacturer';
    hw.Type = 'MyDevice';
    hw.Alias = {};
    hw.Platform = {'Prod', 'Target'};
    hw.setWordSizes([8 16 32 64 64 64 64 64 64 64 64]);
    hw.Endianess = 'Little';
    hw.IntDivRoundTo = 'Zero';
    hw.ShiftRightIntArith = true;
    hw.LargestAtomicInteger = 'Long';
    hw.LargestAtomicFloat = 'Double';
end











function generateToolchainFile()
%GENERATETOOLCHAINFILE Generate and save toolchain MAT file
%
% Copyright 2019 The MathWorks, Inc.
%

[toolchain, ~] = highleveltarget.toolchain.generateToolchain();

fileName = fullfile(...
    highleveltarget.utilities.getRootFolder(),...
    'registry','toolchain.mat');

file = matfile(...
    fileName,...
    'Writable',true);
file.tc = toolchain;

assert(logical(toolchain.validate),'Toolchain failed validation');

rehash;
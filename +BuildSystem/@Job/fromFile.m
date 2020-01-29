function obj = fromFile(filename)
%FROMFILE Summary of this function goes here
%   Detailed explanation goes here

[~,~,ext] = fileparts(filename);
assert( strcmp(ext,"mat"),...
        "BUILDSYSTEM:fromFile:not",...
        "Build System must be loaded from MAT file.");

fileObj = matfile(filename);
fields = fieldnames(fileObj,'-full');



obj = [];


end


function [status,result] = docker(cmd)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

cmd =   "wsl -d Ubuntu " + ...
        " -- " + string(cmd);

[status,result] = system(cmd);

assert(status==0,result);

end


function [status,result] = dockcross(os,platform,cmd)
%DOCKCROSS Summary of this function goes here
%   Detailed explanation goes here

import highleveltarget.utilities.*

cmd =   "wsl -d Ubuntu " + ...
        " -- " + ...
        join([getRootFolder("wsl"),"tools","dockcross-"+os+"-"+platform],"/") + ...
        " " + ...
        "bash -c '" + cmd + "'";

[status,result] = system(cmd);

assert(status==0,result);

end
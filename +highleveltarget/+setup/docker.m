function docker()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


[s,r] = system("wsl bash -c 'echo " + mypassword + " | sudo -S ./scripts/setup_docker.sh'");


end


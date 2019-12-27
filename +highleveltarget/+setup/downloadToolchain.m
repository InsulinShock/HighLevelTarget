function downloadToolchain()
%DOWNLOADTOOLCHAIN Summary of this function goes here
%   Detailed explanation goes here


toolchainName = "gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz";
toolsDirectory = fullfile(highleveltarget.utilities.getRootFolder(),"tools");




currentFolder = pwd;
cd(fullfile(highleveltarget.utilities.getRootFolder,"tools"));
[result,status] = system("tar -xvf " + toolchainName);
cd(currentFolder);

assert(result == 0, status);

end


function downloadToolchainWindows(filename,url)

xzdecompressor = websave(...
    fullfile(highleveltarget.utilities.getRootFolder,"tools","
);






websave(filename,url)

end








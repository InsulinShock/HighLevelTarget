function rootFolder = getRootFolder()
%GETROOTFOLDER Get the root folder of the toolbox

[filepath,~,~] = fileparts(mfilename('fullpath'));
folderparts = strsplit(string(filepath),string(filesep));
rootFolder = join(folderparts(1:end-2),filesep);

end


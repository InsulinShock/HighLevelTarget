function rootFolder = getRootFolder(varargin)
%GETROOTFOLDER Get the root folder of the toolbox

[filepath,~,~] = fileparts(mfilename('fullpath'));
folderparts = strsplit(string(filepath),string(filesep));
rootFolder = join(folderparts(1:end-2),"/");

if nargin > 0
    if strcmp(varargin{1},"wsl")
        rootFolderParts = strsplit(rootFolder,":");
        
        rootFolderParts(1) = join(["/mnt",lower(rootFolderParts(1))],"/");        
        
        rootFolder = join(rootFolderParts,"");
    end
end

end


classdef Executor0 < coder.make.MakefileExecutor
    % Makefile executor class for remote build
    
    % Copyright 2018-2019 The MathWorks, Inc.
    properties (Constant, Access = private)
        EXTLIST = {'.c' '.C' '.cpp' '.CPP' '.cu' '.CU' '.s' '.S'};
        INCEXTLIST = {'.h' '.H', '.hpp', '.HPP'};
        ALTINCEXTLIST = {'*.h' '*.H', '*.hpp', '*.HPP'};
        EXTTODELETE = '*.c *.C *.cpp *.CPP *.cu *.CU *.s *.S *.h *.H *.hpp *.HPP'
    end
    
    methods
        % -----------------------------------------------------------------
        % Constructor
        % -----------------------------------------------------------------
        function h = Executor0(builder, buildInfo, artifact)
            % Invoke base class constructor
            h@coder.make.MakefileExecutor(builder, buildInfo, artifact);
        end
        
        % -----------------------------------------------------------------
        % Invoke the BUILD tool
        % -----------------------------------------------------------------
        function [success, problem] = build(h, buildInfo)       %#ok<*INUSD>
            % Remote build method
            %
            
            % Update buildInfo
            updateFilePathsAndExtensions(buildInfo,h.EXTLIST,h.INCEXTLIST);
            % ignoreParseError converts parsing errors from findIncludeFiles into warnings
            sWarning = warning('off','RTW:buildInfo:ignoreFindIncludeParseError');
            findIncludeFiles(buildInfo, ...
                'extensions', h.ALTINCEXTLIST, ...
                'ignoreParseError', true);
            warning(sWarning.state,'RTW:buildInfo:ignoreFindIncludeParseError');
            
            % Replace the define '-DRT' with '-DRT=RT'. This define clashes with a
            % definition in BOOST math library
            defToReplace.Name = 'RT';
            defToReplace.ReplaceWith = 'RT=RT';
            loc_replaceDefines(buildInfo, defToReplace);
            
            %% Prepare for build
            hw = nvidiaboard(true);
            
            %% Compute build directory on remote target
            bDir = pwd;
            targetWorkspaceDir = nvidiacoder.getRemoteBuildDir;
            % Evaluate Linux environment variables, such as ~ or $HOME, in
            % remote build directory name
            targetWorkspaceDir = strtrim(system(hw,['echo -n ' targetWorkspaceDir]));
            targetBuildDir = nvidiacoder.internal.w2l(fullfile(targetWorkspaceDir,bDir));
            
            % Get the list of files needed for build
            tool = h.ToolchainInfo.BuilderApplication;
            filePaths = getFullFileList(buildInfo,'source');
            filePaths = [filePaths getFullFileList(buildInfo,'include')];
            nonBuildFiles = getFullFileList(buildInfo,'nonbuild');
            nonBuildFiles = nonBuildFiles(~contains(nonBuildFiles,{'.dll'}));
            filePaths = [filePaths tool.IncludeFiles nonBuildFiles];     
            targetMkFileName = h.BuildArtifacts{1};
            filePaths = [filePaths fullfile(bDir,targetMkFileName)];
            filePaths = [filePaths fullfile(bDir,'rtw_proj.tmw')];
            for k = 1:numel(filePaths)
                % PIL build seeks the codertarget_assembly_flags.mk file
                % either in the build directory or the directory above the
                % build directory.
                if ~isempty(strfind(filePaths{k},'codertarget_assembly_flags.mk')) && ...
                        exist(filePaths{k},'file') ~= 2
                    [p,n,e] = fileparts(filePaths{k});
                    filePaths{k} = fullfile(p,'..',[n e]);
                end
            end
            
            %% Eliminate non-existent files
            filePaths = pruneFiles(filePaths);
            
            %% Transfer files to remote host
            loc_prepareForBuild(hw,[buildInfo.ModelName '.elf']);
            system(hw,['rm -fr ' targetBuildDir '; mkdir -p ' targetBuildDir]);
            dlist = {};
            
           [filePaths,dlist] = nvidiacoder.internal.checksum.verifyChecksumAndUpdateWeightFiles(h,hw,filePaths,targetWorkspaceDir,dlist);
           %conditionally removes nonBuildFiles from filepaths if pre-saved
            %checksum matches computed checksum for binary weight files
    
            for k = 1:numel(filePaths)
                [d,f,ext] = fileparts(nvidiacoder.internal.w2l(filePaths{k}));
                remoteDir = loc_fullLnxFile(targetWorkspaceDir,d);
                if ~ismember(d,dlist)
                    system(hw,['mkdir -p ' remoteDir]);
                    dlist{end+1} = d; %#ok<AGROW>
                end
                scpPutFile(hw.Ssh,filePaths{k},loc_fullLnxFile(remoteDir,[f ext]));
            end
            
            %% Transfer sharedutils to remote host
            [~, sharedSrcArg] = buildInfo.findBuildArg('SHARED_SRC');
            if ~isempty(sharedSrcArg)
                [sharedSrcDir,f,e] = fileparts(sharedSrcArg);
                if loc_isAbsPath(sharedSrcDir)
                    sharedSrcFileSpec = fullfile(sharedSrcArg);
                else
                    % Normally sharedSrcFolder is a relative path (if using central shared
                    % utilities, it is an absolute path)
                    sharedSrcFullPath = fullfile(bDir,sharedSrcDir);
                    sharedSrcFullPath = loc_reduceDotDot(sharedSrcFullPath);
                    sharedSrcFileSpec = fullfile(sharedSrcFullPath,[f e]);
                end
                putFile(hw,sharedSrcFileSpec,...
                    loc_fullLnxFile(targetBuildDir,sharedSrcDir));
            end
            
            %% BUILD
            % Change both last access and modification time of all files in
            % the project folder. This command synchronizes the timestamps
            % of the project files to that of the remote Linux system. -c:
            % do not create any (new) files
                        
            buildCmd = ['touch -c ' targetBuildDir  '/*.*;'];
            tmpBldOpts = buildInfo.getBuildToolInfo('BuildOpts');
                       
            buildCmd = [buildCmd h.Command.build ' MATLAB_WORKSPACE="' targetWorkspaceDir '" -C ' targetBuildDir];
            try   
                problem = system(hw,buildCmd);  
                
            catch ME
                rethrow(ME);
            end
            
            if strcmp(buildInfo.BuildTools.BuildVariant,'STANDALONE_EXECUTABLE') && ~tmpBldOpts.checkStatusOnly
                % Preserving target build directory to use for
                % workspaceDir property in nvidiaboard class. We are 
                % finding whether user opted to generated code in a custom
                % directory or not. If so, we truncate path by one level
                % otherwise truncate path by three levels.
                tempPath = strsplit(targetBuildDir,'/');
                defCodegenDirIndx = find(ismember(tempPath,'codegen'));
                if defCodegenDirIndx
                    nvidiaboard.setgetWorkspaceDir(fileparts(fileparts(fileparts(targetBuildDir))));
                else
                    nvidiaboard.setgetWorkspaceDir(fileparts(targetBuildDir));
                end
            end
                
            % Bring required files back to host
            if isBuildObjOnly(h.Parent)
                % Top XIL build object files only. These object files
                % need not to be brought back to host
                getFile(hw,[targetBuildDir '/*.o'],bDir);
            else
                % Get final product from Builder class. Compute final
                % product on remote file system. Retrieve executable
                % back to host. PIL infra-structure checks if the final
                % product (i.e. the executable ~ ..\<model name>.elf
                % is generated on the host file system.
                % RELATIVE_PATH_TO_ANCHOR is always a relative path from the
                % BUILD_DIR back to START_DIR. BUILD_DIR is always underneath
                % START_DIR, or the same as START_DIR.
                % OUTPUT_DIR = buildInfo.Settings.BuildInfoOutputFolder
                pr = expandMacros(getFinalProduct(h.Parent),h.Parent.Components.Macros);
                if nvidiacoder.internal.isRelativePath(pr)
                    % This means the final product is found relative to the
                    % BUILDDIR where MK file was generated.
                    % RELATIVE_PATH_TO_ANCHOR is the relative path from BUILD_DIR
                    % to START_DIR (buildInfo.Settings.LocalAnchorDir)
                    remotePr = nvidiacoder.internal.w2l(loc_fullLnxFile(targetWorkspaceDir,bDir,pr));
                else
                    remotePr = nvidiacoder.internal.w2l(loc_fullLnxFile(targetWorkspaceDir,pr));
                end
                remotePr = loc_fullLnxFile(loc_reduceDotDot(remotePr));
                getFile(hw,remotePr,pr);
            end
            
            % Play nice
            success = 1;
            problem = [problem newline '### Successfully generated all binary outputs.'];
        end
    end % public methods
    
end % classdef

%--------------------------------------------------------------------------
function loc_replaceDefines(buildInfo, defToRemove)
def = buildInfo.getDefines;
for j = 1:numel(defToRemove)
    for k = 1:numel(def)
        if isequal(def{k}, ['-D', defToRemove(j).Name])
            buildInfo.deleteDefines(defToRemove(j).Name);
            buildInfo.addDefines(defToRemove(j).ReplaceWith);
            break;
        end
    end
end
end

function file = loc_fullLnxFile(varargin)
% Convert paths to Linux convention.
file = strrep(varargin{1}, '\', '/');
for i = 2:nargin
    file = [file '/' strrep(varargin{i},'\','/')]; %#ok<AGROW>
end
file = strrep(file, '//', '/');
file = regexprep(file, '/$', '');  %remove trailing slash
file = regexprep(file, '\s', '\ '); %escape spaces
file = strtrim(file);               %remove leading / trailing white space
end

function loc_prepareForBuild(hw,remoteAppName)
% Prepare for build by killing the application running on remote target. This
% improves build speed.
try
    % Killall returns an error when application is not running. Hence the
    % try-catch.
    killApplication(hw,remoteAppName);
catch
end
end

function isAbs = loc_isAbsPath(filePath)
%LOC_ISABSPATH returns true if the path is absolute
expr = '^(([A-Za-z]:(\\|\/))|(/)|(\\\\[A-Za-z])|(//[A-Za-z]))';
match = regexp(filePath,expr,'once','lineanchors');
if ~isempty(match)
    isAbs = true;
else
    isAbs = false;
end
end

function pathOut = loc_reduceDotDot(pathIn)
%LOC_REDUCEDOTDOT simplifies a path containing folder/..
[p,f,e] = fileparts(pathIn);
parts = {};
while ~isempty(f)
    folder = [f e];
    if ~isempty(parts) && ~strcmp(folder, '..') && strcmp(parts{end}, '..')
        parts = parts(1:end-1);
    else
        parts{end+1} = folder; %#ok<AGROW>
    end
    [p,f,e] = fileparts(p);
end

pathOut = p;
while ~isempty(parts)
    pathOut = fullfile(pathOut,parts{end});
    parts = parts(1:end-1);
end
end

function filePaths = pruneFiles(filePaths)
% Remove files that do not exist on the host computer from the filePaths
% cell array
indx = cellfun(@(x) exist(x,'file'),filePaths);
filePaths(indx == 0) = [];
end

function deleteBuildArtifacts(hwObj,h,buildInfo,targetBuildDir)
if ~isSLCUsed(h,buildInfo.ModelName)
    system(hwObj,['cd ' targetBuildDir ' && rm -f ' h.EXTTODELETE]);
end
end

function str = expandMacros(str,macroList)
% Expand macros in the input string
% macroList is a structure array containing "macro" and "value" fields
% The macro does not containt $(..) characters
for k = 1:numel(macroList)
    str = replace(str,['$(' macroList(k).macro ')'],macroList(k).value);
end
end
%[EOF]
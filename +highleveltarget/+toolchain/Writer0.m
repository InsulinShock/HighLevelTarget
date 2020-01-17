classdef Writer0 < coder.make.GmakeWriter
    % Class that represents a gmake makefile writer for remote build.
    
    % Copyright 2018-2019 The MathWorks, Inc.
    properties
    end
    
    methods (Access = public)
        % -----------------------------------------------------------------
        % xxConstructor
        % -----------------------------------------------------------------
        function h = Writer0(builder, buildInfo)
            % Call base class constructor
            h@coder.make.GmakeWriter(builder, buildInfo);
            h.invokeBuilderOverrides(buildInfo);
        end
    end
    
    methods
        
        % -----------------------------------------------------------------
        % Remote build overrides to the Builder outputs
        function invokeBuilderOverrides(h,buildInfo)
            % Reformat all paths for remote build
            
            % MATLAB_WORKSPACE is the folder on the remote file system that
            % contains files required for build. Files are organized the
            % same way they are on the host. This Makefile variable is
            % defined as part of the build command in Executor. That is,
            %
            % $make -f foo.mk MATLAB_WORKSPACE="/home/nvidia/qe/MATLAB_ws"
            %
            % for example.
            workspaceDir = '$(MATLAB_WORKSPACE)';
            
            %% This is what coder.make.MakefileWriter.run does
            %             headerInfo = h.writeFileHeader( buildInfo );
            %             +h.writeMacros( buildInfo );
            %             h.writeToolchainSettings( buildInfo );
            %             h.writeProductInfo( buildInfo );
            %             +h.writeIncludePaths( buildInfo );
            %             h.writeDefines( buildInfo );
            %             +h.writeSourceFiles( buildInfo );
            %             +h.writeObjectFiles( buildInfo );
            %             +h.writePrebuiltObjectFiles( buildInfo );
            %             +h.writeLibraryFiles( buildInfo );
            %             h.writeSystemLibraries( buildInfo );
            %             h.writeFinalToolchainSettings( buildInfo );
            %             h.printInlinedCommands();
            %             h.writePhonyTargets( buildInfo );
            %             h.writeFinalTargets( buildInfo );
            %             +h.writeIntermediateTargets( buildInfo );
            %             h.writeDependencies( buildInfo );
            %             h.writeMiscellaneousTargets( buildInfo );
            %             % Replace all tokenized macros with correct reference symbol
            %             h.Buffer = h.replaceTokensWithReference( h.Buffer );
            %             %---------------------------
            %             % Write the artifact
            %             %---------------------------
            %             h.writeMakefile( buildInfo, headerInfo );
            
            % Set TCPIP server port value for PIL execution builds
            if h.Parent.BuildOpts.checkStatusOnly
                port = nvidiacoder.pil.getPILPort;
                h.Components.Defines(1).finalValue(end+1) = {['-DNVIDIA_TCPIP_SERVER_PORT=' num2str(port)]};
            end
            
            % Adding a macro for fullpath of weight files in DL workflow
            if ~h.BuildOpts.isMATLABCodeGen
                % Simulink codegen
                buildDirPath = pwd;
                buildDirPath =  nvidiacoder.internal.w2l(buildDirPath);
                buildDirPath = [workspaceDir  buildDirPath];
                h.Components.Defines(1).finalValue(end+1) = {['-DMW_DL_DATA_PATH=' buildDirPath]};
            else
                % MATLAB codegen
                h.Components.Defines(1).finalValue(end+1) = {'-DMW_DL_DATA_PATH="$(START_DIR)"'};
            end
            
            % OS will take care of FIFO scheduling on the target, so
            % disabling manual scheduling.
            h.Components.Defines(1).finalValue(end+1) = {['-DMW_SCHED_OTHER=' num2str(1)]};
            
            % Overwrite the Components for remote build
            h.Components.Macros = reformatMacros(h.Components.Macros,workspaceDir);
            h.Components.ObjectFiles = reformatObjectFiles(h.Components.ObjectFiles);
            h.Components.PrebuiltObjectFiles = reformatPaths(h.Components.PrebuiltObjectFiles,workspaceDir);
            h.Components.SourceFiles = reformatPaths(h.Components.SourceFiles,workspaceDir);
            h.Components.IncludeFiles = reformatPaths(h.Components.IncludeFiles,workspaceDir);
            h.Components.IncludePaths = reformatPaths(h.Components.IncludePaths,workspaceDir);
            h.Components.Libraries = reformatLibraries(h.Components.Libraries);
            reformatIntermediateTargets(h.Components.IntermediateTargets,workspaceDir);
            %reformatIntermediateTargetDependencyPaths(h.Components.IntermediateTargets);Yes
            %
            h.Components.FinalProduct = reformatFinalProduct(h.Components.FinalProduct,workspaceDir);
            
            % This is temporary solution to avoid errors which are occurred
            % due to C++ flags those are not supported by nvcc.
            % Adding -Xcompiler option to CPPFLAGS
            for x = 1:h.Components.ToolchainFlags.length()
                if strcmp(h.Components.ToolchainFlags.keys{x}, 'C++ Compiler') || strcmp(h.Components.ToolchainFlags.keys{x}, 'C Compiler')
                    cppFlag = h.Components.ToolchainFlags.values{x};
                    for y=1:numel(cppFlag.buildinfo)
                        if strcmp(cppFlag.buildinfo(y).macro, 'CPPFLAGS_SKIPFORSIL') || strcmp(cppFlag.buildinfo(y).macro, 'CFLAGS_SKIPFORSIL')
                            cppFlag.buildinfo(y).value{1} = ['-Xcompiler ', cppFlag.buildinfo(y).value{1}];
                            h.Components.ToolchainFlags.setValue(h.Components.ToolchainFlags.keys{x}, cppFlag);
                        end
                    end
                end
            end

            
            %% Local functions
            % Reformat paths to remove leading paths
            function list = reformatPaths(list,workspaceDir)
                if ~isempty(list)
                    for k = 1:numel(list.value)
                        if nvidiacoder.internal.isRelativePath(list.value{k})
                            list.value{k} = nvidiacoder.internal.w2l(list.value{k});
                        elseif nvidiacoder.internal.isLinuxPath(list.value{k})
                            list.value{k} = loc_fullLnxFile('/',...
                                nvidiacoder.internal.w2l(list.value{k}));
                        else
                            list.value{k} = loc_fullLnxFile(workspaceDir,...
                                nvidiacoder.internal.w2l(list.value{k}));
                        end
                    end
                end
            end
            
            function list = reformatObjectFiles(list)
                if ~isempty(list)
                    for k = 1:numel(list.value)
                        list.value{k} = nvidiacoder.internal.w2l(list.value{k});
                    end
                end
            end
            
            function list = reformatLibraries(list)
                for k = 1:numel(list)
                    if isstruct(list)
                        for m = 1:numel(list(k).value)
                            % value is a cell array of libraries
                            if nvidiacoder.internal.isLinuxPath(list(k).value{m})
                                list(k).value{m} = loc_fullLnxFile('/',list(k).value{m});
                            else
                                list(k).value{m} = loc_transformPath(list(k).value{m},workspaceDir);
                            end
                        end
                    else
                        % list is a cell array
                        for m = 1:numel(list{k}.value)
                            % value is a cell array of libraries
                            list{k}.value{m} = loc_transformPath(list{k}.value{m},workspaceDir);
                        end
                    end
                end
            end
            
            function list = reformatMacros(list,workspaceDir)
                for k = 1:numel(list)
                    if ismember(list(k).macro,{'START_DIR','MATLAB_ROOT','MATLAB_BIN','MATLAB_ARCH_BIN'})
                        if nvidiacoder.internal.isRelativePath(list(k).value)
                            list(k).OldValue = list(k).value;
                            list(k).value = nvidiacoder.internal.w2l(list(k).value);
                        else
                            list(k).OldValue = list(k).value;
                            list(k).value = loc_fullLnxFile(workspaceDir,nvidiacoder.internal.w2l(list(k).value));
                        end
                    end
                    if isequal(list(k).macro,'COMPUTER')
                        list(k).OldValue = list(k).value;
                        list(k).value = 'GLNX';
                    end
                    if isequal(list(k).macro,'ARCH')
                        list(k).OldValue = list(k).value;
                        list(k).value = 'glnx';
                    end
                    if isequal(list(k).macro,'RELATIVE_PATH_TO_ANCHOR')
                        if ~nvidiacoder.internal.isRelativePath(list(k).value)
                            % We are in codegen folder now.
                            list(k).OldValue = list(k).value;
                            list(k).value = nvidiacoder.internal.getRelativePath(list(k).value,pwd);
                        end
                    end
                end
            end
            
            function list = reformatFinalProduct(list,workspaceDir)
                list.RawOutputFileOld = list.RawOutputFile;
                list.RawOutputFile = loc_transformPath(list.RawOutputFile,workspaceDir);
            end
            
            function reformatIntermediateTargets(inTarget,workspaceDir)
                iter = coder.make.util.ListIterator(inTarget);
                pointToStart(iter);
                while ~iter.endOf()
                    srcToObj = iter.next();
                    for k = 1:numel(srcToObj.values)
                        % All targets are in the build directory
                        srcToObj.values{k}.TargetPath = ...
                            loc_transformPath(srcToObj.values{k}.TargetPath,workspaceDir);
                        for j = 1:numel(srcToObj.values{k}.DependencyPaths)
                            if nvidiacoder.internal.isLinuxPath(srcToObj.values{k}.DependencyPaths{j})
                                srcToObj.values{k}.DependencyPaths{j} = ...
                                    loc_fullLnxFile('/',nvidiacoder.internal.w2l(srcToObj.values{k}.DependencyPaths{j}));
                            else
                                srcToObj.values{k}.DependencyPaths{j} = ...
                                    loc_transformPath(srcToObj.values{k}.DependencyPaths{j},workspaceDir);
                            end
                        end
                    end
                end
            end
        end
    end % methods
end

%--------------------------------------------------------------------------
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

function p = loc_transformPath(p,workspaceDir)
if isempty(p)
    return;
end

% If relative path, just transform path to Unix format. If absolute path,
% pre-pend the work space directory.
if nvidiacoder.internal.isRelativePath(p)
    p = nvidiacoder.internal.w2l(p);
else
    p = loc_fullLnxFile(workspaceDir,nvidiacoder.internal.w2l(p));
end
end

% LocalWords:  gmake ws Toolchain Prebuilt tokenized GLNX glnx
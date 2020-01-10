function [tc, results] = generateToolchain()
%androidstudioproject Specifications for fake Android toolchain.

% Copyright 2015 The MathWorks, Inc.

toolchain.Platforms  = {computer('arch')};
toolchain.Versions   = {'3.15'};
toolchain.Artifacts  = {'cmake'};
toolchain.FuncHandle = str2func('getToolchainInfoFor');
toolchain.ExtraFuncArgs = {};
[tc, results] = coder.make.internal.generateToolchainInfoObjects(mfilename, toolchain, nargout);

end

% -------------------------------------------------------------------------
% Generate the ToolchainInfo object for the specified attributes.
% -------------------------------------------------------------------------
function tc = getToolchainInfoFor(~, ~, ~, varargin)

tc = coder.make.ToolchainInfo( ...
    'Name',                 'Cross Compiler', ...
    'BuildArtifact',        'Custom IDE Project', ...
    'Platform',             computer('arch'), ...
    'SupportedVersion',     'R2020a', ...
    'Revision',             '1.0');

tc.addAttribute('TransformPathsWithSpaces');
tc.setProjectTool('highleveltarget.make.ProjectTool')

%% Disable Default Build Tools
disableDefaultBuildTool('C Compiler');
disableDefaultBuildTool('Linker');
disableDefaultBuildTool('C++ Compiler');
disableDefaultBuildTool('C++ Linker');
disableDefaultBuildTool('Archiver');

    function disableDefaultBuildTool(toolname)
        buildTool = tc.getBuildTool(toolname);
        buildTool.setName("Dummy " + string(toolname));
        buildTool.setCommand(platformNoOperation());
        buildTool.CustomValidation = 'highleveltarget.toolchain.toolValidator';
        directives = buildTool.Directives;
        while ~isempty(directives)
            buildTool.Directives.remove(directives.keys{end})
        end
    end

%% Remove Default Postbuild Tools
tc.removePostbuildTool('Download');
tc.removePostbuildTool('Execute');


%% Add Project IDE Build Tool
idetool = coder.make.BuildTool('IDE Tool');
idetool.setLanguage("C++")
idetool.OptionsRegistry = {...   
    'Minimum CMake Version','MINIMUMCMAKEVERSION',...   %
    'Compiler Options','COMPILERFLAGS',...
    'Linker Options','LINKEROPTIONS',...
    'Common Options','COMMONOPTIONS'
    };

tc.addBuildTool('IDE Tool',idetool);

tc.setBuilderApplication(computer('arch'));
builderApplication = tc.BuilderApplication;
builderApplication.setDirective('FileSeparator','/');


%% Setup Build Configurations
setupBuildConfiguration();

    function setupBuildConfiguration()
        
        debugConfig = tc.getBuildConfiguration('Debug');
        removeDefaultBuildConfigurationOptions(debugConfig);
        options = containers.Map('KeyType','char','ValueType','char');
        options("Minimum CMake Version") = "3.0";
        setBuildConfigurationOptions(debugConfig,options);        
        
        fasterBuildConfig = tc.getBuildConfiguration('Faster Builds');
        removeDefaultBuildConfigurationOptions(fasterBuildConfig);
        options = containers.Map('KeyType','char','ValueType','char');
        options("Minimum CMake Version") = "3.0";
        setBuildConfigurationOptions(fasterBuildConfig,options);        
        
        fasterRunsConfig = tc.getBuildConfiguration('Faster Runs');
        removeDefaultBuildConfigurationOptions(fasterRunsConfig);
        options = containers.Map('KeyType','char','ValueType','char');
        options("Minimum CMake Version") = "3.0";
        setBuildConfigurationOptions(fasterRunsConfig,options);

    end
end


function setBuildConfigurationOptions(buildConfiguration,options)

keyName = keys(options);
value = values(options);
for i = 1:length(options)    
    buildItem = buildConfiguration.getOption(keyName{i});
    buildItem.setValue(value{i});    
end

end

function removeDefaultBuildConfigurationOptions(buildConfiguration)

buildConfiguration.Options.remove('Archiver');
buildConfiguration.Options.remove('C Compiler');
buildConfiguration.Options.remove('Linker');
buildConfiguration.Options.remove('C++ Compiler');
buildConfiguration.Options.remove('C++ Linker');
buildConfiguration.Options.remove('C++ Shared Library Linker');
buildConfiguration.Options.remove('Download');
buildConfiguration.Options.remove('Execute');
buildConfiguration.Options.remove('MEX C++ Compiler');
buildConfiguration.Options.remove('MEX C++ Linker');
buildConfiguration.Options.remove('MEX Compiler');
buildConfiguration.Options.remove('MEX Linker');
buildConfiguration.Options.remove('Shared Library Linker');
buildConfiguration.Options.remove('IDE Tool');

end

function noop = platformNoOperation()

switch true
    case ispc()
        noop = 'rem';        
    case isunix()
        noop = ':';
    case ismac
        noop = ':';  
    otherwise
        error("Not a supported operating system.");
end
end
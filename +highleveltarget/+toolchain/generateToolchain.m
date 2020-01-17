function [tc, results] = generateToolchain()
%androidstudioproject Specifications for fake Android toolchain.

% Copyright 2015 The MathWorks, Inc.

toolchain.Platforms  = {computer('arch')};
toolchain.Versions   = {'1.0'};
toolchain.Artifacts  = {'custom makefile'};
toolchain.FuncHandle = str2func('getToolchainInfoFor');
toolchain.ExtraFuncArgs = {};
[tc, results] = coder.make.internal.generateToolchainInfoObjects(mfilename, toolchain, nargout);

end

function tc = getToolchainInfoFor(platform, version, ~, varargin)

tc = coder.make.ToolchainInfo(...
    'Name', 'Cross Compiler', ...
    'BuildArtifact', 'Custom IDE Project', ...
    'SupportedLanguages', {'C/C++'}); %, ...
    % 'BuildArtifactWriter', 'highleveltarget.make.Writer', ...
    % 'BuildArtifactExecutor', 'highleveltarget.make.Executor');

disableDefaultBuildTools(tc);

removeDefaultBuildConfigurationOptions(tc);

removeDefaultPostbuildTools(tc);

addCustomBuildTool(tc);

tc.addAttribute('TransformPathsWithSpaces');
tc.setProjectTool('highleveltarget.make.ProjectTool');

end

function disableDefaultBuildTools(tc)

buildTools = tc.getBuildTools();

for ii = 1:numel(buildTools)
    bt = tc.getBuildTool(buildTools{ii});
    bt.setName(['Dummy ',bt.Name,' (Legacy)']);
    bt.setCommand('::');
    bt.CustomValidation = 'highleveltarget.toolchain.toolValidator';    
end

end

function removeDefaultBuildConfigurationOptions(tc)

bcs = tc.BuildConfigurations;
keys = bcs.keys;

for i = 1:numel(keys)
   buildConfiguration = bcs.getValue(keys{i}); 

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

end

function addCustomBuildTool(tc)

% Add Project IDE Build Tool
modernBuildTool = coder.make.BuildTool('IDE Tool');
modernBuildTool.setLanguage('C/C++')
modernBuildTool.OptionsRegistry = {...   
    'Minimum CMake Version','MINIMUMCMAKEVERSION',...   %
    'Compiler Options','COMPILERFLAGS',...
    'Linker Options','LINKEROPTIONS'
    };
modernBuildTool.CustomValidation = 'highleveltarget.toolchain.toolValidator';
tc.addBuildTool('IDE Tool',modernBuildTool);

tc.setBuilderApplication(computer('arch'));
builderApplication = tc.BuilderApplication;

end

function removeDefaultPostbuildTools(tc)

tc.removePostbuildTool('Download');
tc.removePostbuildTool('Execute');

end

% % -------------------------------------------------------------------------
% % Generate the ToolchainInfo object for the specified attributes.
% % -------------------------------------------------------------------------
% function tc = getToolchainInfoFor(platform, version, ~, varargin)
% 
% tc = coder.make.ToolchainInfo(...
%     'Name', 'Cross Compiler', ...
%     'BuildArtifact', 'custom makefile', ...
%     'SupportedLanguages', {'C/C++'}, ...
%     'BuildArtifactWriter', 'highleveltarget.make.Writer', ...
%     'BuildArtifactExecutor', 'highleveltarget.make.Executor');
% 
% tc.addAttribute('TransformPathsWithSpaces');
% tc.addAttribute('SupportsDoubleQuotes', false);
% tc.addAttribute('SupportsUNCPaths', false);
% 
% 
% 
% %% Add Project IDE Build Tool
% % modernBuildTool = coder.make.BuildTool('Modern Build Tool');
% % modernBuildTool.setLanguage("C/C++")
% % modernBuildTool.OptionsRegistry = {...   
% %     'Minimum CMake Version','MINIMUMCMAKEVERSION',...   %
% %     'Compiler Options','COMPILERFLAGS',...
% %     'Linker Options','LINKEROPTIONS'
% %     };
% % modernBuildTool.CustomValidation = 'highleveltarget.toolchain.toolValidator';
% % tc.addBuildTool('Modern Build Tool',modernBuildTool);
% 
% 
% disableDefaultBuildTool(tc.getBuildTool('Archiver'));
% disableDefaultBuildTool(tc.getBuildTool('C Compiler'))
% disableDefaultBuildTool(tc.getBuildTool('Linker'))
% disableDefaultBuildTool(tc.getBuildTool('C++ Compiler'))
% disableDefaultBuildTool(tc.getBuildTool('C++ Linker'))
% 
% 
% tc.setBuilderApplication(computer('arch'));
% builderApplication = tc.BuilderApplication;
% 
% 
% 
% %% Remove Default Postbuild Tools
% %tc.removePostbuildTool('Download');
% %tc.removePostbuildTool('Execute');
% 
% 
% builderApplication.setDirective('FileSeparator','/');
% % 
% % debugBuildConfig = tc.getBuildConfiguration('Debug');
% % removeDefaultBuildConfigurationOptions(debugBuildConfig);
% % 
% % debugBuildConfig = tc.getBuildConfiguration('Faster Builds');
% % removeDefaultBuildConfigurationOptions(debugBuildConfig);
% % 
% % debugBuildConfig = tc.getBuildConfiguration('Faster Runs');
% % removeDefaultBuildConfigurationOptions(debugBuildConfig);
% 
% 
% end
% 
% 
% function removeDefaultBuildConfigurationOptions(buildConfiguration)
% 
% buildConfiguration.Options.remove('Archiver');
% buildConfiguration.Options.remove('C Compiler');
% buildConfiguration.Options.remove('Linker');
% buildConfiguration.Options.remove('C++ Compiler');
% buildConfiguration.Options.remove('C++ Linker');
% buildConfiguration.Options.remove('C++ Shared Library Linker');
% buildConfiguration.Options.remove('Download');
% buildConfiguration.Options.remove('Execute');
% buildConfiguration.Options.remove('MEX C++ Compiler');
% buildConfiguration.Options.remove('MEX C++ Linker');
% buildConfiguration.Options.remove('MEX Compiler');
% buildConfiguration.Options.remove('MEX Linker');
% buildConfiguration.Options.remove('Shared Library Linker');
% % buildConfiguration.Options.remove('IDE Tool');
% 
% end
% 
% function disableDefaultBuildTool(buildTool)
% 
% buildTool.setName("Dummy " + buildTool.Name);
% buildTool.setCommand("rem");
% buildTool.CustomValidation = 'highleveltarget.toolchain.toolValidator';
% directives = buildTool.Directives;
% % while ~isempty(directives)
% %     buildTool.Directives.remove(directives.keys{end})
% % end
% 
% end
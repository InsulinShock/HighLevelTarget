function [tc, results] = generateToolchain()
%androidstudioproject Specifications for fake Android toolchain.

% Copyright 2015 The MathWorks, Inc.

toolchain.Platforms  = {computer('arch')};
toolchain.Versions   = {'1.0'};
toolchain.Artifacts  = {'Custom IDE Project'};
toolchain.FuncHandle = str2func('getToolchainInfoFor');
toolchain.ExtraFuncArgs = {};
[tc, results] = coder.make.internal.generateToolchainInfoObjects(mfilename, toolchain, nargout);

end

function tc = getToolchainInfoFor(~, ~, ~, varargin)

tc = coder.make.ToolchainInfo(...
    'Name', 'Directed Graph Build System', ...
    'BuildArtifact', 'Custom IDE Project', ...
    'SupportedLanguages', {'C/C++'}); 

disableDefaultBuildTools(tc);

removeDefaultBuildConfigurationOptions(tc);

removeDefaultPostbuildTools(tc);

addCustomBuildTool(tc);

setDigraphBuildConfigurationOptions(tc);

tc.addAttribute('TransformPathsWithSpaces');
tc.addAttribute('SupportsDoubleQuotes', false);
tc.addAttribute('SupportsUNCPaths', false);
tc.setProjectTool('highleveltarget.buildsystem.ProjectTool');

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
    'Directed Graph (digraph) MAT File','DIGRAPHMATFILE',...   
    'Visualization','VISUALIZATION'};
modernBuildTool.CustomValidation = 'highleveltarget.toolchain.toolValidator';
tc.addBuildTool('IDE Tool',modernBuildTool);

tc.setBuilderApplication(computer('arch'));
%builderApplication = tc.BuilderApplication;

end

function removeDefaultPostbuildTools(tc)

tc.removePostbuildTool('Download');
tc.removePostbuildTool('Execute');

end

function setDigraphBuildConfigurationOptions(tc)

bcs = tc.BuildConfigurations;
keys = bcs.keys;

for i = 1:numel(keys)
   buildConfiguration = bcs.getValue(keys{i}); 
   buildConfiguration.setOption('Directed Graph (digraph) MAT File','mydigraph.mat');
   buildConfiguration.setOption('Visualization','true');   
end

end
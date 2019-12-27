function [tc, results] = generateToolchain()
%gcc_linaro_arm_linux_gnueabihf

% Copyright 2013-2018 The MathWorks, Inc.

toolchain.Platforms  = {'win64', 'win32','glnxa64','maci64'};
toolchain.Versions   = {'4.8'};
toolchain.Artifacts  = {'gmake'};
toolchain.FuncHandle = str2func('getToolchainInfoFor');
toolchain.ExtraFuncArgs = {};

[tc, results] = coder.make.internal.generateToolchainInfoObjects(mfilename, toolchain);
end

function tc = getToolchainInfoFor(platform, version, artifact, varargin)
% Toolchain Information

tc = coder.make.ToolchainInfo('BuildArtifact', 'gmake makefile', 'SupportedLanguages', {'Asm/C/C++'});
info = getARMCortexAInfo();
tc.Name = "High_Level_Toolchain";
tc.Platform = platform;
tc.setBuilderApplication(platform);

% MATLAB setup
% tc.MATLABSetup = 'codertarget.arm_cortex_a.internal.addCompilerPath();';

% Toolchain's attribute
tc.addAttribute('TransformPathsWithSpaces');
tc.addAttribute('SupportsUNCPaths',     false);
tc.addAttribute('SupportsDoubleQuotes', true);

% Add inline commands
% objectExtension = '.o';
% depfileExtension = '.dep';
% tc.InlinedCommands{1} = ['ALL_DEPS:=$(patsubst %',objectExtension,',%', depfileExtension, ',$(ALL_OBJS))'];
% tc.InlinedCommands{2} = 'all:';
% tc.InlinedCommands{3} = '';

% Add include files
make = tc.BuilderApplication();
%make.IncludeFiles = {...
%    'codertarget_assembly_flags.mk', ...
%    '../codertarget_assembly_flags.mk', ...
%    '../../codertarget_assembly_flags.mk', ...
%    '$(ALL_DEPS)'};
%}


% Add macros
% tc.addIntrinsicMacros({'TARGET_LOAD_CMD_ARGS'});
% tc.addIntrinsicMacros({'TARGET_PKG_INSTALLDIR'});
% tc.addIntrinsicMacros({'LINARO_TOOLCHAIN_4_8'});
tc.addMacro('LINARO_TOOLCHAIN_4_8', fullfile(highleveltarget.utilities.getRootFolder(),

if any(ismember(platform, {'win64','win32'}))
    % Work around for cygwin, override SHELL variable
    % http://www.gnu.org/software/make/manual/make.html#Choosing-the-Shell
    tc.addAttribute('RequiresBatchFile', true);
    tc.addMacro('SHELL', '%SystemRoot%/system32/cmd.exe');
end

% tc.addMacro('CCOUTPUTFLAG',     '--output_file=');
% tc.addMacro('LDOUTPUTFLAG',     '--output_file=');
% tc.addMacro('CPFLAGS', '-O binary');


% Assembler
assembler = tc.getBuildTool('Assembler');
assembler.setName([info.ToolChainName, version, ' Assembler']);
assembler.setPath('$(LINARO_TOOLCHAIN_4_8)');
assembler.setCommand('arm-linux-gnueabihf-as');
assembler.setDirective('IncludeSearchPath', '-I');
assembler.setDirective('PreprocessorDefine', '-D');
assembler.setDirective('OutputFlag', '-o');
assembler.setDirective('Debug', '-g');
assembler.DerivedFileExtensions = {'Object'};
assembler.setFileExtension('Source','.s');
assembler.setFileExtension('Object', '.s.o');
asmObjBuildItem = assembler.FileExtensions.getValue('Object');
asmObjBuildItem.setMacro('ASMOBJ_EXT');
assembler.addFileExtension( 'DependencyFile', coder.make.BuildItem('ASM_EXT', ['.s', depfileExtension]));
assembler.DerivedFileExtensions = {'.s.dep'};

% Compiler
compiler = tc.getBuildTool('C Compiler');
compiler.setName([info.ToolChainName, version, ' C Compiler']);
compiler.setPath('$(LINARO_TOOLCHAIN_4_8)');
compiler.setCommand('arm-linux-gnueabihf-gcc');
compiler.setDirective('CompileFlag', '-c');
compiler.setDirective('PreprocessFile', '-E');
compiler.setDirective('IncludeSearchPath', '-I');
compiler.setDirective('PreprocessorDefine', '-D');
compiler.setDirective('OutputFlag', '-o');
compiler.setDirective('Debug', '-g');
compiler.setFileExtension('Source', '.c');
compiler.setFileExtension('Header', '.h');
compiler.setFileExtension('Object', '.c.o');
cObjBuildItem = compiler.FileExtensions.getValue('Object');
cObjBuildItem.setMacro('COBJ_EXT');
compiler.addFileExtension( 'DependencyFile', coder.make.BuildItem('C_EXT', ['.c', depfileExtension]));
compiler.DerivedFileExtensions = {'.c.dep'};

% C++ compiler
cppcompiler = tc.getBuildTool('C++ Compiler');
cppcompiler.setName([info.ToolChainName, version, ' C++ Compiler']);
cppcompiler.setPath('$(LINARO_TOOLCHAIN_4_8)');
cppcompiler.setCommand('arm-linux-gnueabihf-g++')
cppcompiler.setDirective('CompileFlag', '-c');
cppcompiler.setDirective('PreprocessFile', '-E');
cppcompiler.setDirective('IncludeSearchPath', '-I');
cppcompiler.setDirective('PreprocessorDefine', '-D');
cppcompiler.setDirective('OutputFlag', '-o');
cppcompiler.setDirective('Debug', '-g');
cppcompiler.setFileExtension('Source', '.cpp');
cppcompiler.setFileExtension('Header', '.hpp');
cppcompiler.setFileExtension('Object', '.pp.o');
cppObjBuildItem = cppcompiler.FileExtensions.getValue('Object');
cppObjBuildItem.setMacro('CPPOBJ_EXT');
cppcompiler.addFileExtension( 'DependencyFile', coder.make.BuildItem('CPP_EXT', ['.cpp', depfileExtension]));
cppcompiler.DerivedFileExtensions = {'.cpp.dep'};

% Linker
linker = tc.getBuildTool('Linker');
linker.setName([info.ToolChainName, version, ' Linker']);
linker.setPath('$(LINARO_TOOLCHAIN_4_8)');
linker.setCommand('arm-linux-gnueabihf-gcc');
linker.setDirective('Library', '-l');
linker.setDirective('LibrarySearchPath', '-L');
linker.setDirective('OutputFlag', '-o');
linker.setDirective('Debug', '-g');
linker.setFileExtension('Executable', '.elf');
linker.setFileExtension('Shared Library', '.so');
linker.Libraries = {'-lm'};

% C++ Linker
cpplinker = tc.getBuildTool('C++ Linker');
cpplinker.setName([info.ToolChainName, version, ' C++ Linker']);
cpplinker.setPath('$(LINARO_TOOLCHAIN_4_8)');
cpplinker.setCommand('arm-linux-gnueabihf-g++');
cpplinker.setDirective('Library', '-l');
cpplinker.setDirective('LibrarySearchPath', '-L');
cpplinker.setDirective('OutputFlag', '-o');
cpplinker.setDirective('Debug', '-g');
cpplinker.setFileExtension('Executable', '');
cpplinker.setFileExtension('Shared Library', '.so');
cpplinker.Libraries = {'-lm'};

% Archiver
archiver = tc.getBuildTool('Archiver');
archiver.setPath('$(LINARO_TOOLCHAIN_4_8)');
archiver.setName([info.ToolChainName, version, ' Archiver']);
archiver.setCommand('arm-linux-gnueabihf-ar');
archiver.setDirective('OutputFlag', '');
archiver.setFileExtension('Static Library', '.lib');

% ------------------------------
% Download Tool
% ------------------------------
% Adding a new download configuration to download and run using DSS
downloadTool = tc.getPostbuildTool('Download');
downloadTool.setCommand('ssh_download.bat'); % Macro name & Tool name
downloadTool.setPath('$(TARGET_PKG_INSTALLDIR)');
tc.setBuildConfigurationOption('all', 'Download', '$(TARGET_LOAD_CMD_ARGS) $(PRODUCT)');


% --------------------------------------------
% BUILD CONFIGURATIONS
% --------------------------------------------
optimsOffOpts = {'-O0'};
optimsOnOpts = {'-O2'};
cCompilerOpts    = {''};
archiverOpts     = {'-ruvs'};

compilerOpts = {...
    tc.getBuildTool('C Compiler').getDirective('CompileFlag'),...
    };


linkerOpts = { ...
    '-lm -lrt -lpthread -ldl',...
    };

assemblerOpts = compilerOpts;
compilerOpts = [compilerOpts, ...                
    ['-MMD -MP -MF"$(@:%', objectExtension, '=%', depfileExtension, ')" -MT"$@" '],... % make dependency files
];

% Get the debug flag per build tool
debugFlag.CCompiler   = '-g -D"_DEBUG"';
debugFlag.Linker      = '-g';
debugFlag.Archiver    = '';

cfg = tc.getBuildConfiguration('Faster Builds');
cfg.setOption('Assembler',  horzcat(cCompilerOpts, assemblerOpts, '$(ASFLAGS_ADDITIONAL)', '$(INCLUDES)'));
cfg.setOption('C Compiler', horzcat(cCompilerOpts, compilerOpts, optimsOffOpts));
cfg.setOption('Linker',     linkerOpts);
cfg.setOption('Shared Library Linker', horzcat({'-shared '}, linkerOpts));
cfg.setOption('C++ Compiler', horzcat(cCompilerOpts, compilerOpts, optimsOnOpts));
cfg.setOption('C++ Linker', linkerOpts);
cfg.setOption('C++ Shared Library Linker', horzcat({'-shared '}, linkerOpts));
cfg.setOption('Archiver', archiverOpts);

cfg = tc.getBuildConfiguration('Faster Runs');
cfg.setOption('Assembler',  horzcat(cCompilerOpts, assemblerOpts, '$(ASFLAGS_ADDITIONAL)', '$(INCLUDES)'));
cfg.setOption('C Compiler', horzcat(cCompilerOpts, compilerOpts, optimsOnOpts));
cfg.setOption('Linker',     linkerOpts);
cfg.setOption('Shared Library Linker', horzcat({'-shared '}, linkerOpts));
cfg.setOption('C++ Compiler', horzcat(cCompilerOpts, compilerOpts, optimsOnOpts));
cfg.setOption('C++ Linker', linkerOpts);
cfg.setOption('C++ Shared Library Linker', horzcat({'-shared '}, linkerOpts));
cfg.setOption('Archiver', archiverOpts);

cfg = tc.getBuildConfiguration('Debug');
cfg.setOption('Assembler',  horzcat(cCompilerOpts, assemblerOpts, '$(ASFLAGS_ADDITIONAL)', '$(INCLUDES)', debugFlag.CCompiler));
cfg.setOption('C Compiler', horzcat(cCompilerOpts, compilerOpts, optimsOffOpts, debugFlag.CCompiler));
cfg.setOption('Linker',     horzcat(linkerOpts, debugFlag.Linker));
cfg.setOption('Shared Library Linker', horzcat({'-shared '}, linkerOpts, debugFlag.Linker));
cfg.setOption('C++ Compiler', horzcat(cCompilerOpts, compilerOpts, optimsOffOpts, debugFlag.CCompiler));
cfg.setOption('C++ Linker', horzcat(linkerOpts, debugFlag.Linker));
cfg.setOption('Shared Library Linker', horzcat({'-shared '}, linkerOpts, debugFlag.Linker));
cfg.setOption('Archiver',   horzcat(archiverOpts, debugFlag.Archiver));

tc.setBuildConfigurationOption('all', 'Make Tool', '-f $(MAKEFILE)');

end
function [tc, results] = wrworkbenchgnuarm
%WRWORKBENCHGNUARM Creates a WindRiver Workbench GNU toolchain

% Copyright 2013-2019 The MathWorks, Inc.

toolchain.Platforms  = {'win64', 'win32', 'glnxa64','maci64'};
toolchain.Versions   = {'4.8.1'};
toolchain.Artifacts  = {'gmake'};
toolchain.FuncHandle = str2func('getToolchainInfoFor');
toolchain.ExtraFuncArgs = {};

[tc, results] = coder.make.internal.generateToolchainInfoObjects(mfilename, toolchain);
end


% -------------------------------------------------------------------------
function tc = getToolchainInfoFor(platform, version, artifact, varargin)

tc = coder.make.ToolchainInfo('BuildArtifact', 'gmake makefile', 'SupportedLanguages', {'Asm/C/C++'});
toolName = 'Wind River Workbench GNU ARM';
tc.Name = coder.make.internal.formToolchainName(toolName, platform, version, artifact);
tc.Platform = platform;
tc.addAttribute('SupportsSpacesInPaths', false);
tc.addAttribute('SupportsUNCPaths',      false);
tc.addAttribute('SupportsDoubleQuotes',  true);
tc.addAttribute('RequiresBatchFile', true);

if any(ismember(platform, {'win64','win32'}))
    tc.ShellSetup{1} = '%WRWORKBENCHINSTALLDIR%\wrenv.exe -p vxworks-7 -f bat -o print_env > vxworks7shellsetup.bat';
    tc.ShellSetup{2} = 'call vxworks7shellsetup.bat';
    tc.ShellSetup{3} = 'set WIND_USR=%WRWORKBENCHINSTALLDIR%';
    tc.ShellSetup{4} = 'set WIND_HOME=%WRWORKBENCHINSTALLDIR%';
else
    tc.ShellSetup{1} = '$WRWORKBENCHINSTALLDIR/wrenv.sh -p vxworks-7 -f sh -o print_env > vxworks7shellsetup.sh';
    tc.ShellSetup{2} = 'source vxworks7shellsetup.sh';
    tc.ShellSetup{3} = 'export WIND_USR=$WRWORKBENCHINSTALLDIR';
    tc.ShellSetup{4} = 'export WIND_HOME=$WRWORKBENCHINSTALLDIR';
end

% ------------------------------
% Make
% ------------------------------

make = tc.BuilderApplication();
make.IncludeFiles = {'codertarget_assembly_flags.mk', '../codertarget_assembly_flags.mk', '../../codertarget_assembly_flags.mk'};

% ------------------------------
% Macros
% ------------------------------

% VXWORKS GNU SPECIFIC
tc.addMacro('VX_CPU_FAMILY','arm');
tc.addMacro('CPU','ARMARCH7');
tc.addMacro('TOOL_FAMILY','gnu');
tc.addMacro('TOOL_VERSION','gnu_4_8_1');
tc.addMacro('CC_ARCH_SPEC','-t7 -mfpu=vfp -mfloat-abi=softfp');

tc.addIntrinsicMacros({'WIND_USR'});
tc.addIntrinsicMacros({'WRWORKBENCHINSTALLDIR'});
tc.addIntrinsicMacros({'VSB_DIR'});
tc.addIntrinsicMacros({'TARGET_LOAD_CMD_ARGS'});
tc.addIntrinsicMacros({'TARGET_PKG_INSTALLDIR'});


if any(ismember(platform, {'win64','win32'}))
    % Work around for cygwin, override SHELL variable
    % http://www.gnu.org/software/make/manual/make.html#Choosing-the-Shell
    tc.addMacro('SHELL', '%SystemRoot%/system32/cmd.exe');
end

tc.addMacro('GNU_LD_EXE','$(WRWORKBENCHINSTALLDIR)/vxworks-7/build/tool/gnu_4_8_1/usr');

tc.addMacro('CCOUTPUTFLAG',     '--output_file=');
tc.addMacro('LDOUTPUTFLAG',     '--output_file=');
tc.addMacro('EXE_FILE_EXT',     '$(PROGRAM_FILE_EXT)')

% ------------------------------
% Assembler
% ------------------------------
assembler = tc.getBuildTool('Assembler');  % Register a new post build tool
assembler.setName(          [toolName, ' Assembler']);
assembler.setCommand(       'asarm');
assembler.setDirective(     'IncludeSearchPath', '-I');
assembler.setDirective(     'PreprocessorDefine', '-D');
assembler.DerivedFileExtensions = {'Object'};
assembler.setDirective(     'Debug', '-g');
assembler.setFileExtension( 'Source', '.s');
assembler.setFileExtension( 'Object', '.s.o');
assembler.InputFileExtensions  = {'Source'};
assembler.OutputFileExtensions = {'Object'};
assembler.DerivedFileExtensions = {'.d'};

% ------------------------------
% C Compiler
% ------------------------------
cCompiler = tc.getBuildTool('C Compiler');

cCompiler.setName(          [toolName, ' C Compiler']);
cCompiler.setCommand(       'ccarm');
cCompiler.setDirective(     'CompileFlag', '-c');
cCompiler.setDirective(     'PreprocessFile', '-E');
cCompiler.setDirective(     'IncludeSearchPath', '-I');
cCompiler.setDirective(     'PreprocessorDefine', '-D');
cCompiler.setDirective(     'Debug', '-g');
cCompiler.setDirective(     'OutputFlag', '-o');
cCompiler.setFileExtension( 'Object', '.c.o');
cCompiler.addFileExtension( 'Assembly Source', coder.make.BuildItem('AS_EXT', '.s'));
cCompiler.DerivedFileExtensions = {'.d'};

% ------------------------------
% C++ Compiler
% ------------------------------
cppCompiler = tc.getBuildTool('C++ Compiler');

cppCompiler.setName(          [toolName, ' C++ Compiler']);
cppCompiler.setCommand(       'c++arm');
cppCompiler.setDirective(     'CompileFlag', '-c');
cppCompiler.setDirective(     'PreprocessFile', '-E');
cppCompiler.setDirective(     'IncludeSearchPath', '-I');
cppCompiler.setDirective(     'PreprocessorDefine', '-D');
cppCompiler.setDirective(     'Debug', '-g');
cppCompiler.setDirective(     'OutputFlag', '-o');
cppCompiler.setFileExtension( 'Object', '.cpp.o');
cppCompiler.DerivedFileExtensions = {'.d'};

% ------------------------------
% Linker
% ------------------------------
linker = tc.getBuildTool('Linker');

linker.setName(             [toolName, ' Linker']);
linker.setCommand(          'c++arm');
linker.setDirective(        'Library', '-l');
linker.setDirective(        'OutputFlag', '-o');
linker.setDirective(        'Debug', '-g');
linker.setFileExtension(    'Executable', '.vxe');

% ------------------------------
% Archiver
% ------------------------------
archiver = tc.getBuildTool('Archiver');

archiver.setName(           [toolName, ' Archiver']);
archiver.setCommand(        'ararm');
archiver.setFileExtension(  'Static Library', '.lib');

% ------------------------------
% Builder
% ------------------------------

tc.setBuilderApplication(platform);

% --------------------------------------------
% BUILD CONFIGURATIONS
% --------------------------------------------
optimsOffOpts = {'-O0'};
optimsOnOpts = {'-O2'};
cCompilerOpts    = {''};
archiverOpts     = {'crus'};

commonOptions = {...
    '-t7', '-mfpu=vfp', '-mfloat-abi=softfp', '-mrtp', '-fno-strict-aliasing',...
    '-D_C99', '-D_HAS_C9X', '-lstdc++', '-lpthread', '-ldl', '-MD', '-MP',...
    '-D_VX_CPU=_VX_$(CPU)', '-D_VX_TOOL_FAMILY=$(TOOL_FAMILY)','-D_VX_TOOL=$(TOOL_FAMILY)',...
    '-D_VSB_CONFIG_FILE=\"$(VSB_DIR)/h/config/vsbConfig.h\"','-DARMEL'...
    '-I$(VSB_DIR)/usr/h',...
    '-I$(VSB_DIR)/usr/h/public',  ...
    '-I$(VSB_DIR)/share/h',...
    '-I$(VSB_DIR)/krnl/h/public', ...
    };

compilerOpts = [commonOptions, {tc.getBuildTool('C Compiler').getDirective('CompileFlag')}];

linkerOpts = { ...
    '-t7', '-mfpu=vfp', '-mfloat-abi=softfp', '-mrtp', '-fno-strict-aliasing',...
    '-D_C99', '-D_HAS_C9X', '-std=c99', '-fasm', '-MD', '-MP',...
    '-Wl,--defsym,__wrs_rtp_base=0x80000000', '-mrtp',...
    '-Wl,-T$(GNU_LD_EXE)/ldscript.vxe.arm',...
    '-L$(VSB_DIR)/usr/lib/common',...
    '-lstdc++',...
    '-Wl,-u,__tls__',...
    '-Wl,-rpath $(VSB_DIR)/usr/root/gnu/bin', ...
    };
% -ldl  -lm
assemblerOpts = compilerOpts;

% Get the debug flag per build tool
debugFlag.CCompiler   = '-g -D"_DEBUG"';
debugFlag.Linker      = '';
debugFlag.Archiver    = '';

cfg = tc.getBuildConfiguration('Faster Builds');
cfg.setOption('Assembler', horzcat(cCompilerOpts, assemblerOpts, '$(ASFLAGS_ADDITIONAL)', '$(INCLUDES)'));
cfg.setOption('C Compiler',horzcat(cCompilerOpts, compilerOpts, optimsOffOpts));
cfg.setOption('Linker',    linkerOpts);
cfg.setOption('Archiver',  archiverOpts);

cfg = tc.getBuildConfiguration('Faster Runs');
cfg.setOption('Assembler', horzcat(cCompilerOpts, assemblerOpts, '$(ASFLAGS_ADDITIONAL)', '$(INCLUDES)'));
cfg.setOption('C Compiler',horzcat(cCompilerOpts, compilerOpts, optimsOnOpts));
cfg.setOption('Linker',    linkerOpts);
cfg.setOption('Archiver',  archiverOpts);

cfg = tc.getBuildConfiguration('Debug');
cfg.setOption('Assembler', horzcat(cCompilerOpts, assemblerOpts, '$(ASFLAGS_ADDITIONAL)', '$(INCLUDES)', debugFlag.CCompiler));
cfg.setOption('C Compiler',horzcat(cCompilerOpts, compilerOpts, optimsOffOpts, debugFlag.CCompiler));
cfg.setOption('Linker',    horzcat(linkerOpts, debugFlag.Linker));
cfg.setOption('Archiver',  horzcat(archiverOpts, debugFlag.Archiver));

tc.setBuildConfigurationOption('all', 'Make Tool', '-f $(MAKEFILE)');

end

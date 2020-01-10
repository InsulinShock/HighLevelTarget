function [ret, context] = createProject(~, buildInfo, context, varargin) 
%CREATEPROJECT Create an high level target project 
%   Create a high level target project including CMake files, main.cc, and
%   additional build files.

disp("Creating high level target project...");

%% Get the ToolchainInfo
toolchainInfo = varargin{1};

%% Get the CodeInfo
codeInfo = matfile('codeInfo.mat');

%% Android Project Creator
%prj = codertarget.mobile.android.AndroidProjectCreator(...
%    fullfile(codertarget.mobile.internal.getSppkgRootDir,'template'));

%% Get CODER data from the Toolchain and Build Configuration
%prjData = codertarget.mobile.android.getProjectConfigurationData(buildInfo,toolchainInfo);


% 
% %% Create and add to the project properties
% createProjectProperties(prj,prjData);
% setProjectProperty(prj,'SRC_FILES',buildInfo.getSourceFiles(true,true))
% setProjectProperty(prj,'INC_PATHS',buildInfo.getIncludePaths(true))
% setProjectProperty(prj,'matlabroot',regexprep(matlabroot,filesep,'/'));
% setProjectProperty(prj,'INTERFACE_HEADERS',{codeInfo.Name});   % For SWIG
% 
% 
% %% Create project files
% rootDirectory = 'AndroidProject';
% writeProjectFiles(prj,fullfile(pwd,rootDirectory))
% 
% 
% %% Create JAVA wrapper files
% packageDirectory = ...
%     regexprep(prj.projectProperties.JAVA_PACKAGE,'\.',filesep);
% outdir = fullfile(rootDirectory,'mw_module','src','main','java',packageDirectory);
% 
% cmd = ['swig -java ',...
%         '-outdir "',outdir,'" ',...
%         '-package ',prj.projectProperties.JAVA_PACKAGE,' ',...
%         '-o ert_main_wrap.c ',...
%         '-noproxy ',...
%         'swiginterface.i'];
% [~,results] = system(cmd);


%% Returning the Model Name 
ret = buildInfo.ModelName;

disp("... project creation complete.");
disp("=====================================================================");

end
function [ret, context] = onError(h, buildInfo, context, varargin)




ret = true;

disp('AndroidProjectTool.onError');

%% IF APP is running on device
% !C:\Users\gmcvi\AppData\Local\Android\sdk\platform-tools\adb shell am force-stop com.example.gmcvi
% !C:\Users\gmcvi\AppData\Local\Android\sdk\platform-tools\adb uninstall com.example.gmcvi



end
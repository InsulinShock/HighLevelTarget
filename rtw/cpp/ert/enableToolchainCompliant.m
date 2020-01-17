function enableToolchainCompliant(hSrc, hDlg)

% The following parameters enable toolchain compliance.
slConfigUISetVal(hDlg, hSrc, 'UseToolchainInfoCompliant', 'on');
slConfigUISetVal(hDlg, hSrc, 'GenerateMakefile','on');

% The following parameters are not required for toolchain compliance.
% But, it is recommended practice to set these default values and
% disable the parameters (as shown).
slConfigUISetVal(hDlg, hSrc, 'RTWCompilerOptimization','off');
slConfigUISetVal(hDlg, hSrc, 'MakeCommand','make_rtw');
slConfigUISetEnabled(hDlg, hSrc, 'RTWCompilerOptimization',false);
slConfigUISetEnabled(hDlg, hSrc, 'MakeCommand',false);

end
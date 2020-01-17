function hlrt_make_rtw_hook(hookMethod, modelName, rtwRoot, templateMakefile,...
buildOpts, buildArgs, buildInfo)

switch hookMethod
    case 'entry' 
        disp('entry')
        
    case 'before_tlc'
        disp('before_tlc')
        
    case 'after_tlc'
        disp('after_tlc')
        
    case 'before_make'
        disp('before_make')
        
    case 'after_make'
        disp('after_make')
        
    case 'exit'
        disp('exit')
        
    case 'error'
        disp('error')
        
    otherwise
    
end








end
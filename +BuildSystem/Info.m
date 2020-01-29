classdef Info
    %INFO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = immutable)
        build (1,1) RTW.BuildInfo
        interface (1,1) RTW.ComponentInterface
        config (1,1) coder.EmbeddedCodeConfig
    end
    
    methods
        function obj = Info(buildInfoFile,codeInfoFile)
            arguments
                buildInfoFile (1,1) string = "buildInfo.mat";
                codeInfoFile (1,1) string = "codeInfo.mat";
            end           
            
            matFileCode = matfile(codeInfoFile);
            obj.interface = matFileCode.codeInfo; 
            try
                obj.config = matFileCode.configInfo; 
            catch ex
                
            end            
            
            matFileConfig = matfile(buildInfoFile);
            obj.build = matFileConfig.buildInfo;            
        end       
    end
end
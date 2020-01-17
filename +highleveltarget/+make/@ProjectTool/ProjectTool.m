classdef ProjectTool < coder.make.ProjectTool
    %ANDROIDPROJECTTOOL Summary of this class goes here
    %   Detailed explanation goes here
    
    
    % Abstract methods for class codertarget.android.ProjectTool:
    %   terminate      	% defined in coder.make.ProjectTool
    %   onError        	% defined in coder.make.ProjectTool
    %   runProject     	% defined in coder.make.ProjectTool
    %   downloadProject	% defined in coder.make.ProjectTool
    %   buildProject   	% defined in coder.make.ProjectTool
    %   createProject  	% defined in coder.make.ProjectTool
    %   initialize     	% defined in coder.make.ProjectTool
    
    %--------------------------------------------
    % NOTE: To debug this class, one should put a break point
    % in the caller and then edit TestProjectTool that is in path.
    % This is because, this tool is copied to a temp path and then
    % used from that temp location.
    %--------------------------------------------
        
       
    methods
        function obj = ProjectTool(~)
            obj@coder.make.ProjectTool('Dockcross | CMake');
        end
    end
    
end


classdef Executor < coder.make.Executor

    % Copyright 2012-2019 The MathWorks, Inc.

    properties
        EchoArgument
    end
    
    % -----------------------
    % GET/SET METHODS
    % -----------------------
    methods
        
    end % get/set methods
    
    methods
        % -----------------------------------------------------------------
        % Constructor
        % -----------------------------------------------------------------
        function h = Executor(builder, buildInfo, artifact)
            % Invoke base class constructor
            h@coder.make.Executor(builder, buildInfo, artifact);
            
            disp("Executor contructed");
            
        end
        
        % -----------------------------------------------------------------
        % Invoke the makefile CLEAN rule
        % -----------------------------------------------------------------
        function [success, problem] = clean(h, buildInfo)       %#ok<*INUSD>
            % ------------------------------------
            % Check that the make tool is valid 
            % ------------------------------------
            tool = h.ToolchainInfo.BuilderApplication;
                        
            success = true;
            problem = '';
        end
        
        % -----------------------------------------------------------------
        % Invoke the makefile BUILD rule
        % -----------------------------------------------------------------
        function [success, results] = build(h, buildInfo)       %#ok<*INUSD>
            
            success = true;
            results = '';
        end
        
        % -----------------------------------------------------------------
        % Invoke the DOWNLOAD tool
        % -----------------------------------------------------------------
        function [success, problem] = download(h, buildInfo)
            success = true;
            problem = '';
            %if h.ToolchainInfo.PostbuildTools.isKey('Download')
                % Invoke download
            %    [success, problem] = h.invokeRule('download');
            %end
        end
        
        % -----------------------------------------------------------------
        % Invoke the EXECUTE tool
        % -----------------------------------------------------------------
        function [success, problem] = execute(h, buildInfo)
            success = true;
            problem = '';
            %if h.ToolchainInfo.PostbuildTools.isKey('Execute')
                % Invoke execute
            %    [success, problem] = h.invokeRule('execute');
            %end
        end
        
        % -----------------------------------------------------------------
        % TODO: Provide proper diagnostic info to the user
        % -----------------------------------------------------------------
        function msg = diagnose(h, step, problem) %#ok<*INUSL>
            msg = problem;
            switch lower(step)
                case 'setup'
                case 'cleanup'
                case 'validate'
                case 'build'
                case 'download'
                case 'execute'
                otherwise
            end
        end
       
        
    end % public methods
    
    methods (Access = protected)
        
        % -----------------------------------------------------------------
        % Invoke the tool
        % -----------------------------------------------------------------
        function [success, problem] = invokeRule(h, rule)
            problem = '';
            success = (ret==0);
        end
        
        % -----------------------------------------------------------------
        % Set the makefile command
        % -----------------------------------------------------------------
        function setCommand(h, buildInfo)
            
        end
        
        % -----------------------------------------------------------------
        % Return a specified tool's command & options
        % -----------------------------------------------------------------
        function [command, options] = getCommandParts(h, tool)
            % Get the tool command
            disp('getCommandParts');
            
            command = '';
            options = '';  
        end
        
        % -----------------------------------------------------------------
        % Return a the command and options of a build tool, after both have
        % been modified to accommodate changes needed in order to invoke a  
        % builder application (ie. gmake)
        % -----------------------------------------------------------------
        function [command, options] = getCommandPartsForBuilderApplication(h, tool, buildInfo)     
            command = '';
            options = '';             
        end
        
    end % protected methods
end

% LocalWords:  gmake Toolchain
classdef RunDiagraphTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testInvalidInputsSyntax(testCase)
            
            function data = invalidFuncInput()
                data = false;
            end                     
            
            testCase.verifyError(...
                @()highleveltarget.buildsystem.validateTaskFunctionSignature(@invalidFuncInput),...
                "HIGHLEVELTARGET:buildSystem:invalidTaskInputArguments");            
        end
                
        function testInvalidOutputsSyntax(testCase)
            
            function invalidFuncOutput(~,~,varargin)
            end                     
            
            testCase.verifyError(...
                @()highleveltarget.buildsystem.validateTaskSyntax(@invalidFuncOutput),...
                "HIGHLEVELTARGET:buildSystem:invalidTaskOutputArguments");            
        end
        
    end
    
end
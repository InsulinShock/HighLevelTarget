classdef ValidateDigraphAttributesTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testCyclicDigraph(testCase)
            
            G = digraph(["fun1" "fun2"], ["fun2" "fun1"]);                     
            
            testCase.verifyError(...
                @()highleveltarget.buildsystem.validateDigraphAttributes(G),...
                "HIGHLEVELTARGET:buildSystem:digraphNotAcyclic");            
        end
        
        function testFirstNodeHasInDegreeZero(testCase)
            G = digraph(["fun1","fun3"],["fun2","fun1"]);
            
            testCase.verifyError(...
                @()highleveltarget.buildsystem.validateDigraphAttributes(G),...
                "HIGHLEVELTARGET:buildSystem:digraphNode1OutputOnly");                
        end        
                  
    end
    
end


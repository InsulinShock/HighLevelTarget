function validateTaskFunctionSignature(functionName)
%ISTASKSYNTAXVALID Is task valid syntax
%   Detailed explanation goes here

assert(nargin(functionName) == -3,...
    "HIGHLEVELTARGET:buildSystem:invalidTaskInputArguments",...
    "Task function requires the following signature: result = <taskName>(buildInfo,codeInfo,varargin).");

assert(nargout(functionName) == 1,...
    "HIGHLEVELTARGET:buildSystem:invalidTaskOutputArguments",...
    "Task function requires the following signature: result = <taskName>(buildInfo,codeInfo,varargin).");

end


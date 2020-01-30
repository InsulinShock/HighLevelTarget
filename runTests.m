% suite = matlab.unittest.TestSuite.fromFile(...
%     '+BuildSystem\+Job\addTaskTest.m');
% result = run(suite);

import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
import matlab.unittest.plugins.CodeCoveragePlugin
import matlab.unittest.plugins.codecoverage.CoverageReport

suite = TestSuite.fromPackage('Tests','IncludingSubpackages',true);


runner = TestRunner.withNoPlugins;
runner.addPlugin(CodeCoveragePlugin.forFolder('+BuildSystem\@Job', ...
   'Producing',CoverageReport('TestResults', ...
   'MainFile','Job.html')))
runner.run(suite)
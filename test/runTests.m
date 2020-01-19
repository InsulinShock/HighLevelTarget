suite = matlab.unittest.TestSuite.fromFile(...
    'HighLevelTarget\+highleveltarget\+buildsystem\ValidateTaskSyntaxTest.m');
result = run(suite);

suite = matlab.unittest.TestSuite.fromFile(...
    'HighLevelTarget\+highleveltarget\+buildsystem\ValidateDigraphAttributesTest.m');
result = run(suite);
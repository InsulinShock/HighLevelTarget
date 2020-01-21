


bs = highleveltarget.buildsystem.BuildSystem();

bs = bs.addTask("fun1","highleveltarget.buildsystem.CrossCompiler.fun1");
bs = bs.addTask("fun2","highleveltarget.buildsystem.CrossCompiler.fun2");

bs = bs.connectTasks("fun1","fun2");

bs = bs.addTask("fun3","highleveltarget.buildsystem.CrossCompiler.fun3");
bs = bs.addTask("fun4","highleveltarget.buildsystem.CrossCompiler.fun4");

bs = bs.connectTasks("fun2","fun3");
bs = bs.connectTasks("fun2","fun4");

bs = bs.addTask("fun5","highleveltarget.buildsystem.CrossCompiler.fun5");

bs = bs.connectTasks("fun3","fun5");

bs = bs.connectTasks("fun4","fun5");

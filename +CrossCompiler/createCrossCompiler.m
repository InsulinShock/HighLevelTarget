


bs = highleveltarget.buildsystem.BuildSystem();

bs.addTask("Start","highleveltarget.buildsystem.CrossCompiler.fun1");
bs.addTask("Create CMakeLists","highleveltarget.buildsystem.CrossCompiler.fun2");

bs.connectTasks("Start","Create CMakeLists");

bs.addTask("Build for ARM7a","highleveltarget.buildsystem.CrossCompiler.fun3");
bs.addTask("Build for Parrot Drone","highleveltarget.buildsystem.CrossCompiler.fun4");

bs.connectTasks("Create CMakeLists","Build for ARM7a");
bs.connectTasks("Create CMakeLists","Build for Parrot Drone");

bs.addTask("Load onto Parrot","highleveltarget.buildsystem.CrossCompiler.fun5");
bs.addTask("Connect to Parrot","highleveltarget.buildsystem.CrossCompiler.fun5");
bs.addTask("Finished","highleveltarget.buildsystem.CrossCompiler.fun5");

bs.connectTasks("Build for ARM7a","Finished");

bs.connectTasks("Build for Parrot Drone","Load onto Parrot");
bs.connectTasks("Create CMakeLists","Connect to Parrot");
bs.connectTasks("Connect to Parrot","Load onto Parrot");
bs.connectTasks("Load onto Parrot","Finished");
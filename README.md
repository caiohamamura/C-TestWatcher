#C-TestWatcher
This is a powershell script for watching a solution folder for *.cs (uses FileSystemWatcher) file changes and running unit tests.

##Introduction
Tired of save/build/run tests manually? I've written a Powershell script for watching *.cs file changes, rebuild and run unit tests as you go. Since it runs on a Powershell command-line, you can still work on your Visual Studio IDE while building and running the unit tests.

The approch here was to write a powershell script which will watch for *.cs file changes in the solution using a  New-Object System.IO.FileSystemWatcher. It will refresh every second and when there is a modification it will call msbuild for the test project followed by a vstest.console call which will run the tests itself.

##Requirements
 - Windows with Powershell
 - At least RemoteSigned permission for executing scripts: Set-ExecutionPolicy RemoteSigned
 - Visual Studio 2012+

##Installation and Usage
You can clone this repository wherever you like:

    git clone https://github.com/caiohamamura/CSharp-TestWatcher.git
Put C-TestWatcher path into environmental PATH or copy .bat and .ps1 to a folder included into environmental PATH.

The .bat file is configured to run in Visual Studio 2015. If this is not your version, edit watchTest.bat.

    REM edit this
    call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat"
In your test file, you have to specify a TestCategory:

    [TestMethod, TestCategory("AnyCategory")]
    public void TestMethod() ...
Then in a command prompt inside your test project path and run the command:

watchTest {AnyCategory} {TargetSetting [Debug]} {BuildPlatform [AnyCPU]} {TestPlatform [x64]}
##How it works
The powershell script itself is really simple, the majority of the complexity is for parsing input parameters.

The script works this way:

- Parse the input parameters or use default
- Create an object  $watcher = New-Object System.IO.FileSystemWatcher
- Configure the  $watcher to watch for changes in ..\*.cs files including subdirectories
- Configure the action to run whenether there is a change. The action will:
 - Build the test project calling  msbuild with /p:Configuration=[AnyCPU] and /p:Platform=[x64] switches.
 - Run the tests calling  vstest.console using the DLL compiled in .\bin\[ProjectName].dll with /Platform:[x64] and /TestCaseFilter:TestCategory switches
- Bind the action to file modification events.

###MSTest

The  MSTest is a MS Visual Studio 2005+ command line tool for building projects, documentation here.

###VSTest.console

The  VSTest.console is a MS Visual Studio 2012+ command line tool for running test projects, documentation here. It relies on a built DLL test project to run the tests.

You can run all tests, specify which tests will run by calling its name using /Tests:Test1,Test2 switch or filter which tests will run using /TestCaseFilter switch. The TestCaseFilter switch can filter through:

TestCategory: set before method declaration through the attribute [TestCategory("MyCategory")]
Priority: set before method declaration through the attribute [Priority(0)]
Name: providing the full name including the namespace.
The documentation also claims that it can use a *.runsettings xml file, but I couldn't find how to create such file properly in the documentation.

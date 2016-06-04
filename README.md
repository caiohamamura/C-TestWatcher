# C-TestWatcher
This is a powershell script for watching a solution folder for *.cs file changes and running unit tests.

##Requirements
 - Windows with powershell
 - At least: Set-ExecutionPolicy RemoteSigned
 - Visual Studio 2012+

##Installation
 
 You can clone this repository wherever you like:
 
    git clone https://github.com/caiohamamura/CSharp-TestWatcher.git

Put C-TestWatcher path into environmental PATH or copy .bat and .ps1 to a folder included into environmental PATH.

The .bat file is configured to run in Visual Studio 2015. If this is not your version edit whatchTest.bat.

    REM edit this
    call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat"

In your test file you have to specify a TestCategory

    [TestMethod, TestCategory("AnyCategory")]
    public void TestMethod() ...

Then in a command prompt inside your test project path and run the command:

    watchTest {AnyCategory} {TargetSetting [Debug]} {BuildPlatform [AnyCPU]} {TestPlatform [x64]}

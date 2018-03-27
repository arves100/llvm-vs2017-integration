@echo off
REM LLVM 4.0 and above MSBuild 15 Integration
REM Arves100, 03-27-2018, Uol-NCSA License

set VS_REGVAL=15.0

if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (set VS_REGKEY=HKLM\Software\WOW6432Node\Microsoft\VisualStudio\SxS\VS7)
if not "%PROCESSOR_ARCHITECTURE%"=="AMD64" (set VS_REGKEY=HKLM\Software\Microsoft\VisualStudio\SxS\VS7)

reg query %VS_REGKEY% /v %VS_REGVAL% 2>nul || (echo No vs2017 registry key present! & exit /b 1)

set VS_DIR=
for /f "tokens=2,*" %%a in ('reg query %VS_REGKEY% /v %VS_REGVAL% ^| findstr %VS_REGVAL%') do (
    set VS_DIR=%%b
)

if not defined VS_DIR (echo Cannot find Visual Studio 2017 directory! & exit /b 1)

set VS_PROOT_DIR=%VS_DIR%\Common7\IDE\VC\VCTargets\Platforms

if not exist "%VS_PROOT_DIR%\Win32\PlatformToolsets\LLVM-vs2017" (mkdir "%VS_PROOT_DIR%\Win32\PlatformToolsets\LLVM-vs2017")
if not exist "%VS_PROOT_DIR%\Win32\PlatformToolsets\LLVM-vs2017_xp" (mkdir "%VS_PROOT_DIR%\Win32\PlatformToolsets\LLVM-vs2017_xp")
copy Toolset-llvm-vs2017-x86.props "%VS_PROOT_DIR%\Win32\PlatformToolsets\LLVM-vs2017\Toolset.props"
copy Toolset-llvm-vs2017-x86.targets "%VS_PROOT_DIR%\Win32\PlatformToolsets\LLVM-vs2017\Toolset.targets"
copy Toolset-llvm-vs2017-xp-x86.props "%VS_PROOT_DIR%\Win32\PlatformToolsets\LLVM-vs2017_xp\Toolset.props"
copy Toolset-llvm-vs2017-xp-x86.targets "%VS_PROOT_DIR%\Win32\PlatformToolsets\LLVM-vs2017_xp\Toolset.targets"

if "%PROCESSOR_ARCHITECTURE%"=="AMD64" goto install_x64
if not "%PROCESSOR_ARCHITECTURE%"=="AMD64" goto done

:install_x64
if not exist "%VS_PROOT_DIR%\x64\PlatformToolsets\LLVM-vs2017" (mkdir "%VS_PROOT_DIR%\x64\PlatformToolsets\LLVM-vs2017")
if not exist "%VS_PROOT_DIR%\x64\PlatformToolsets\LLVM-vs2017_xp" (mkdir "%VS_PROOT_DIR%\x64\PlatformToolsets\LLVM-vs2017_xp")
copy Toolset-llvm-vs2017-x64.props "%VS_PROOT_DIR%\x64\PlatformToolsets\LLVM-vs2017\Toolset.props"
copy Toolset-llvm-vs2017-x64.targets "%VS_PROOT_DIR%\x64\PlatformToolsets\LLVM-vs2017\Toolset.targets"
copy Toolset-llvm-vs2017-xp-x64.props "%VS_PROOT_DIR%\x64\PlatformToolsets\LLVM-vs2017_xp\Toolset.props"
copy Toolset-llvm-vs2017-xp-x64.targets "%VS_PROOT_DIR%\x64\PlatformToolsets\LLVM-vs2017_xp\Toolset.targets"
goto done

:done
echo Setup OK!
pause

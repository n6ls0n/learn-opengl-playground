@echo off
REM Delete the existing build directory if it exists
if exist build rmdir /s /q build

REM Create a new build directory
mkdir build

REM Change to the build directory
cd build

REM Run CMake to generate build files
cmake ..

REM Build the project
cmake --build .

REM Change back to the original directory
cd ..

REM Pause to keep the command window open
pause

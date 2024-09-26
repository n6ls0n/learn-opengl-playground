@echo off

REM Check if build directory exists, delete it if it does
if exist build (
    rmdir /s /q build
)

REM Create a new build directory if it doesn't exist
if not exist build (
    mkdir build
)

REM Change to the build directory
cd build

REM Run CMake to generate build files
cmake ..

REM Build the project
cmake --build .

REM Change to the Debug directory
cd Debug

REM Run the resulting executable (hello_triangle_exercise4.exe)
shaders_exercise3.exe

REM Change back to the original directory
cd ..

REM Pause to keep the command window open
pause

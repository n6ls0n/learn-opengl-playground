cmake_minimum_required(VERSION 3.10)
project(hello_triangle)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Set paths to look for libraries and includes
set(LIB_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../lib")
set(INCLUDES_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../includes")

# Find OpenGL
find_package(OpenGL REQUIRED)

# Set GLFW settings
set(GLFW_DIR "${LIB_DIR}")
set(GLFW_INCLUDES_DIR "${INCLUDES_DIR}/GLFW")
set(GLFW_LIBRARY "${GLFW_DIR}/glfw3.lib")

# Set GLAD settings
set(GLAD_INCLUDES_DIR "${INCLUDES_DIR}")
set(GLAD_SRC "${CMAKE_CURRENT_SOURCE_DIR}/../../../src/glad.c")

# The add_executable() function is used to specify the source files for the
# ${PROJECT_NAME} target. The ${GLAD_SRC} file is included as a source file
# because it is a single source file that is used to generate the GLAD
# library. The main.cpp file is the source file for this example. The
# add_executable() function will create a ${PROJECT_NAME} target that will
# be used to create the executable for this example.
add_executable(${PROJECT_NAME} hello_triangle.cpp ${GLAD_SRC})

# The target_include_directories() function is used to specify the include directories for the
# ${PROJECT_NAME} target. The PRIVATE keyword means that the include directories are only
# used for this target and not propagated to any dependent targets.
#
# The list of include directories is as follows:
# - ${INCLUDE_DIR}: This is the include directory for the project, which is set to the value of
#   CMAKE_CURRENT_SOURCE_DIR.
# - ${GLAD_INCLUDE_DIR}: This is the include directory for the GLAD library, which is set by the
#   find_package() call.
# - ${GLFW_INCLUDE_DIR}: This is the include directory for the GLFW library, which is set by the
#   find_package() call.
target_include_directories(${PROJECT_NAME} PRIVATE
    ${INCLUDE_DIR}
    ${GLAD_INCLUDES_DIR}
    ${GLFW_INCLUDES_DIR}
)

# Link libraries
# The target_link_libraries() function is used to specify the libraries that the
# ${PROJECT_NAME} target should link against. The OpenGL::GL library is the
# OpenGL library that is found by the find_package() call. The ${GLFW_LIBRARY}
# is the GLFW library that is found by the find_package() call. When the
# ${PROJECT_NAME} target is linked, these libraries are linked against.
target_link_libraries(${PROJECT_NAME}
    OpenGL::GL
    ${GLFW_LIBRARY}
)

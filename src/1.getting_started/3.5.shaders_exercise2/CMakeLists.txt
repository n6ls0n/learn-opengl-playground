cmake_minimum_required(VERSION 3.10)
project(shaders_exercise2)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

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

# Set the output directory for the executable
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

# Copy files to Debug folder inside the build directory
add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/Debug/3.5.shader.vs ${CMAKE_BINARY_DIR}/Debug/3.5.shader.fs
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/Debug
    COMMAND ${CMAKE_COMMAND} -E copy
            ${CMAKE_CURRENT_SOURCE_DIR}/3.5.shader.vs
            ${CMAKE_CURRENT_SOURCE_DIR}/3.5.shader.fs
            ${CMAKE_BINARY_DIR}/Debug
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/3.5.shader.vs ${CMAKE_CURRENT_SOURCE_DIR}/3.5.shader.fs
)

add_custom_target(copy_shaders ALL DEPENDS ${CMAKE_BINARY_DIR}/Debug/3.5.shader.vs ${CMAKE_BINARY_DIR}/Debug/3.5.shader.fs)

# The add_executable() function is used to specify the source files for the
# ${PROJECT_NAME} target. The ${GLAD_SRC} file is included as a source file
# because it is a single source file that is used to generate the GLAD
# library. The shaders_exercise2.cpp file is the source file for this example.
add_executable(${PROJECT_NAME} shaders_exercise2.cpp ${GLAD_SRC})

# Make sure the shaders are copied before building the executable
add_dependencies(${PROJECT_NAME} copy_shaders)

# The target_include_directories() function is used to specify the include directories for the
# ${PROJECT_NAME} target. The PRIVATE keyword means that the include directories are only
# used for this target and not propagated to any dependent targets.
target_include_directories(${PROJECT_NAME} PRIVATE
    ${INCLUDE_DIR}
    ${GLAD_INCLUDES_DIR}
    ${GLFW_INCLUDES_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/../../../includes/learnopengl
)

# Link libraries
target_link_libraries(${PROJECT_NAME}
    OpenGL::GL
    ${GLFW_LIBRARY}
)

cmake_minimum_required(VERSION 3.10)
project(ssao)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set paths to look for libraries and includes
set(LIB_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../lib")
set(INCLUDES_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../includes")
set(DLLS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../dlls")

# Find OpenGL
find_package(OpenGL REQUIRED)

# Set GLFW settings
set(GLFW_DIR "${LIB_DIR}")
set(GLFW_INCLUDES_DIR "${INCLUDES_DIR}/GLFW")
set(GLFW_LIBRARY "${GLFW_DIR}/glfw3.lib")

# Set GLAD settings
set(GLAD_INCLUDES_DIR "${INCLUDES_DIR}")
set(GLAD_SRC "${CMAKE_CURRENT_SOURCE_DIR}/../../../src/glad.c")

# Set Assimp settings
set(ASSIMP_INCLUDE_DIR "${INCLUDES_DIR}/assimp")
set(ASSIMP_LIBRARY "${LIB_DIR}/assimp.lib")
set(ASSIMP_DLL "${DLLS_DIR}/assimp-vc140-mt.dll")

# Copy specified files to Debug folder inside the build directory
add_custom_command(
    OUTPUT
        ${CMAKE_BINARY_DIR}/Debug/9.ssao_geometry.vs
        ${CMAKE_BINARY_DIR}/Debug/9.ssao_geometry.fs
        ${CMAKE_BINARY_DIR}/Debug/9.ssao.vs
        ${CMAKE_BINARY_DIR}/Debug/9.ssao_lighting.fs
        ${CMAKE_BINARY_DIR}/Debug/9.ssao.fs
        ${CMAKE_BINARY_DIR}/Debug/9.ssao_blur.fs
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/Debug
    COMMAND ${CMAKE_COMMAND} -E copy
            ${CMAKE_CURRENT_SOURCE_DIR}/9.ssao_geometry.vs
            ${CMAKE_CURRENT_SOURCE_DIR}/9.ssao_geometry.fs
            ${CMAKE_CURRENT_SOURCE_DIR}/9.ssao.vs
            ${CMAKE_CURRENT_SOURCE_DIR}/9.ssao_lighting.fs
            ${CMAKE_CURRENT_SOURCE_DIR}/9.ssao.fs
            ${CMAKE_CURRENT_SOURCE_DIR}/9.ssao_blur.fs
            ${CMAKE_BINARY_DIR}/Debug
    COMMAND ${CMAKE_COMMAND} -E copy_directory
            ${CMAKE_CURRENT_SOURCE_DIR}/backpack
            ${CMAKE_BINARY_DIR}/Debug
    DEPENDS
        ${CMAKE_CURRENT_SOURCE_DIR}/9.ssao_geometry.vs
        ${CMAKE_CURRENT_SOURCE_DIR}/9.ssao_geometry.fs
        ${CMAKE_CURRENT_SOURCE_DIR}/9.ssao.vs
        ${CMAKE_CURRENT_SOURCE_DIR}/9.ssao_lighting.fs
        ${CMAKE_CURRENT_SOURCE_DIR}/9.ssao.fs
        ${CMAKE_CURRENT_SOURCE_DIR}/9.ssao_blur.fs
)

add_custom_target(copy_resources ALL
    DEPENDS
        ${CMAKE_BINARY_DIR}/Debug/9.ssao_geometry.vs
        ${CMAKE_BINARY_DIR}/Debug/9.ssao_geometry.fs
        ${CMAKE_BINARY_DIR}/Debug/9.ssao.vs
        ${CMAKE_BINARY_DIR}/Debug/9.ssao_lighting.fs
        ${CMAKE_BINARY_DIR}/Debug/9.ssao.fs
        ${CMAKE_BINARY_DIR}/Debug/9.ssao_blur.fs
)

# The add_executable() function is used to specify the source files for the
# ${PROJECT_NAME} target. The ${GLAD_SRC} file is included as a source file
# because it is a single source file that is used to generate the GLAD
# library.
add_executable(${PROJECT_NAME} ssao.cpp ${GLAD_SRC})

# Make sure the resources are copied before building the executable
add_dependencies(${PROJECT_NAME} copy_resources)

# Copy Assimp DLL to output directory
add_custom_command(
    TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy ${ASSIMP_DLL} ${CMAKE_BINARY_DIR}/Debug
)

# The target_include_directories() function is used to specify the include directories for the
# ${PROJECT_NAME} target. The PRIVATE keyword means that the include directories are only
# used for this target and not propagated to any dependent targets.
target_include_directories(${PROJECT_NAME} PRIVATE
    ${INCLUDES_DIR}
    ${GLAD_INCLUDES_DIR}
    ${GLFW_INCLUDES_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/../../../includes/learnopengl
    ${CMAKE_BINARY_DIR}
    ${ASSIMP_INCLUDE_DIR}
)

# Link libraries
target_link_libraries(${PROJECT_NAME}
    OpenGL::GL
    ${GLFW_LIBRARY}
    ${ASSIMP_LIBRARY}
)

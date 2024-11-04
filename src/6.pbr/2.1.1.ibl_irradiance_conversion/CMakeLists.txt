cmake_minimum_required(VERSION 3.10)
project(ibl_irradiance_conversion)

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

# Copy specified files to Debug folder inside the build directory
add_custom_command(
    OUTPUT
        ${CMAKE_BINARY_DIR}/Debug/2.1.1.pbr.vs
        ${CMAKE_BINARY_DIR}/Debug/2.1.1.pbr.fs
        ${CMAKE_BINARY_DIR}/Debug/2.1.1.cubemap.vs
        ${CMAKE_BINARY_DIR}/Debug/2.1.1.equirectangular_to_cubemap.fs
        ${CMAKE_BINARY_DIR}/Debug/2.1.1.background.vs
        ${CMAKE_BINARY_DIR}/Debug/2.1.1.background.fs
        ${CMAKE_BINARY_DIR}/Debug/newport_loft.hdr
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/Debug
    COMMAND ${CMAKE_COMMAND} -E copy
            ${CMAKE_CURRENT_SOURCE_DIR}/2.1.1.pbr.vs
            ${CMAKE_CURRENT_SOURCE_DIR}/2.1.1.pbr.fs
            ${CMAKE_CURRENT_SOURCE_DIR}/2.1.1.cubemap.vs
            ${CMAKE_CURRENT_SOURCE_DIR}/2.1.1.equirectangular_to_cubemap.fs
            ${CMAKE_CURRENT_SOURCE_DIR}/2.1.1.background.vs
            ${CMAKE_CURRENT_SOURCE_DIR}/2.1.1.background.fs
            ${CMAKE_CURRENT_SOURCE_DIR}/newport_loft.hdr
            ${CMAKE_BINARY_DIR}/Debug
    DEPENDS
        ${CMAKE_CURRENT_SOURCE_DIR}/2.1.1.pbr.vs
        ${CMAKE_CURRENT_SOURCE_DIR}/2.1.1.pbr.fs
        ${CMAKE_CURRENT_SOURCE_DIR}/2.1.1.cubemap.vs
        ${CMAKE_CURRENT_SOURCE_DIR}/2.1.1.equirectangular_to_cubemap.fs
        ${CMAKE_CURRENT_SOURCE_DIR}/2.1.1.background.vs
        ${CMAKE_CURRENT_SOURCE_DIR}/2.1.1.background.fs
        ${CMAKE_CURRENT_SOURCE_DIR}/newport_loft.hdr
)

add_custom_target(copy_resources ALL
    DEPENDS
        ${CMAKE_BINARY_DIR}/Debug/2.1.1.pbr.vs
        ${CMAKE_BINARY_DIR}/Debug/2.1.1.pbr.fs
        ${CMAKE_BINARY_DIR}/Debug/2.1.1.cubemap.vs
        ${CMAKE_BINARY_DIR}/Debug/2.1.1.equirectangular_to_cubemap.fs
        ${CMAKE_BINARY_DIR}/Debug/2.1.1.background.vs
        ${CMAKE_BINARY_DIR}/Debug/2.1.1.background.fs
        ${CMAKE_BINARY_DIR}/Debug/newport_loft.hdr
)

# The add_executable() function is used to specify the source files for the
# ${PROJECT_NAME} target. The ${GLAD_SRC} file is included as a source file
# because it is a single source file that is used to generate the GLAD
# library.
add_executable(${PROJECT_NAME} ibl_irradiance_conversion.cpp ${GLAD_SRC})

# Make sure the resources are copied before building the executable
add_dependencies(${PROJECT_NAME} copy_resources)

# The target_include_directories() function is used to specify the include directories for the
# ${PROJECT_NAME} target. The PRIVATE keyword means that the include directories are only
# used for this target and not propagated to any dependent targets.
target_include_directories(${PROJECT_NAME} PRIVATE
    ${INCLUDES_DIR}
    ${GLAD_INCLUDES_DIR}
    ${GLFW_INCLUDES_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/../../../includes/learnopengl
    ${CMAKE_BINARY_DIR}
)

# Link libraries
target_link_libraries(${PROJECT_NAME}
    OpenGL::GL
    ${GLFW_LIBRARY}
)

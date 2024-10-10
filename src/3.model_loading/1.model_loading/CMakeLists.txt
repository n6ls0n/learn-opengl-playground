cmake_minimum_required(VERSION 3.10)
project(model_loading)

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

# Define the source and destination paths for the backpack folder
set(BACKPACK_SRC "${CMAKE_CURRENT_SOURCE_DIR}/backpack")

# Check if the backpack folder exists in the current directory
if(NOT EXISTS ${BACKPACK_SRC})
    # If not, check the parent directory
    set(BACKPACK_SRC "${CMAKE_CURRENT_SOURCE_DIR}/../backpack")
    if(NOT EXISTS ${BACKPACK_SRC})
        message(FATAL_ERROR "Backpack folder not found in ${CMAKE_CURRENT_SOURCE_DIR} or its parent directory")
    endif()
endif()

set(BACKPACK_DEST "${CMAKE_BINARY_DIR}/Debug")

# Copy shader files to Debug folder inside the build directory
add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/Debug/1.model_loading.vs ${CMAKE_BINARY_DIR}/Debug/1.model_loading.fs
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/Debug
    COMMAND ${CMAKE_COMMAND} -E copy
        ${CMAKE_CURRENT_SOURCE_DIR}/1.model_loading.vs
        ${CMAKE_CURRENT_SOURCE_DIR}/1.model_loading.fs
        ${CMAKE_BINARY_DIR}/Debug
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/1.model_loading.vs ${CMAKE_CURRENT_SOURCE_DIR}/1.model_loading.fs
)

# Copy individual files from the backpack folder
file(GLOB BACKPACK_FILES "${BACKPACK_SRC}/*")
set(COPIED_BACKPACK_FILES "")

foreach(FILE ${BACKPACK_FILES})
    get_filename_component(FILENAME ${FILE} NAME)
    set(DEST_FILE "${BACKPACK_DEST}/${FILENAME}")
    list(APPEND COPIED_BACKPACK_FILES ${DEST_FILE})

    add_custom_command(
        OUTPUT ${DEST_FILE}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${BACKPACK_DEST}
        COMMAND ${CMAKE_COMMAND} -E copy ${FILE} ${DEST_FILE}
        DEPENDS ${FILE}
    )
endforeach()

add_custom_target(copy_resources ALL
    DEPENDS
        ${CMAKE_BINARY_DIR}/Debug/1.model_loading.vs
        ${CMAKE_BINARY_DIR}/Debug/1.model_loading.fs
        ${COPIED_BACKPACK_FILES}
)

# Define the executable
add_executable(${PROJECT_NAME} model_loading.cpp ${GLAD_SRC})

# Make sure the resources are copied before building the executable
add_dependencies(${PROJECT_NAME} copy_resources)

# Copy Assimp DLL to output directory
add_custom_command(
    TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy ${ASSIMP_DLL} ${CMAKE_BINARY_DIR}/Debug
)

# Set include directories
target_include_directories(${PROJECT_NAME} PRIVATE
    ${INCLUDES_DIR}
    ${GLAD_INCLUDES_DIR}
    ${GLFW_INCLUDES_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/../../../../includes/learnopengl
    ${CMAKE_BINARY_DIR}
    ${ASSIMP_INCLUDE_DIR}
)

# Link libraries
target_link_libraries(${PROJECT_NAME} PRIVATE
    OpenGL::GL
    ${GLFW_LIBRARY}
    ${ASSIMP_LIBRARY}
)

# Add these lines for debugging
message(STATUS "Current source dir: ${CMAKE_CURRENT_SOURCE_DIR}")
message(STATUS "Backpack source: ${BACKPACK_SRC}")
message(STATUS "Backpack destination: ${BACKPACK_DEST}")
message(STATUS "Binary dir: ${CMAKE_BINARY_DIR}")

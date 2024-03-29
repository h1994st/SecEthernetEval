cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(host)

# Undocumented options
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)
set(CMAKE_DISABLE_SOURCE_CHANGES ON)
if ("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
    message(FATAL_ERROR "In-source builds are not allowed.")
endif ()

# Check build type
if (NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING
            "Choose the build type" FORCE)

    # Include "None" as option to disable any additional (optimization) flags,
    # relying on just CMAKE_C_FLAGS and CMAKE_CXX_FLAGS (which are empty by
    # default). These strings are presented in cmake-gui.
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
            "None" "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif ()

# Do not disable assertions based on CMAKE_BUILD_TYPE.
foreach (_build_type "Release" "MinSizeRel" "RelWithDebInfo")
    foreach (_lang C CXX)
        string(TOUPPER "CMAKE_${_lang}_FLAGS_${_build_type}" _var)
        string(REGEX REPLACE "(^| )[/-]D *NDEBUG($| )" "" ${_var} "${${_var}}")
    endforeach ()
endforeach ()

# C++ language standard
set(CMAKE_CXX_STANDARD 14)

# Toolchain
message(STATUS "C compiler: ${CMAKE_C_COMPILER}")
message(STATUS "C++ compiler: ${CMAKE_CXX_COMPILER}")

add_executable(client client.c)
target_link_libraries(client
        PRIVATE wolfssl)

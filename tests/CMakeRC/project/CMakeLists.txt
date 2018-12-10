cmake_minimum_required(VERSION 3.5)
project(Test)

include(${CMCM})

include(CMakeRC)

cmrc_add_resource_library(dummy CMakeLists.txt)

add_executable(dummy-user main.cpp)
target_link_libraries(dummy-user PRIVATE dummy)
cmake_minimum_required(VERSION 3.7 FATAL_ERROR)
project(Experimental CXX)

include(${CMCM})

find_package(Filesystem REQUIRED Experimental)

add_executable(fs-user test.cpp)
target_link_libraries(fs-user std::filesystem)

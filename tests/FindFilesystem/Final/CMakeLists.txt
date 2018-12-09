cmake_minimum_required(VERSION 3.8 FATAL_ERROR)
project(Final CXX)

include(${CMCM})

find_package(Filesystem REQUIRED Final)

add_executable(fs-user test.cpp)
target_link_libraries(fs-user std::filesystem)

cmake_minimum_required(VERSION 3.13 FATAL_ERROR)
project(MaybeFail CXX)

include(${CMCM})

find_package(Filesystem COMPONENTS Experimental Final)

if(TARGET std::filesystem)
    add_executable(fs-user test.cpp)
    target_link_libraries(fs-user std::filesystem)
endif()

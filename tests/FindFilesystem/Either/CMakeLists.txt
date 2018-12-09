cmake_minimum_required(VERSION 3.13 FATAL_ERROR)
project(Either CXX)

include(${CMCM})

find_package(Filesystem REQUIRED Experimental Final)

add_executable(fs-user test.cpp)
target_link_libraries(fs-user std::filesystem)
target_compile_definitions(fs-user PRIVATE
    FS_HEADER=<${CXX_FILESYSTEM_HEADER}>
    FS_NAMESPACE=${CXX_FILESYSTEM_NAMESPACE}
    )

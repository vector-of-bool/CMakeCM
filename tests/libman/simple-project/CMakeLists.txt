cmake_minimum_required(VERSION 3.8)
project(SimpleProject)

include(${CMCM})

include(libman)

import_packages(Widgets)

add_executable(hello-widgets main.cpp)
target_link_libraries(hello-widgets PRIVATE ACME::Widgets)
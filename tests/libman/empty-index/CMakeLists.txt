cmake_minimum_required(VERSION 3.8)
project(EmptyIndex)

include(${CMCM})

include(libman)

# There is no content of the index, but an empty import is okay
import_packages()
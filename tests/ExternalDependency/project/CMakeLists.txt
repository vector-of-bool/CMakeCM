cmake_minimum_required(VERSION 3.11)
project(Test)

include(${CMCM})

include(ExternalDependency)

# Vanilla
define_property(DIRECTORY PROPERTY EXTERNAL_DEPENDENCY_VANILLA_TEST_PASSED
    BRIEF_DOCS "doc" FULL_DOCS "doc")
set_directory_properties(PROPERTIES EXTERNAL_DEPENDENCY_VANILLA_TEST_PASSED FALSE)

external_dependency(
    external_dependency_test_vanilla
    URL "${CMAKE_CURRENT_SOURCE_DIR}/vanilla"
)

get_directory_property(test_passed EXTERNAL_DEPENDENCY_VANILLA_TEST_PASSED)
if(NOT test_passed)
    message(SEND_ERROR "add_subdirectory() not called when required")
endif()

# Chocolate
define_property(DIRECTORY PROPERTY EXTERNAL_DEPENDENCY_CHOCOLATE_TEST_PASSED
    BRIEF_DOCS "doc" FULL_DOCS "doc")
set_directory_properties(PROPERTIES EXTERNAL_DEPENDENCY_CHOCOLATE_TEST_PASSED FALSE)

function(call_external_dependency_test name)
  if(NOT "${ARGV}" STREQUAL "${name};extra;arguments")
    message(SEND_ERROR "Improper arguments: `${ARGV}`. Expected: `${name};extra;arguments`")
  endif()

  set_directory_properties(PROPERTIES EXTERNAL_DEPENDENCY_CHOCOLATE_TEST_PASSED TRUE)
endfunction()

external_dependency(
    external_dependency_test_chocolate
    URL "${CMAKE_CURRENT_SOURCE_DIR}/chocolate"
    ON_POPULATE call_external_dependency_test
    WITH_ARGS "extra;arguments"
)

get_directory_property(test_passed EXTERNAL_DEPENDENCY_CHOCOLATE_TEST_PASSED)
if(NOT test_passed)
    message(SEND_ERROR "ON_POPULATE not called when required")
endif()

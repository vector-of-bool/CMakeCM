cmake_minimum_required(VERSION 3.11)
project(Test)

include(${CMCM})

include(IndirectCall)

define_property(DIRECTORY PROPERTY indirect_call_test_function_called
    BRIEF_DOCS "doc" FULL_DOCS "doc")
set_directory_properties(PROPERTIES indirect_call_test_function_called FALSE)

function(indirect_call_test_function arg1 arg2 arg3)
    if(arg1 EQUAL 1 AND arg2 STREQUAL "" AND arg3 STREQUAL "2;3" AND "${ARGC}" EQUAL 3)
      set_directory_properties(PROPERTIES indirect_call_test_function_called TRUE)
    else()
      message(SEND_ERROR "Invalid arguments. Expected 3: `1` `` `2;3`. Got ${ARGC}: `${arg1}` `${arg2}` `${arg3}`")
    endif()
endfunction()

indirect_call("indirect_call_test_function" 1 "" "2;3")

get_directory_property(test_passed indirect_call_test_function_called)
if(NOT test_passed)
  message(SEND_ERROR "Indirect call failed")
endif()

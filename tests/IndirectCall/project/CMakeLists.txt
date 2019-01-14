cmake_minimum_required(VERSION 3.11)
project(Test)

include(${CMCM})

include(IndirectCall)

define_property(DIRECTORY PROPERTY indirect_call_test_function_called
    BRIEF_DOCS "doc" FULL_DOCS "doc")
set_directory_properties(PROPERTIES indirect_call_test_function_called FALSE)

function(indirect_call_test_function arg)
    if(arg EQUAL 1)
      set_directory_properties(PROPERTIES indirect_call_test_function_called TRUE)
    endif()
endfunction()

indirect_call("indirect_call_test_function" 1)

get_directory_property(test_passed indirect_call_test_function_called)
if(NOT test_passed)
  message(SEND_ERROR "Indirect call failed")
endif()

set(_indirect_call_file "${CMAKE_BINARY_DIR}/_indirect_call.cmake" CACHE INTERNAL "")

# Calls a function whose name is stored in a string
#
# Usage:
# indirect_call("${function_name}" args)
function(indirect_call NAME)
  set(args)
  set(index 1)
  while(index LESS ARGC)
    set(args "${args} \"${ARGV${index}}\"")
    math(EXPR index "${index}+1")
  endwhile()

  file(WRITE "${_indirect_call_file}" "${NAME}(${args})")
  include("${_indirect_call_file}")
endfunction()

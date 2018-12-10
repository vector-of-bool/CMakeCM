function(cmcm_add_test_project name)
    set(options)
    set(args SOURCE_DIR BINARY_DIR)
    set(list_args)
    cmake_parse_arguments(PARSE_ARGV 1 ARG "${options}" "${args}" "${list_args}")
    if(NOT IS_ABSOLUTE "${ARG_BINARY_DIR}")
        set(ARG_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/${ARG_BINARY_DIR}")
    endif()
    get_filename_component(ARG_SOURCE_DIR "${ARG_SOURCE_DIR}" ABSOLUTE)
    add_test(NAME ${name} COMMAND ${CMAKE_CTEST_COMMAND}
        --build-and-test
        "${ARG_SOURCE_DIR}"
        "${ARG_BINARY_DIR}"
        --build-generator ${CMAKE_GENERATOR}
        --build-options
            "-DCMCM=${PROJECT_SOURCE_DIR}/CMakeCM.cmake"
            "-DCMCM_LOCAL_RESOLVE_URL=file://${PROJECT_SOURCE_DIR}"
        --test-command ${CMAKE_CTEST_COMMAND} -j4
        )
  set_property(TEST ${name} PROPERTY ENVIRONMENT CXX=${CMAKE_CXX_COMPILER} CC=${CMAKE_C_COMPILER})
endfunction()

foreach(testdir
        FindBikeshed
        FindFilesystem
        CMakeRC
        )
    if(NOT testdir IN_LIST DISABLE_TESTS)
        add_subdirectory(${testdir})
    endif()
endforeach()

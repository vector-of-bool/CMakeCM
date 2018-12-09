# Determine which filesystem tests we should run based on the compiler version
set(tests MaybeFail)

set(comp_id ${CMAKE_CXX_COMPILER_ID})
set(comp_version ${CMAKE_CXX_COMPILER_VERSION})
if(comp_id STREQUAL "GNU")
    if(comp_version VERSION_GREATER_EQUAL "6.0")
        list(APPEND tests Experimental Either)
    endif()
    if(comp_version VERSION_GREATER_EQUAL "8.0")
        list(APPEND tests Final)
    endif()
elseif(comp_id STREQUAL "Clang")
    if(comp_version VERSTION_GREATER_EQUAL "7.0")
        list(APPEND tests Experimental Either Final)
    endif()
elseif(comp_id STREQUAL "MSVC")
    if(comp_version VERSION_GREATER_EQUAL "19.14")
        list(APPEND tests Experimental Either Final)
    endif()
endif()

# Generate the tests
foreach(test IN LISTS tests)
    cmcm_add_test_project(
        FindFilesystem.${test}
        SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/${test}"
        BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/test.${test}"
        )
endforeach()

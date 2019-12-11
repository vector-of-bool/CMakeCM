
foreach(test IN ITEMS
        just-include
        empty-index
        simple-project
        )
    cmcm_add_test_project(
        libman.${test}
        SOURCE_DIR ${test}
        BINARY_DIR test.libman.${test}
        )
endforeach()
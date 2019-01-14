include(CMakePushCheckState)
include(CheckIncludeFileCXX)
include(CheckCXXSourceCompiles)

cmake_push_check_state(RESET)
set(CMAKE_CXX_STANDARD 20)

set(code [[

    template <typename T>
    concept Animal = requires(T a) {
        { a.make_sound() } -> void
    };

    template <Animal T>
    void make_sound(T animal) {
        animal.make_sound();
    }

    struct Cat {
        void make_sound() {
            /* Meow */
        }
    };

    int main() {
        Cat c;
        make_sound(c);
    }

]])

check_cxx_source_compiles("${code}" HAVE_CXX_CONCEPTS)

if(NOT HAVE_CXX_CONCEPTS)
    set(CMAKE_REQUIRED_FLAGS -fconcepts)
    check_cxx_source_compiles("${code}" HAVE_CXX_CONCEPTS_WITH_FCONCEPTS)
    if(NOT HAVE_CXX_CONCEPTS_WITH_FCONCEPTS)
        set(CMAKE_REQUIRED_DEFINITIONS "-Dconcept=concept\\ bool")
        check_cxx_source_compiles("${code}" HAVE_CXX_CONCEPTS_TS_WITH_FCONCEPTS)
    endif()
endif()

if(HAVE_CXX_CONCEPTS_TS_WITH_FCONCEPTS OR HAVE_CXX_CONCEPTS_WITH_FCONCEPTS OR HAVE_CXX_CONCEPTS)
    add_library(CXX::Concepts INTERFACE IMPORTED)
    target_compile_definitions(CXX::Concepts INTERFACE CXX_CONCEPTS_AVAILABLE)
endif()

if(HAVE_CXX_CONCEPTS_TS_WITH_FCONCEPTS OR HAVE_CXX_CONCEPTS_WITH_FCONCEPTS)
    target_compile_options(CXX::Concepts INTERFACE -fconcepts)
endif()

if(HAVE_CXX_CONCEPTS_TS_WITH_FCONCEPTS)
    target_compile_definitions(CXX::Concepts INTERFACE "concept=concept bool")
endif()

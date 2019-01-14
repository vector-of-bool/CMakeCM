#[=======================================================================[.rst:
ExternalDependency
------------------

This module wraps FetchContent_ with a higher-level interface,
reducing the required boilerplate.
Typical usage would look something like this:

.. code-block:: cmake

  external_dependency(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG        release-1.8.0
  )

COMMAND
-------

.. command:: external_dependency

  .. code-block:: cmake

    external_dependency(<name> <options>...)

  The ``external_dependency()`` function is equivalent to both
  ``FetchContent_Declare`` and ``FetchContent_Populate``, appropriately guarded:

  .. code-block:: cmake

    # Equivalent to:
    FetchContent_Declare(<name> <options>...)

    FetchContent_GetProperties(<name>)
    if(NOT <lname>_POPULATED) # <lname> is lowercased <name>
      FetchContent_Populate(<name>)

      add_subdirectory("${<name>_SOURCE_DIR}" "${<name>_BINARY_DIR}")
    endif()

  The ``<options>`` can be any of the options supported by
  ``FetchContent_Declare()``__, as well as ``ON_POPULATE`` and ``WITH_ARGS``.

  If the aforementioned ``add_subdirectory()`` call is not desired,
  the name of an alternate function may be passed with ``ON_POPULATE``.
  This function shall receive the lowercased version of ``<name>`` as its first
  argument:

  __ FetchContentDeclare

  .. code-block:: cmake

    function(my_function name)
      message(STATUS "${name}")
    endfunction()

    external_dependency(
      MyDependency
      <options>...
      ON_POPULATE my_function
    )

    # Equivalent to:
    FetchContent_Declare(MyDependency <options>...)

    FetchContent_GetProperties(MyDependency)
    if(NOT mydependency_POPULATED)
      FetchContent_Populate(MyDependency)

      my_function(mydependency)
    endif()

  When omitted, ``ON_POPULATE`` defaults to ``external_dependency_subdirectory``,
  which calls ``add_subdirectory()`` with the source and binary directory.

  If additional arguments are desired, they may be specified via ``WITH_ARGS``.
  ``WITH_ARGS`` accepts a single string of semicolon separated arguments to
  pass to the callback specified with ``ON_POPULATE``:

  .. code-block:: cmake

    function(my_function name some other args)
      message(STATUS "${name} ${some} ${other} ${args}")
    endfunction()

    external_dependency(
      MyDependency
      <options>...
      ON_POPULATE my_function
      WITH_ARGS "first;second;third arg"
    )

    # Equivalent to:
    FetchContent_Declare(MyDependency <options>...)

    FetchContent_GetProperties(MyDependency)
    if(NOT mydependency_POPULATED)
      FetchContent_Populate(MyDependency)

      my_function(mydependency first second "third arg")
    endif()

.. _FetchContent: https://cmake.org/cmake/help/latest/module/FetchContent.html
.. _FetchContentDeclare: https://cmake.org/cmake/help/latest/module/FetchContent.html#command:fetchcontent_declare

Examples
--------

.. code-block:: cmake

  # Equivalent to the typical usage example of FetchContent.
  external_dependency(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG        release-1.8.0
  )

.. code-block:: cmake

  # Equivalent to the previous example, but more explicit
  external_dependency(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG        release-1.8.0
    ON_POPULATE external_dependency_subdirectory
  )

.. code-block:: cmake

  function(make_headeronly_library name libname)
    add_library(${libname} INTERFACE)
    target_include_directories(${libname}
      INTERFACE
        "${${name}_SOURCE_DIR}/include"
    )
  endfunction()

  external_dependency(
    dependency
    URL https://example.org/path/to/dependency
    ON_POPULATE make_headeronly_library
    WITH_ARGS "some_library"
  )

  # When populating, this is equivalent to:
  add_library(some_library INTERFACE)
  target_include_directories(some_library
    INTERFACE
      "${dependency_SOURCE_DIR}/include"
  )

#]=======================================================================]

include(FetchContent)
include(IndirectCall)

function(external_dependency contentName)
  set(options)
  set(args ON_POPULATE WITH_ARGS)
  set(multi_args)

  cmake_parse_arguments(PARSE_ARGV 1 ARG "${options}" "${args}" "${multi_args}")

  if(NOT DEFINED ARG_ON_POPULATE)
    set(ARG_ON_POPULATE external_dependency_subdirectory)
  endif()

  string(TOLOWER "${contentName}" lname)

  FetchContent_Declare(
    "${contentName}"
    ${ARG_UNPARSED_ARGUMENTS}
  )

  FetchContent_GetProperties("${contentName}")
  if(NOT "${${lname}_POPULATED}")
    FetchContent_Populate("${contentName}")

    indirect_call("${ARG_ON_POPULATE}" "${lname}" ${ARG_WITH_ARGS})
  endif()
endfunction()

function(external_dependency_subdirectory name)
  add_subdirectory("${${name}_SOURCE_DIR}" "${${name}_BINARY_DIR}")
endfunction()

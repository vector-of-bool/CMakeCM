macro(_cmcm_set_if_undef varname)
    if(NOT DEFINED "${varname}")
        set(__default "${ARGN}")
    else()
        set(__default "${${varname}}")
    endif()
    set("${varname}" "${__default}" CACHE STRING "" FORCE)
endmacro()

# This is the base URL to resolve `LOCAL` modules
_cmcm_set_if_undef(CMCM_LOCAL_RESOLVE_URL "https://vector-of-bool.github.io/CMakeCM")
# This is the directory where CMakeCM will store its downloaded modules
_cmcm_set_if_undef(CMCM_MODULE_DIR "${CMAKE_BINARY_DIR}/_cmcm-modules")

function(cmcm_module name)
    set(options)
    set(args REMOTE LOCAL VERSION)
    set(list_args ALSO)
    cmake_parse_arguments(ARG "${options}" "${args}" "${list_args}" "${ARGV}")
    if(NOT ARG_REMOTE AND NOT ARG_LOCAL)
        message(FATAL_ERROR "Either LOCAL or REMOTE is required for cmcm_module")
    endif()
    if(NOT ARG_VERSION)
        message(FATAL_ERROR "Expected a VERSION for cmcm_module")
    endif()
    file(MAKE_DIRECTORY "${CMCM_MODULE_DIR}")
    file(WRITE "${CMCM_MODULE_DIR}/${name}"
        "_cmcm_include_module([[${name}]] [[${ARG_REMOTE}]] [[${ARG_LOCAL}]] [[${ARG_VERSION}]] [[${ARG_ALSO}]])\n"
        )
endfunction()

macro(_cmcm_include_module name remote local version also)
    set(__module_name "${name}")
    set(__remote "${remote}")
    set(__local "${local}")
    set(__version "${version}")
    get_filename_component(__resolved_dir "${CMCM_MODULE_DIR}/resolved" ABSOLUTE)
    get_filename_component(__resolved "${__resolved_dir}/${__module_name}" ABSOLUTE)
    get_filename_component(__resolved_stamp "${CMCM_MODULE_DIR}/resolved/${__module_name}.whence" ABSOLUTE)
    set(__whence_string "${CMCM_LOCAL_RESOLVE_URL}::${__remote}${__local}.${__version}")
    set(__download FALSE)
    if(EXISTS "${__resolved}")
        file(READ "${__resolved_stamp}" __stamp)
        if(NOT __stamp STREQUAL __whence_string)
            set(__download TRUE)
        endif()
    else()
        set(__download TRUE)
    endif()
    if(__download)
        file(MAKE_DIRECTORY "${__resolved_dir}")
        if(__remote)
            set(__url "${__remote}")
        else()
            set(__url "${CMCM_LOCAL_RESOLVE_URL}/${__local}")
        endif()
        message(STATUS "[CMakeCM] Downloading new module ${__module_name}")
        file(DOWNLOAD
            "${__url}"
            "${__resolved}"
            STATUS __st
            )
        list(GET __st 0 __rc)
        list(GET __st 1 __msg)
        if(__rc)
            message(FATAL_ERROR "Error while downloading file from '${__url}' to '${__resolved}' [${__rc}]: ${__msg}")
        endif()
        file(WRITE "${__resolved_stamp}" "${__whence_string}")
    endif()
    include("${__resolved}")
endmacro()

cmcm_module(FindFilesystem.cmake
    LOCAL modules/FindFilesystem.cmake
    VERSION 1
    )

cmcm_module(CMakeRC.cmake
    REMOTE https://raw.githubusercontent.com/vector-of-bool/cmrc/966a1a717715f4e57fb1de00f589dea1001b5ae6/CMakeRC.cmake
    VERSION 1
    )

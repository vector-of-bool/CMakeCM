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
    set(__also "${also}")
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
        string(REGEX REPLACE "(.*)/[^/]+" "\\1" __url_dir "${__url}")
        get_filename_component(__url_filename "${__url}" NAME)
        message(STATUS "[CMakeCM] Downloading module ${__module_name}")
        set(__to_download)
        foreach(__item IN LISTS __url_filename __also)
            get_filename_component(__resolved_fpath "${__resolved_dir}/${__item}" ABSOLUTE)
            get_filename_component(__fpath_dir "${__resolved_fpath}" DIRECTORY)
            file(MAKE_DIRECTORY "${__fpath_dir}")
            set(__url "${__url_dir}/${__item}")
            file(DOWNLOAD
                "${__url}"
                "${__resolved_fpath}"
                STATUS __st
                )
            list(GET __st 0 __rc)
            list(GET __st 1 __msg)
            if(__rc)
                message(FATAL_ERROR "Error while downloading file from '${__url}' to '${__resolved_fpath}' [${__rc}]: ${__msg}")
            endif()
        endforeach()
        file(WRITE "${__resolved_stamp}" "${__whence_string}")
    endif()
    include("${__resolved}")
endmacro()


list(APPEND CMAKE_MODULE_PATH "${CMCM_MODULE_DIR}")

cmcm_module(FindFilesystem.cmake
    LOCAL modules/FindFilesystem.cmake
    VERSION 1
    )

cmcm_module(CMakeRC.cmake
    REMOTE https://raw.githubusercontent.com/vector-of-bool/cmrc/966a1a717715f4e57fb1de00f589dea1001b5ae6/CMakeRC.cmake
    VERSION 1
    )

set(ixm_base https://raw.githubusercontent.com/slurps-mad-rips/ixm/34d4c306be95ff786843e4befd0df8ed74d3b5d8/modules)
set(ixm_version 1)
foreach(mod
        AcquireDependencies
        CheckEnvironment
        DefaultLayout
        PackageSearch
        PushState
        TargetProperties
        Tools
        )
    cmcm_module(${mod}.cmake
        REMOTE ${ixm_base}/${mod}.cmake
        VERSION ${ixm_version}
        )
endforeach()

cmcm_module(IXM.cmake
    REMOTE "${ixm_base}/IXM.cmake"
    VERSION ${ixm_version}
    ALSO
        AcquireDependencies/Archive.cmake
        AcquireDependencies/Arguments.cmake
        AcquireDependencies/Extern.cmake
        AcquireDependencies/Git.cmake
        AcquireDependencies/Header.cmake
        CheckEnvironment/CompilerFlagExists.cmake
        CheckEnvironment/HeaderExists.cmake
        CheckEnvironment/SymbolExists.cmake
        CheckEnvironment/TypeExists.cmake
        DefaultLayout/Docs.cmake
        DefaultLayout/Support.cmake
        DefaultLayout/Targets.cmake
        IXM/AddPackage.cmake
        IXM/Algorithm.cmake
        IXM/ArgParse.cmake
        IXM/Dump.cmake
        IXM/Fetch.cmake
        IXM/Get.cmake
        IXM/Halt.cmake
        IXM/Override.cmake
        IXM/ParentScope.cmake
        IXM/Print.cmake
        IXM/Setting.cmake
        IXM/SourceDepends.cmake
        IXM/Standalone.cmake
        PackageSearch/Check.cmake
        PackageSearch/Component.cmake
        PackageSearch/Hide.cmake
        PackageSearch/Library.cmake
        PackageSearch/Program.cmake
        PushState/FindFramework.cmake
        PushState/FindOptions.cmake
        PushState/ModulePath.cmake
        TargetProperties/CCachePrefix.cmake
        TargetProperties/ClangTidy.cmake
        TargetProperties/CompilerLauncher.cmake
        TargetProperties/Coverage.cmake
        TargetProperties/CppCheck.cmake
        TargetProperties/GlobSources.cmake
        TargetProperties/IPO.cmake
        TargetProperties/IncludeWhatYouUse.cmake
        Tools/Bloaty.cmake
        Tools/CCache.cmake
        Tools/Catch.cmake
        Tools/ClangCheck.cmake
        Tools/ClangFormat.cmake
        Tools/DistCC.cmake
        Tools/SCCache.cmake
        Tools/Sphinx.cmake
        Tools/Sphinx/CXX.cmake
        Tools/Sphinx/EPUB.cmake
        Tools/Sphinx/General.cmake
        Tools/Sphinx/HTML.cmake
        Tools/Sphinx/LATEX.cmake
        Tools/Sphinx/MAN.cmake
        Tools/Sphinx/Math.cmake
        Tools/Sphinx/Project.cmake
        Tools/Sphinx/XML.cmake
        Tools/Sphinx/i18n.cmake
    )

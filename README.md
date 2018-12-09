# CMake Community Modules

The CMake Community Modules are CMake modules created and maintained by the
community.

This repository's main product is the `CMakeCM.cmake` file in the repository
root. It defines what modules are available for download and consumption.


# How Do I Use the CMakeCM Modules?

There are two ways to use the modules provided by CMakeCM


## Use PMM (Recommended)

[PMM is a CMake tool that drives package management facilities from your own
`CMakeLists.txt`](https://github.com/vector-of-bool/pmm).

After including `pmm.cmake` in your project, pass `CMakeCM` to the `pmm()`
function, and the CMakeCM modules will be available for usage.

PMM will periodically download the latest version of CMakeCM without any user
intervention.

Example:

```cmake
include(pmm.cmake)
pmm(CMakeCM)  # Enable the CMakeCM modules

# Include a module:
include(CMakeRC)
```

That's all there is to it!


## Download the `CMakeCM.cmake` File to Your Own Project.

The `CMakeCM.cmake` file can be placed in your own project and `include()`'d
just like a regular file.

After you `include(CMakeCM.cmake)`, all modules from CMakeCM will be ready to
use.

**Note:** The modules are defined by `CMakeCM.cmake`, and it will not upgrade
itself automatically! For this reason, using PMM is recommended.

Example:

```cmake
include(CMakeCM.cmake)

# Include a module:
include(CMakeRC)
```


# I Want to Contribute a Module!

There are two ways to contribute a module to CMakeCM:

1. Add a "local" module in this repository.
2. Add a reference to a "remote" module.

Both methods will require modifying the repository and declaring the module in
`CMakeCM.cmake`


## Adding a "Local" Module

Local modules are contained within the CMakeCM repository. If you do not wish
to own a separate repository to contain the module, this is the recommended way
to do so.

To start, add a module file to the `modules` directory. This will be the module
that will be included by the user. It should consist of a single CMake file.

After adding the module, add a call to `cmcm_module` in `CMakeCM.cmake`.

Suppose you add a `SuperCoolModule.cmake` to `modules`. The resulting call in
`CMakeCM.cmake` will look something like this:

```cmake
cmcm_module(
    SuperCoolModule.cmake
    LOCAL modules/SuperCoolModule.cmake
    VERSION 1
    )
```

The `VERSION` argument is an arbitrary string that is used to invalidate local
copies of the module that have been downloaded.


## Adding a "Remote" Module

If you have a module that you wish to add, but it is contained in a remote location, you simply need to add the call in `CMakeCM.cmake`:

```cmake
cmcm_module(
    MyAwesomeModule.cmake
    REMOTE https://some-place.example.com/files/path/MyAwesomeModule.cmake
    VERSION 1
    )
```

The `VERSION` argument is an arbitrary string that is used to invalidate local
copies of the module that have been downloaded.

The `REMOTE` is a URL to the file to download for the module. In order for your
modification to be accepted into the repository, it must meet certain criteria:

1. The URL *must* use `https`.
2. The URL *must* refer to a stable file location. If using a Git URL, it should
   refer to a specific commit, not to a branch.

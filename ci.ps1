param(
    # Force using MSVC
    [switch]
    $ForceMSVC
)

$ErrorActionPreference = "Stop"

$cmake = (Get-Command cmake).Source

$source_dir = $PSScriptRoot
$bin_dir = Join-Path $source_dir ci-build

function Check-ExitCode {
    if ($LASTEXITCODE) {
        throw "Command failed [$LASTEXITCODE]"
    }
}

if ($ForceMSVC) {
    $env:CC = "cl"
    $env:CXX = "cl"
}

& $cmake -GNinja "-H$source_dir" "-B$bin_dir"
Check-ExitCode

& $cmake --build $bin_dir
Check-ExitCode

$ctest = Join-Path (Split-Path $cmake) ctest

& $cmake -E chdir $bin_dir $ctest -j4 --output-on-failure
$retc = $LASTEXITCODE
$cmake_logs = Get-ChildItem $bin_dir -Recurse -Include "CMakeError.log"
if ($retc -ne 0) {
    foreach ($item in $cmake_logs) {
        Write-Host "=========================="
        Write-Host "Contents of file:" $item.FullName
        Write-Host "VVVVVVVVVVVVVVVVVVVVVVVVVV"
        Get-Content $item | Write-Host
        Write-Host "^^^^^^^^^^^^^^^^^^^^^^^^^^"
    }
    throw "CTest execution failed [$retc]"
}

# & $cmake --build-and-test `
#     $source_dir `
#     $bin_dir `
#     --build-generator Ninja `
#     --test-command $cmake -j6
# if ($LASTEXITCODE) {
#     throw "Build failed"
# }
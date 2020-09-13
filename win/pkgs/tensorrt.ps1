################################################################################
# Nvidia may ask you to register on their website before downloading libraries.
# Please follow their instructions and procedures.
#
# You agree to take full responsibility for using this script, and relief
# authors from any liability of not acquiring data in the normal way.
################################################################################

#Requires -RunAsAdministrator

Get-Content "$PSScriptRoot/utils/re-entry.ps1" -Raw | Invoke-Expression
$ErrorActionPreference="Stop"

pushd ${Env:SCRATCH}
$proj="tensorrt"
$root="${Env:SCRATCH}/$proj"

rm -Force -Recurse -ErrorAction SilentlyContinue -WarningAction SilentlyContinue "$root"
if (Test-Path "$root")
{
    echo "Failed to remove `"$root`""
    Exit 1
}

mkdir "$root"
pushd "$root"

# Update the URL as new version releases.
$trt_mirror="https://github.com/xkszltl/Roaster/releases/download/trt"
$trt_name="TensorRT-7.1.3.4.Windows10.x86_64.cuda-11.0.cudnn8.0.zip"

if (-not (Test-Path "../${trt_name}"))
{
    rm -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue "../TensorRT-*.zip"
    & "${Env:ProgramFiles}/CURL/bin/curl.exe" -fkSL "${trt_mirror}/${trt_name}" -o "${trt_name}.downloading"
    Move-Item -Force "${trt_name}.downloading" "../${trt_name}"
}

mkdir "${trt_name}.extracting"
Expand-Archive "../${trt_name}" "${trt_name}.extracting"
Move-Item -Force "${trt_name.extracting.d}/TensorRT-*" "tensorrt"
rm -Force -Recursive "${trt_name}.extracting"

rm -Force -Recurse -ErrorAction SilentlyContinue -WarningAction SilentlyContinue "${Env:ProgramFiles}/tensorrt"
Move-Item -Force "tensorrt" "${Env:ProgramFiles}/tensorrt"
Get-ChildItem "${Env:ProgramFiles}/tensorrt" -Filter *.dll -Recurse | Foreach-Object { New-Item -Force -ItemType SymbolicLink -Path "${Env:SystemRoot}\System32\$_" -Value $_.FullName }

popd
rm -Force -Recurse "$root"
popd

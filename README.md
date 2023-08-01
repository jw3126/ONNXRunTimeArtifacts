# ONNXRunTimeArtifacts

This repo provides artifacts needed by [ONNXRunTime.jl](https://github.com/jw3126/ONNXRunTime.jl).
To update the artifacts do:

* Draft a new release of ONNXRunTimeArtifacts and manually add any binaries that need to be repackaged (currently only windows)
* Run the script
* Replace ONNXRunTime.jl/Artifacts.toml by the Artifacts.toml produced by the script

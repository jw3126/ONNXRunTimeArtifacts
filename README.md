# ONNXRunTimeArtifacts

This repo provides artifacts needed by [ONNXRunTime.jl](https://github.com/jw3126/ONNXRunTime.jl).
To update the artifacts do:

* Run the create_tarballs function in script.jl
* Draft a new release of [ONNXRunTimeArtifacts](https://github.com/jw3126/ONNXRunTimeArtifacts) and 
  manually attach the tarballs for that release
* Run the create_artifact_toml function in script.jl
* Replace ONNXRunTime.jl/Artifacts.toml by the Artifacts.toml produced by the script

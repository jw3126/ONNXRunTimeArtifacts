# ONNXRunTimeArtifacts

This repo hosts artifacts needed by [ONNXRunTime.jl](https://github.com/jw3126/ONNXRunTime.jl).

Upstream [onnxruntime](https://github.com/microsoft/onnxruntime/releases) ships
its Windows builds as zip files, but Artifacts.jl only understands tarballs.
So the Windows builds are repacked as tarballs and attached to releases here.
All other platforms are consumed directly from upstream.

There is nothing to do in this repo. It holds no code; the releases are created
automatically by
[`update_artifacts/update_artifacts.jl`](https://github.com/jw3126/ONNXRunTime.jl/blob/main/update_artifacts/update_artifacts.jl)
in ONNXRunTime.jl.

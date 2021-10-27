using Pkg
using ArtifactUtils

version = "1.9.0"
items = [
    (
    artifact_name="onnxruntime_cpu",
    download_name="onnxruntime-linux-x64-$version.tgz",
    platform=Pkg.Artifacts.Platform("x86_64", "linux"),
   ),
    (
    artifact_name="onnxruntime_gpu",
    download_name="onnxruntime-linux-x64-gpu-$version.tgz",
    platform=Pkg.Artifacts.Platform("x86_64", "linux"),
   ),
    (
    artifact_name="onnxruntime_cpu",
    download_name="onnxruntime-osx-x64-$version.tgz",
    platform=Pkg.Artifacts.Platform("x86_64", "macos"),
   ),
    (
    artifact_name="onnxruntime_cpu",
    download_name="onnxruntime-win-x64-$version.zip",
    platform=Pkg.Artifacts.Platform("x86_64", "windows"),
   ),
    (
    artifact_name="onnxruntime_gpu",
    download_name="onnxruntime-win-x64-gpu-$version.zip",
    platform=Pkg.Artifacts.Platform("x86_64", "windows"),
   ),
]

function create_tarballs()
    for item in items
        @info "Create tarball" artifact_name=item.artifact_name download_name=item.download_name
        filename = item.download_name
        url = "https://github.com/microsoft/onnxruntime/releases/download/v$version/$filename"
        if !ispath(filename)
            @info """Downloading
            filename = $filename
            url = $url
            """
            download(url, filename)
        end
        filestem = splitext(filename)[1]
        # Artifacts.jl supports only tar files, so we need to convert zip to tar
        filename_tar = filestem * ".tgz"
        if !ispath(filename_tar)
            @info "Converting $filename to tar"
            if !ispath(filestem)
                @info "Unzipping $filename"
                run(`unzip $filename`)
            end
            # On windows dlopen requires the right permissions for the stuff
            # in the tar file
            # https://github.com/JuliaLang/julia/issues/38993
            run(`chmod -R 777 $filestem`)
            run(`tar czf $filename_tar $filestem`)
        end
    end
end

function create_artifact_toml()
    for item in items
        @info "adding artifact" artifact_name=item.artifact_name download_name=item.download_name
        filestem = splitext(item.download_name)[1]
        filename_tar = filestem * ".tgz"
        prefix = "https://github.com/jw3126/ONNXRunTimeArtifacts/releases/download/v0.1.0"
        artifact_url = "$prefix/$filename_tar"
        add_artifact!(
            "Artifacts.toml",
            item.artifact_name,
            artifact_url,
            force=true,
            platform=item.platform,
            lazy=true,
        )
    end
end

create_tarballs()
#create_artifact_toml()

using Pkg
using ArtifactUtils

version = "1.20.1"
items = [
    (
    artifact_name="onnxruntime_cpu",
    download_name="onnxruntime-win-x64-$version.zip",
    platform=Pkg.Artifacts.Platform("x86_64", "windows"),
    version=version,
   ),
    (
    artifact_name="onnxruntime_gpu",
    download_name="onnxruntime-win-x64-gpu-$version.zip",
    platform=Pkg.Artifacts.Platform("x86_64", "windows"),
    version=version,
   ),
    (
    artifact_name="onnxruntime_cpu",
    download_name="onnxruntime-linux-x64-$version.tgz",
    platform=Pkg.Artifacts.Platform("x86_64", "linux"),
    version=version,
   ),
    (
    artifact_name="onnxruntime_gpu",
    download_name="onnxruntime-linux-x64-gpu-$version.tgz",
    platform=Pkg.Artifacts.Platform("x86_64", "linux"),
    version=version,
   ),
   #  (
   #  artifact_name="onnxruntime_cpu",
   #  download_name="onnxruntime-osx-x86_64-$version.tgz",
   #  platform=Pkg.Artifacts.Platform("x86_64", "macos"),
   #  version=version,
   # ),
   #  (
   #  artifact_name="onnxruntime_cpu",
   #  download_name="onnxruntime-osx-universal2-$version.tgz",
   #  platform=Pkg.Artifacts.Platform("x86_64", "macos"),
   #  version=version,
   (
    artifact_name="onnxruntime_cpu",
    download_name="onnxruntime-osx-universal2-$version.tgz",
    platform=Pkg.Artifacts.Platform("x86_64", "macos"),
    version=version,
   ),
   (
    artifact_name="onnxruntime_cpu",
    download_name="onnxruntime-osx-universal2-$version.tgz",
    platform=Pkg.Artifacts.Platform("aarch64", "macos"),
    version=version,
   ),
]

function get_upstream_url(item)
    "https://github.com/microsoft/onnxruntime/releases/download/v$(item.version)/$(item.download_name)"
end

function iszip(path)
    splitext(path)[2] == ".zip"
end

function get_artifact_url(item)
    if iszip(item.download_name)
        get_repacked_url(item)
    else
        get_upstream_url(item)
    end
end

function get_repacked_url(item)
    filestem = splitext(item.download_name)[1]
    filename_tar = filestem * ".tgz"
    prefix = "https://github.com/jw3126/ONNXRunTimeArtifacts/releases/download/v$(item.version)-rc1"
    "$prefix/$filename_tar"
end

function create_tarballs()
    for item in items
        iszip(item.download_name) || continue
        @info "Create tarball" artifact_name=item.artifact_name download_name=item.download_name
        filename = item.download_name
        url = get_upstream_url(item)
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
            if ispath(filestem)
                rm(filestem, recursive=true)
            end
            @info "Unzipping $filename"
            run(`unzip $filename`)
            fix_permissions(filestem)
            # On windows dlopen requires the right permissions for the stuff
            # in the tar file
            # https://github.com/JuliaLang/julia/issues/38993
            # run(`chmod +x -R $filestem`)
            run(`tar czf $filename_tar $filestem`)
        end
    end
end
function fix_permissions(basedir)
    run(`chmod 777 -R $basedir`)
    #for (root, dirs, filenames) in walkdir(basedir)
    #    for filename in filenames
    #        path = joinpath(root, filename)
    #        if splitext(path)[2] == ".dll"
    #            run(`chmod 755 $path`)
    #        end
    #    end
    #end
end


function create_artifact_toml()
    for item in items
        artifact_url = get_artifact_url(item)
        @info "adding artifact" artifact_name=item.artifact_name download_name=item.download_name artifact_url=artifact_url
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

# create_tarballs()
create_artifact_toml(); cp("Artifacts.toml", joinpath(homedir(), ".julia", "dev", "ONNXRunTime", "Artifacts.toml"), force=true)

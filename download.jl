version = "1.9.0"
filenames = [
    "onnxruntime-linux-x64-$version.tgz",
    "onnxruntime-linux-x64-gpu-$version.tgz",
    "onnxruntime-win-x64-$version.zip",
    "onnxruntime-win-x64-gpu-$version.zip",
    "onnxruntime-osx-x64-$version.tgz",
   ]
for filename in filenames
    url = "https://github.com/microsoft/onnxruntime/releases/download/v$version/$filename"
    if !ispath(filename)
        @info """Downloading
        filename = $filename
        url = $url
        """
        download(url, filename)
    end
    filestem = splitext(filename)[1]
    filename_tar = filestem * ".tgz"
    if !ispath(filename_tar)
        @info "Converting $filename to tar"
        if !ispath(filestem)
            @info "Unzipping $filename"
            run(`unzip $filename`)
        end
        run(`tar czf $filename_tar $filestem`)
    end
end

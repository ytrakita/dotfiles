# https://myenigma.hatenablog.com/entry/2020/08/14/142916
# https://myenigma.hatenablog.com/entry/2018/08/11/134708

import Pkg
let
    pkgs = ["Revise", "OhMyREPL"]
    for pkg in pkgs
        if Base.find_package(pkg) === nothing
            Pkg.add(pkg)
        end
    end
end

using OhMyREPL
using Revise

function includetr(filename)
    already_included = copy(Revise.included_files)
    includet(filename)
    newly_included = setdiff(Revise.included_files, already_included)
    for (mod, file) in newly_included
        Revise.track(mod, file)
    end
end

function create_startup_sysimage()
    @eval using PackageCompiler

    dir = ENV["JULIA_DEPOT_PATH"] * "/sysimages"
    mkpath(dir)
    cd(dir)

    pkgs = ["OhMyREPL", "Revise", "Plots"]

    create_sysimage(pkgs; sysimage_path="startup.so")
end

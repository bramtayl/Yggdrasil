# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "alsa"
version = v"1.2.4"

# Collection of sources required to complete build
sources = [
    ArchiveSource("https://www.alsa-project.org/files/pub/lib/alsa-lib-$version.tar.bz2",
                  "f7554be1a56cdff468b58fc1c29b95b64864c590038dd309c7a978c7116908f7"),
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/alsa-lib*/
./configure --prefix=${prefix} --build=${MACHTYPE} --host=${target}
make
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = filter(Sys.islinux, supported_platforms())

# The products that we will ensure are always built
products = [
    LibraryProduct("libasound", :libasound),
    LibraryProduct("libatopology", :libatopology),
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)


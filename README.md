# docker-vs2019
Docker config for a vs2019 build container

# What?

Sets up a docker image with all the vs2019 build tools you should need to
build desktop and web apps (including more esoteric targetslike net35-client)

To use the helpful build-with-docker-for-windows.bat included in this repo,
you should set up a build chain using npm. [zarro](https://npmjs.com/package/zarro)
is particularly convenient for doing so:

```
npm init -y
npm install --save-dev zarro cross-env npm-run-all
```

Then edit your scripts section, eg:
```
"scripts": {
    "zarro": "cross-env DOTNET_CORE=1 BUILD_CONFIGURATION=Release zarro",
    "build": "run-s \"zarro build\"",
    "test": "run-s \"zarro test-dotnet\""
}
```

The above is an example, specifically building targeting the dotnet core
build chain in release mode, as an example of guidance to zarro. The default
build config would build with msbuild, for the Debug configuration, which is
quite likely what you actually want, eg:

```
"scripts": {
    "zarro": "zarro",
    "build": "run-s \"zarro build\"",
    "test": "run-s \"zarro test-dotnet\""
}
```
# It's a windows docker image?
Yes -- easiest way to build almost anything you can want. Building, eg client-profile
targets has proven elusive to me.

# Why?
Sometimes you just want to build without having to maintain build dependencies.
This is pretty-much the point of docker-ing anything: let the deps get handled
elsewhere. I hobbled this together whilst working on build updates for log4net.

# Why not?
If you can target dotnet core and / or .net 4.6.2 or higher, it's probably better
to build on a linux host with `dotnet` using `mono` for reference assemblies.

If you already have a windows machine and don't mind installing docker to run
windows images, then this might prove convenient.

[![Build Status](https://travis-ci.org/Kode/Kore.svg?branch=master)](https://travis-ci.org/Kode/Kore) [![Build status](https://ci.appveyor.com/api/projects/status/y3yxe87qj32wqcou/branch/master?svg=true)](https://ci.appveyor.com/project/RobDangerous/kore)

Kore projects are built using koremake, a nodejs tool.
In your project's directory call node Kore/make - this will
create a project file for your IDE in a build subdirectory.
koremake by default creates a project for the system you are currently using,
but you can also put one of windows, linux, android, windows8, osx and ios
in the arguments list to create something else. In Windows you can also
choose your graphics api (gfx=direct3d9, gfx=direct3d11 or gfx=opengl2)
and your Visual Studio version (vs=vs2010, vs=vs2012 or vs=vs2013).

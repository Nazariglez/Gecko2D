# Gecko2D

> A Cross-platform Game Framework

Gecko2D is a flexible and powerful cross-platform game framework that will allow you to create games easily and deploy it
to browsers, mobile devices, desktop, and even consoles.

Under the hood, Gecko2D it's an [Entity-Component-System](https://en.wikipedia.org/wiki/Entity%E2%80%93component%E2%80%93system) framework built on top of [Haxe](http://haxe.org) and [Kha](http://kha.tech) which allow the best performance and real cross-platform
compilation, using Javascript and WebGL when compile to browsers, and C++ when compile to mobile using metal or opengl, to desktop using opengl, directx or vulkan, and consoles with their own drivers.

This framework aims to be a solid foundation for all your games, allowing you to port your games to others platforms using the same source code, saving time and money.

## Dependencies
- Git 
- Node.js >= 9

## How to install
Use git to clone the repository:
```
git clone --recursive git@github.com:Nazariglez/Gecko2D.git
```

And node.js to install it:
```
cd Gecko2D && npm install -g
```

## Getting started
Gecko2D has a command line interface to make your life easy.
A new project with a basic structure can be created, compiled to html5 and served with `gecko init watch`.

Main commands are `init`, `build` and `watch`:
- Use `gecko init` to create a new project in the current folder.
- Use `gecko build <platform>` to build your project.
- Use `gecko watch` to watch changes in your code or assets.
- Use `gecko help` for more info. 

## The config file
Each project has a file named `dev.gecko.toml` which has many parameters to configure your project... (todo)

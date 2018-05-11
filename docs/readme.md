---
home: true
actionText: Getting Started
actionLink: /getting-started/
features:
- title: Open Source
  details: Gecko has no black boxes, the source code is available for everyone in github, to be revised, fixed, improved, or whatever you want.
- title: Native Performance
  details: Export your game to Javascript, C++ and C using OpenGL, DirectX, Metal, etc... This allow run your game at maximun speed.
- title: Crossplatform
  details: Your game will be multiplatform by default, browser, desktop, mobile and consoles are supported. Also Gecko2D provide some utils to work with differentes screen resolutions.
footer: MIT Licensed | Copyright © 2018-present Nazarí González
---

Gecko2D is a flexible and powerful cross-platform game framework that will allow you to create games easily and deploy it
to browsers, mobile devices, desktop, and even consoles.

Under the hood, Gecko2D is an [Entity-Component-System](https://en.wikipedia.org/wiki/Entity%E2%80%93component%E2%80%93system) framework built on top of [Haxe](http://haxe.org) and [Kha](http://kha.tech) which allow the best performance and real cross-platform
compilation, using Javascript and WebGL when compile to browsers, and C++ when compile to mobile using metal or opengl, to desktop using opengl, directx or vulkan, and consoles with their own drivers.

This framework aims to be a solid foundation for all your games, allowing you to port your games to others platforms using the same source code, saving time and money.

# Quick start
Install it via __npm__
```
npm install gecko2d -g
```
And create a new project with `gecko init` in a empty folder. Use `gecko watch` to serve your game at [http://localhost:8080](http://localhost:8080) and recompile when change. 

Easy right?

# Contributing
Contributions are welcome! Feel free to fix, improve or test features you want. Just try to coordinate with the community before work on anything to avoid duplicate or not wanted features.

::: warning Gecko2D it's under development.
Some issues may occur until we reach a major version.
::: 
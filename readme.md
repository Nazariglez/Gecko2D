Gecko2D - Multiplatform Game Framework
==========

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

## IMPORTANT Experimental branch
Under heavy development to move from Object Orient Design to Entity-Component-System, to init a new project
use `gecko init -t ecs` and `gecko watch`.

## Getting started
Gecko2D has a command line interface to make your life easy.

Main commands are `init`, `build` and `watch`:
- Use `gecko init` to create a new project in the current folder.
- Use `gecko build <platform>` to build your project.
- Use `gecko watch` to watch changes in your code or assets.
- Use `gecko help` for more info. 

## The config file
Each project has a file named `dev.gecko.toml` which has many parameters to configure your project... (todo)

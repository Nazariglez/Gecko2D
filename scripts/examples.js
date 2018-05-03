'use strict';

const yaml = require("js-yaml");
const fs = require("fs-extra");
const path = require("path");
const _async = require("async");
const spawn = require("cross-spawn");
const execSync = require("child_process").execSync;

let baseDir = (process.env.baseDir === false || process.env.baseDir === 'false') ? "" : '/Gecko2D/'; 
let canBuild = process.argv.length >= 3 && process.argv[2] === "--build";

const examplesDir = path.resolve(__dirname, "../examples");

let examplesToCheck = fs.readdirSync(examplesDir);
let examples = [];
for(let i = 0; i < examplesToCheck.length; i++){
    let example = examplesToCheck[i];
    var dir = path.join(examplesDir, example);
    var stat = fs.statSync(dir);
    if(!stat.isDirectory())continue;

    var files = fs.readdirSync(dir);
    if(!files.length)continue;

    var valid = false;
    var data = {};
    var text = "";
    var code = "";

    files.forEach(function(file){
        let f = file.toLocaleLowerCase();
        if(f === "readme.md"){
            let readme = fs.readFileSync(path.join(dir, f), 'utf8').trim();
            if(readme.indexOf("---") !== 0)return;

            let readmeSections = readme.split("---");
            if(readmeSections.length < 3)return;

            try {
                var _data = yaml.safeLoad(readmeSections[1]);
                if(_data.example === true){
                    valid = true;
                    data = _data;
                    text = readmeSections[2];
                    code = fs.readFileSync(path.join(dir, "Sources/Game.hx"));
                    return;
                }
            } catch (e) {
                console.error(e);
                return;
            }
        }
    });

    if(valid){
        examples.push({
            name: example,
            dir: dir,
            data: data,
            text: text,
            code: code
        });
    }
}

_async.eachSeries(examples, function(example, next){
    let errMsg = null;

    let fn = function(){
        if(errMsg){
            return next(errMsg);
        }

        if(canBuild){

            let buildDir = path.resolve(__dirname, "../docs/.vuepress/dist/builds", example.name);
            try {
                fs.copySync(path.join(example.dir, "build/html5-build"), buildDir);
            }catch(e){
                return next(e);
            }

        }else{

            var readmeContent = `---
title: ${example.data.title || example.name}
---
# ${example.data.title || example.name}

<iframe src="${baseDir}/builds/${example.name}/index.html" width="800" height="600" frameBorder="0" style="width: 100vw; height:75vw; max-width:100%; max-height:600px"></iframe>
`;

            if(example.data.source !== false){
                readmeContent += `
\`\`\`haxe
${example.code}
\`\`\`
`;
            }

            readmeContent += `${example.text.trim()}

[Source Code](https://github.com/Nazariglez/Gecko2D/tree/master/examples/${example.name})
`;

            try {
                fs.writeFileSync(path.resolve(__dirname, "../docs/examples", example.name + ".md"), readmeContent, 'utf8');
            }catch(e){
                return next(e);
            }

        }

        next();
    };

    if(canBuild){
        console.log("Compiling example:", example.name);
    
        let child = spawn("node", [path.resolve(__dirname, "../main.js"), "build","html5"], {cwd: example.dir});
        child.stderr.on("data", d => console.log(d.toString()));
        //child.stdout.on("data", d => console.log(d.toString()));
        
        child.on("error", function(err){
            errMsg = err;
        });
    
        child.on("close", fn);
    }else{
        console.log("Generating example docs:", example.name);
        fn();
    }
    

}, function(err){
    if(err){
        throw new Error(err);
    }

    let examplesPriorities = {};
    let categories = {};

    examples.forEach(example => {
        let category = example.data.category || "Uncategorized";
        if(!categories[category]){
            categories[category] = {
                title: category,
                collapsable: true,
                children: []
            };
        }

        categories[category].children.push(example.name);

        examplesPriorities[example.name] = example.data.priority;
    });

    let sidebar = [""];
    let keys = Object.keys(categories);
    for(let i = 0; i < keys.length; i++){
        let data = categories[keys[i]];
        data.children.sort( (a,b)=> examplesPriorities[a] - examplesPriorities[b] );
        sidebar.push(data);
    }

    fs.writeFileSync(path.resolve(__dirname, "../docs/.vuepress/examples.json"), JSON.stringify(sidebar, null, 2), 'utf8');
});
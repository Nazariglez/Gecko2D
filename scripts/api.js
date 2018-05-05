'use strict';

const spawn = require("cross-spawn");
const fs = require("fs-extra");
const path = require("path");

console.log("Generating API docs...");

let build = spawn.sync("gecko", ["build", "html5"], {cwd: path.resolve(__dirname, "../build_templates/docs")});
if(build.error){
    console.error(build.stderr);
    throw build.error;
}

let haxeXml = spawn.sync("haxe", ["project-html5.hxml","-xml", "docs/docs.xml", "-D", "doc-gen"], {cwd: path.resolve(__dirname, "../build_templates/docs/build")});
if(haxeXml.error){
    console.error(haxeXml.stderr);
    throw haxeXml.error;
}

let sourceDir = path.resolve(__dirname, "../", "Sources").split("/").join("\/");
var regex = new RegExp(`<${sourceDir}[.\\s\\S]*<\/${sourceDir}>`);

let xmlText = fs.readFileSync(path.resolve(__dirname, "../build_templates/docs/build/docs/docs.xml"), 'utf8');
xmlText = xmlText.replace(regex, "");

fs.writeFileSync(path.resolve(__dirname, "../build_templates/docs/build/docs/docs.xml"), xmlText, 'utf8');

let dox = spawn.sync("haxelib", ["run","dox", "-i", "docs"], {cwd: path.resolve(__dirname, "../build_templates/docs/build")});
if(dox.error){
    console.error(dox.stderr);
    throw dox.error;
}
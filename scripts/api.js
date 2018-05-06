'use strict';

const spawn = require("cross-spawn");
const fs = require("fs-extra");
const path = require("path");
const replace = require("replace");

console.log("Generating API docs...");

let sourceDir = path.resolve(__dirname, "../", "Sources").split("/").join("\/");
var regex = new RegExp(`<${sourceDir}[.\\s\\S]*<\/${sourceDir}>`);

let build = spawn.sync("gecko", ["build", "html5"], {cwd: path.resolve(__dirname, "../build_templates/docs")});
if(build.error){
    console.error(build.stderr);
    throw build.error;
}

let xmlText = fs.readFileSync(path.resolve(__dirname, "../build_templates/docs/build/docs/gecko.xml"), 'utf8');
xmlText = xmlText.replace(regex, "");

fs.writeFileSync(path.resolve(__dirname, "../build_templates/docs/build/docs/gecko.xml"), xmlText, 'utf8');

let dox = spawn.sync("haxelib", ["run","dox", "-i", "docs"], {cwd: path.resolve(__dirname, "../build_templates/docs/build")});
if(dox.error){
    console.error(dox.stderr);
    throw dox.error;
}

replace({
  regex: "http:",
  replacement: "https:",
  paths: [path.resolve(__dirname, "../build_templates/docs/build/pages")],
  recursive: true,
  silent: true,
  async: false
});
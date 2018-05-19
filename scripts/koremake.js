'use strict';

const path = require("path");
const dir = path.resolve(__dirname, "../Kha/Kore/Tools/koremake");
const spawn = require("cross-spawn");

var env = {};
for(var k in process.env){
    if(process.env.hasOwnProperty(k) && k.indexOf("npm") === -1){
        env[k] = process.env[k];
    }
}

const child = spawn("npm", ["install"], {cwd: dir, env:env});
child.stderr.on("data", d => console.log(d.toString()));
child.stdout.on("data", d => console.log(d.toString()));
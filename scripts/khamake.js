'use strict';

const path = require("path");
const dir = path.resolve(__dirname, "../Kha/Tools/khamake");
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

/*
const commitHash = require('child_process')
  .execSync('git rev-parse HEAD', {cwd: dir})
  .toString().trim();

const pkgPath = path.resolve(process.cwd(), "package.json");
let pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf8'));
pkg.dependencies["khamake"] = "github:kode/khamake#" + commitHash;

fs.writeFileSync(pkgPath, JSON.stringify(pkg, null, 2), "utf8");
*/


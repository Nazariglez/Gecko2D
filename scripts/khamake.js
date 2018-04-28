'use strict';

const fs = require("fs");
const path = require("path");
const dir = path.resolve(__dirname, "../Kha/Tools/khamake");

const commitHash = require('child_process')
  .execSync('git rev-parse HEAD', {cwd: dir})
  .toString().trim();

const pkgPath = path.resolve(process.cwd(), "package.json");
let pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf8'));
pkg.dependencies["khamake"] = "github:kode/khamake#" + commitHash;

fs.writeFileSync(pkgPath, JSON.stringify(pkg, null, 2), "utf8");

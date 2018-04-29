const fs = require("fs");
const path = require("path");

const pkgPath = path.resolve(process.cwd(), "package.json");
let pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf8'));
pkg.dependencies["khamake"] = "file:Kha/Tools/khamake";

fs.writeFileSync(pkgPath, JSON.stringify(pkg, null, 2), "utf8");
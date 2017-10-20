"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const fs = require("fs");
const path = require("path");
function run(name, from, projectfile) {
    if (!fs.existsSync(path.join(from, projectfile))) {
        fs.writeFileSync(path.join(from, projectfile), 'let project = new Project(\'New Project\', __dirname);\n'
            + '\n'
            + 'project.addFile(\'Sources/**\');\n'
            + 'project.setDebugDir(\'Deployment\');\n'
            + '\n'
            + 'Project.createProject(\'Kore\', __dirname).then((subproject) => {\n'
            + '\tproject.addSubProject(subproject);\n'
            + '\tresolve(project);\n'
            + '});\n', { encoding: 'utf8' });
    }
    if (!fs.existsSync(path.join(from, 'Sources')))
        fs.mkdirSync(path.join(from, 'Sources'));
    let friendlyName = name;
    friendlyName = friendlyName.replace(/ /g, '_');
    friendlyName = friendlyName.replace(/-/g, '_');
    if (!fs.existsSync(path.join(from, 'Sources', 'main.cpp'))) {
        let mainsource = '#include <Kore/pch.h>\n\n'
            + '\n'
            + 'int kore(int argc, char** argv) {\n'
            + '\treturn 0;\n'
            + '}\n';
        fs.writeFileSync(path.join(from, 'Sources', 'main.cpp'), mainsource, { encoding: 'utf8' });
    }
}
exports.run = run;
//# sourceMappingURL=init.js.map
import {Command, ActionCallback} from '../cli';
import {ENGINE_NAME, DOCS_PATH} from '../const';
import * as http from 'http';
import * as colors from 'colors';
import * as nodeStatic from 'node-static';

const PORT = 8081;

export const cmd:Command = {
    name: "docs",
    alias: [],
    usage: `serve the ${ENGINE_NAME} documentation at ${PORT}`,
    action: _action
};

function _action(args:string[], cb:ActionCallback) {
    console.log(colors.yellow(`Serving documentation on '${colors.magenta(PORT.toString())}'`))

    const serv = new nodeStatic.Server(DOCS_PATH + "/.vuepress/dist", {cache: 0});
    const htmlServer = http.createServer((req, res)=>{
        req.addListener("end", ()=>serv.serve(req, res)).resume();
    });

    htmlServer.on("error", (e:any)=>{
        if(e.code === "EADDRINUSE") {
            cb(new Error(`Error: Port ${PORT} is already in use.`));
            return;
        } else {
            cb(e);
            return;
        }
    });

    htmlServer.listen(PORT);
    cb(null, args);
}
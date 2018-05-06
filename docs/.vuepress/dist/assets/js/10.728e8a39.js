(window.webpackJsonp=window.webpackJsonp||[]).push([[10],{52:function(t,s,n){"use strict";n.r(s);var a=n(0),e=Object(a.a)({},function(){var t=this.$createElement,s=this._self._c||t;return s("div",{staticClass:"content"},[this._m(0),s("iframe",{staticStyle:{width:"100vw",height:"75vw","max-width":"100%","max-height":"600px"},attrs:{src:this.$withBase("/builds/nineslice/index.html"),width:"800",height:"600",frameBorder:"0"}}),this._m(1),this._m(2)])},[function(){var t=this.$createElement,s=this._self._c||t;return s("h1",{attrs:{id:"nine-slice"}},[s("a",{staticClass:"header-anchor",attrs:{href:"#nine-slice","aria-hidden":"true"}},[this._v("#")]),this._v(" Nine Slice")])},function(){var t=this,s=t.$createElement,n=t._self._c||s;return n("pre",{pre:!0,attrs:{class:"language-haxe"}},[n("code",[t._v("package"),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n"),n("span",{attrs:{class:"token keyword"}},[t._v("import")]),t._v(" gecko"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("Assets"),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n"),n("span",{attrs:{class:"token keyword"}},[t._v("import")]),t._v(" gecko"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("Gecko"),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n"),n("span",{attrs:{class:"token keyword"}},[t._v("import")]),t._v(" gecko"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("math"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("Random"),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n"),n("span",{attrs:{class:"token keyword"}},[t._v("import")]),t._v(" gecko"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("systems"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("draw"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("DrawSystem"),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n"),n("span",{attrs:{class:"token keyword"}},[t._v("import")]),t._v(" gecko"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("components"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("draw"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("NineSliceComponent"),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n"),n("span",{attrs:{class:"token keyword"}},[t._v("class")]),t._v(" Game "),n("span",{attrs:{class:"token punctuation"}},[t._v("{")]),t._v("\n    "),n("span",{attrs:{class:"token keyword"}},[t._v("var")]),t._v(" _spritesToLoad "),n("span",{attrs:{class:"token operator"}},[t._v("=")]),t._v(" "),n("span",{attrs:{class:"token punctuation"}},[t._v("[")]),n("span",{attrs:{class:"token string"}},[t._v('"images/kenney/grey_button08.png"')]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token string"}},[t._v('"images/kenney/green_panel.png"')]),n("span",{attrs:{class:"token punctuation"}},[t._v("]")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n    "),n("span",{attrs:{class:"token keyword"}},[t._v("public")]),t._v(" "),n("span",{attrs:{class:"token keyword"}},[t._v("function")]),t._v(" "),n("span",{attrs:{class:"token keyword"}},[t._v("new")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v("{")]),t._v("\n        "),n("span",{attrs:{class:"token comment"}},[t._v("//add the draw system to the current scene")]),t._v("\n        Gecko"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("currentScene"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),n("span",{attrs:{class:"token function"}},[t._v("addSystem")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("DrawSystem"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),n("span",{attrs:{class:"token function"}},[t._v("create")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),n("span",{attrs:{class:"token comment"}},[t._v("//load the assets")]),t._v("\n        Assets"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),n("span",{attrs:{class:"token function"}},[t._v("load")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("_spritesToLoad"),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" _onLoadAssets"),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),n("span",{attrs:{class:"token function"}},[t._v("start")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n    "),n("span",{attrs:{class:"token punctuation"}},[t._v("}")]),t._v("\n\n    "),n("span",{attrs:{class:"token comment"}},[t._v("//create nine-slice sprites using positon and size")]),t._v("\n    "),n("span",{attrs:{class:"token keyword"}},[t._v("private")]),t._v(" "),n("span",{attrs:{class:"token keyword"}},[t._v("function")]),t._v(" "),n("span",{attrs:{class:"token function"}},[t._v("_createNineSlice")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("x"),n("span",{attrs:{class:"token punctuation"}},[t._v(":")]),t._v("Float"),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" y"),n("span",{attrs:{class:"token punctuation"}},[t._v(":")]),t._v("Float"),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" width"),n("span",{attrs:{class:"token punctuation"}},[t._v(":")]),t._v("Float"),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" height"),n("span",{attrs:{class:"token punctuation"}},[t._v(":")]),t._v("Float"),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),t._v(" "),n("span",{attrs:{class:"token punctuation"}},[t._v("{")]),t._v("\n        "),n("span",{attrs:{class:"token comment"}},[t._v("//create an entity in the current scene")]),t._v("\n        "),n("span",{attrs:{class:"token keyword"}},[t._v("var")]),t._v(" entity "),n("span",{attrs:{class:"token operator"}},[t._v("=")]),t._v(" Gecko"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("currentScene"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),n("span",{attrs:{class:"token function"}},[t._v("createEntity")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),n("span",{attrs:{class:"token comment"}},[t._v("//set his position in the screen")]),t._v("\n        entity"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("transform"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("position"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),n("span",{attrs:{class:"token function"}},[t._v("set")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("x"),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" y"),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),n("span",{attrs:{class:"token comment"}},[t._v("//add the nine-slice component using a random spritename and a size")]),t._v("\n        entity"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),n("span",{attrs:{class:"token function"}},[t._v("addComponent")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("NineSliceComponent"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),n("span",{attrs:{class:"token function"}},[t._v("create")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token function"}},[t._v("_getRandomSprite")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" width"),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" height"),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),n("span",{attrs:{class:"token comment"}},[t._v("//e.renderer.color = _getRandomColor();")]),t._v("\n        entity"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("transform"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("anchor"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),n("span",{attrs:{class:"token function"}},[t._v("set")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token number"}},[t._v("0")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),n("span",{attrs:{class:"token number"}},[t._v("0")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n    "),n("span",{attrs:{class:"token punctuation"}},[t._v("}")]),t._v("\n\n    "),n("span",{attrs:{class:"token keyword"}},[t._v("private")]),t._v(" "),n("span",{attrs:{class:"token keyword"}},[t._v("function")]),t._v(" "),n("span",{attrs:{class:"token function"}},[t._v("_onLoadAssets")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),t._v(" "),n("span",{attrs:{class:"token punctuation"}},[t._v("{")]),t._v("\n        "),n("span",{attrs:{class:"token comment"}},[t._v("//add a lot of nine-slice components in the screen")]),t._v("\n        "),n("span",{attrs:{class:"token function"}},[t._v("_createNineSlice")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token number"}},[t._v("50")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("50")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("200")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("100")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n        "),n("span",{attrs:{class:"token function"}},[t._v("_createNineSlice")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token number"}},[t._v("50")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("170")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("100")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("400")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n        "),n("span",{attrs:{class:"token function"}},[t._v("_createNineSlice")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token number"}},[t._v("170")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("170")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("400")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("400")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n        "),n("span",{attrs:{class:"token function"}},[t._v("_createNineSlice")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token number"}},[t._v("270")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("50")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("60")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("100")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n        "),n("span",{attrs:{class:"token function"}},[t._v("_createNineSlice")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token number"}},[t._v("350")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("50")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("40")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("40")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n        "),n("span",{attrs:{class:"token function"}},[t._v("_createNineSlice")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token number"}},[t._v("350")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("110")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("40")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("40")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n        "),n("span",{attrs:{class:"token function"}},[t._v("_createNineSlice")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token number"}},[t._v("410")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("50")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("120")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("100")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n        "),n("span",{attrs:{class:"token function"}},[t._v("_createNineSlice")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token number"}},[t._v("550")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("50")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("200")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("40")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n        "),n("span",{attrs:{class:"token function"}},[t._v("_createNineSlice")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token number"}},[t._v("550")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("110")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("200")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("40")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n        "),n("span",{attrs:{class:"token function"}},[t._v("_createNineSlice")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token number"}},[t._v("590")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("170")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("160")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("80")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n        "),n("span",{attrs:{class:"token function"}},[t._v("_createNineSlice")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token number"}},[t._v("590")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("270")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("60")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("300")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n        "),n("span",{attrs:{class:"token function"}},[t._v("_createNineSlice")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token number"}},[t._v("670")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("270")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("80")]),n("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),n("span",{attrs:{class:"token number"}},[t._v("300")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n    "),n("span",{attrs:{class:"token punctuation"}},[t._v("}")]),t._v("\n\n    "),n("span",{attrs:{class:"token comment"}},[t._v("//return a random spritename")]),t._v("\n    "),n("span",{attrs:{class:"token keyword"}},[t._v("private")]),t._v(" "),n("span",{attrs:{class:"token keyword"}},[t._v("function")]),t._v(" "),n("span",{attrs:{class:"token function"}},[t._v("_getRandomSprite")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),t._v(" "),n("span",{attrs:{class:"token punctuation"}},[t._v(":")]),t._v(" String "),n("span",{attrs:{class:"token punctuation"}},[t._v("{")]),t._v("\n        "),n("span",{attrs:{class:"token keyword"}},[t._v("return")]),t._v(" _spritesToLoad"),n("span",{attrs:{class:"token punctuation"}},[t._v("[")]),t._v("Random"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),n("span",{attrs:{class:"token function"}},[t._v("getUpTo")]),n("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("_spritesToLoad"),n("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("length"),n("span",{attrs:{class:"token operator"}},[t._v("-")]),n("span",{attrs:{class:"token number"}},[t._v("1")]),n("span",{attrs:{class:"token punctuation"}},[t._v(")")]),n("span",{attrs:{class:"token punctuation"}},[t._v("]")]),n("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n    "),n("span",{attrs:{class:"token punctuation"}},[t._v("}")]),t._v("\n"),n("span",{attrs:{class:"token punctuation"}},[t._v("}")]),t._v("\n")])])},function(){var t=this.$createElement,s=this._self._c||t;return s("p",[s("a",{attrs:{href:"https://github.com/Nazariglez/Gecko2D/tree/master/examples/nineslice",target:"_blank",rel:"noopener noreferrer"}},[this._v("Source Code")])])}],!1,null,null,null);s.default=e.exports}}]);
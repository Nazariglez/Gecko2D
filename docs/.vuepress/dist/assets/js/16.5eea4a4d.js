(window.webpackJsonp=window.webpackJsonp||[]).push([[16],{62:function(t,n,s){"use strict";s.r(n);var a=s(0),o=Object(a.a)({},function(){var t=this.$createElement,n=this._self._c||t;return n("div",{staticClass:"content"},[this._m(0),n("iframe",{staticStyle:{width:"100vw",height:"75vw","max-width":"100%","max-height":"600px"},attrs:{src:this.$withBase("/builds/animation/index.html"),width:"800",height:"600",frameBorder:"0"}}),this._m(1),this._m(2)])},[function(){var t=this.$createElement,n=this._self._c||t;return n("h1",{attrs:{id:"animation"}},[n("a",{staticClass:"header-anchor",attrs:{href:"#animation","aria-hidden":"true"}},[this._v("#")]),this._v(" Animation")])},function(){var t=this,n=t.$createElement,s=t._self._c||n;return s("pre",{pre:!0,attrs:{class:"language-haxe"}},[s("code",[t._v("package"),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n"),s("span",{attrs:{class:"token keyword"}},[t._v("import")]),t._v(" gecko"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("Screen"),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n"),s("span",{attrs:{class:"token keyword"}},[t._v("import")]),t._v(" gecko"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("Float32"),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n"),s("span",{attrs:{class:"token keyword"}},[t._v("import")]),t._v(" gecko"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("Assets"),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n"),s("span",{attrs:{class:"token keyword"}},[t._v("import")]),t._v(" gecko"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("Gecko"),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n"),s("span",{attrs:{class:"token keyword"}},[t._v("import")]),t._v(" gecko"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("systems"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("draw"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("DrawSystem"),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n"),s("span",{attrs:{class:"token keyword"}},[t._v("import")]),t._v(" gecko"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("components"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("draw"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("TextComponent"),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n"),s("span",{attrs:{class:"token keyword"}},[t._v("import")]),t._v(" gecko"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("components"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("draw"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("AnimationComponent"),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n"),s("span",{attrs:{class:"token keyword"}},[t._v("import")]),t._v(" gecko"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("input"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("KeyCode"),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n"),s("span",{attrs:{class:"token keyword"}},[t._v("import")]),t._v(" gecko"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("input"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("Keyboard"),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n"),s("span",{attrs:{class:"token keyword"}},[t._v("class")]),t._v(" Game "),s("span",{attrs:{class:"token punctuation"}},[t._v("{")]),t._v("\n    "),s("span",{attrs:{class:"token keyword"}},[t._v("public")]),t._v(" "),s("span",{attrs:{class:"token keyword"}},[t._v("function")]),t._v(" "),s("span",{attrs:{class:"token keyword"}},[t._v("new")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v("{")]),t._v("\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//add the draw system")]),t._v("\n        Gecko"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("currentScene"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("addSystem")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("DrawSystem"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("create")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//Load the sprites")]),t._v("\n        Assets"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("load")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token punctuation"}},[t._v("[")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/pixelExplosion00.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/pixelExplosion01.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/pixelExplosion02.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/pixelExplosion03.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/pixelExplosion04.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/pixelExplosion05.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/pixelExplosion06.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/pixelExplosion07.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/pixelExplosion08.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/wingMan1.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/wingMan2.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/wingMan3.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/wingMan4.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/wingMan5.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/wingMan4.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/wingMan3.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/wingMan2.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/opengameart/golem-walk.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/opengameart/golem-atk.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/opengameart/golem-die.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n\n            "),s("span",{attrs:{class:"token string"}},[t._v('"Ubuntu-B.ttf"')]),t._v("\n\n        "),s("span",{attrs:{class:"token punctuation"}},[t._v("]")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" _onLoadAssets"),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("start")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n    "),s("span",{attrs:{class:"token punctuation"}},[t._v("}")]),t._v("\n\n    "),s("span",{attrs:{class:"token keyword"}},[t._v("private")]),t._v(" "),s("span",{attrs:{class:"token keyword"}},[t._v("function")]),t._v(" "),s("span",{attrs:{class:"token function"}},[t._v("_createAnimatedEntity")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("x"),s("span",{attrs:{class:"token punctuation"}},[t._v(":")]),t._v("Float32"),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" y"),s("span",{attrs:{class:"token punctuation"}},[t._v(":")]),t._v("Float32"),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" sx"),s("span",{attrs:{class:"token punctuation"}},[t._v(":")]),t._v("Float32 "),s("span",{attrs:{class:"token operator"}},[t._v("=")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("1")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" sy"),s("span",{attrs:{class:"token punctuation"}},[t._v(":")]),t._v("Float32 "),s("span",{attrs:{class:"token operator"}},[t._v("=")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("1")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),t._v(" "),s("span",{attrs:{class:"token punctuation"}},[t._v(":")]),t._v(" AnimationComponent "),s("span",{attrs:{class:"token punctuation"}},[t._v("{")]),t._v("\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//create a new entity in the current scene")]),t._v("\n        "),s("span",{attrs:{class:"token keyword"}},[t._v("var")]),t._v(" entity "),s("span",{attrs:{class:"token operator"}},[t._v("=")]),t._v(" Gecko"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("currentScene"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("createEntity")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//set the entity position in the screen")]),t._v("\n        entity"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("transform"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("position"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("set")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("x"),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" y"),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//set the entity's scale")]),t._v("\n        entity"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("transform"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("scale"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("set")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("sx"),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" sy"),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//create and return the animationComponent")]),t._v("\n        "),s("span",{attrs:{class:"token keyword"}},[t._v("return")]),t._v(" entity"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("addComponent")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("AnimationComponent"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("create")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n    "),s("span",{attrs:{class:"token punctuation"}},[t._v("}")]),t._v("\n\n    "),s("span",{attrs:{class:"token keyword"}},[t._v("private")]),t._v(" "),s("span",{attrs:{class:"token keyword"}},[t._v("function")]),t._v(" "),s("span",{attrs:{class:"token function"}},[t._v("_onLoadAssets")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),t._v(" "),s("span",{attrs:{class:"token punctuation"}},[t._v("{")]),t._v("\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//animation from assets name")]),t._v("\n        "),s("span",{attrs:{class:"token keyword"}},[t._v("var")]),t._v(" anim1Frames "),s("span",{attrs:{class:"token operator"}},[t._v("=")]),t._v(" "),s("span",{attrs:{class:"token punctuation"}},[t._v("[")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/pixelExplosion00.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/pixelExplosion01.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/pixelExplosion02.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/pixelExplosion03.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/pixelExplosion04.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/pixelExplosion05.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/pixelExplosion06.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/pixelExplosion07.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/pixelExplosion08.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n        "),s("span",{attrs:{class:"token punctuation"}},[t._v("]")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//create the entity and get the animationComponent")]),t._v("\n        "),s("span",{attrs:{class:"token keyword"}},[t._v("var")]),t._v(" animComponent1 "),s("span",{attrs:{class:"token operator"}},[t._v("=")]),s("span",{attrs:{class:"token function"}},[t._v("_createAnimatedEntity")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("Screen"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("width"),s("span",{attrs:{class:"token operator"}},[t._v("/")]),s("span",{attrs:{class:"token number"}},[t._v("4")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("150")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),s("span",{attrs:{class:"token comment"}},[t._v('//add a new animation named "explosion" from frame names')]),t._v("\n        animComponent1"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("addAnimFromAssets")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token string"}},[t._v('"explosion"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("0.9")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" anim1Frames"),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//play the animation explision in a loop")]),t._v("\n        animComponent1"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("play")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token string"}},[t._v('"explosion"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token boolean"}},[t._v("true")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//animation 2 from assets name")]),t._v("\n        "),s("span",{attrs:{class:"token keyword"}},[t._v("var")]),t._v(" anim2Frames "),s("span",{attrs:{class:"token operator"}},[t._v("=")]),t._v(" "),s("span",{attrs:{class:"token punctuation"}},[t._v("[")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/wingMan1.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/wingMan2.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/wingMan3.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/wingMan4.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/wingMan5.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/wingMan4.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/wingMan3.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n            "),s("span",{attrs:{class:"token string"}},[t._v('"images/kenney/wingMan2.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v("\n        "),s("span",{attrs:{class:"token punctuation"}},[t._v("]")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//create the entity and get the animationComponent")]),t._v("\n        "),s("span",{attrs:{class:"token keyword"}},[t._v("var")]),t._v(" animComponent2 "),s("span",{attrs:{class:"token operator"}},[t._v("=")]),s("span",{attrs:{class:"token function"}},[t._v("_createAnimatedEntity")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("Screen"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("width"),s("span",{attrs:{class:"token operator"}},[t._v("/")]),s("span",{attrs:{class:"token number"}},[t._v("4")]),s("span",{attrs:{class:"token operator"}},[t._v("*")]),s("span",{attrs:{class:"token number"}},[t._v("3")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("150")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),s("span",{attrs:{class:"token comment"}},[t._v('//add a new animation named "wings" from frame names')]),t._v("\n        animComponent2"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("addAnimFromAssets")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token string"}},[t._v('"wings"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("0.5")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" anim2Frames"),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//play the animation explision in a loop")]),t._v("\n        animComponent2"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("play")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token string"}},[t._v('"wings"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token boolean"}},[t._v("true")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//Golem animation is created from a grid")]),t._v("\n        "),s("span",{attrs:{class:"token keyword"}},[t._v("var")]),t._v(" golem "),s("span",{attrs:{class:"token operator"}},[t._v("=")]),t._v(" "),s("span",{attrs:{class:"token function"}},[t._v("_createAnimatedEntity")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("Screen"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("centerX"),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" Screen"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("height "),s("span",{attrs:{class:"token operator"}},[t._v("-")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("100")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("3")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("3")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//set the anchor to middle-bottom to display the anim")]),t._v("\n        golem"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("entity"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("transform"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("anchor"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("set")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token number"}},[t._v("0.5")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),s("span",{attrs:{class:"token number"}},[t._v("1")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//add a new anim named walk from a grid of 4 rows and 7 columns, and select 7 frames of the grid")]),t._v("\n        golem"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("addAnimFromGridAssets")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token string"}},[t._v('"walk"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("0.5")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token string"}},[t._v('"images/opengameart/golem-walk.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("4")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("7")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token punctuation"}},[t._v("[")]),s("span",{attrs:{class:"token number"}},[t._v("14")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("15")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("16")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("17")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("18")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("19")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("20")]),s("span",{attrs:{class:"token punctuation"}},[t._v("]")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//add a new anim named attack from a grid of 4 rows and 7 columns, and select 7 frames of the grid")]),t._v("\n        golem"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("addAnimFromGridAssets")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token string"}},[t._v('"attack"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("0.8")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token string"}},[t._v('"images/opengameart/golem-atk.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("4")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("7")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token punctuation"}},[t._v("[")]),s("span",{attrs:{class:"token number"}},[t._v("14")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("15")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("16")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("17")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("18")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("19")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("20")]),s("span",{attrs:{class:"token punctuation"}},[t._v("]")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//add a new anim die walk from a grid of 2 rows and 7 columns, and select the 7 first frames")]),t._v("\n        golem"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("addAnimFromGridAssets")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token string"}},[t._v('"die"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("0.9")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token string"}},[t._v('"images/opengameart/golem-die.png"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("2")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("7")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token keyword"}},[t._v("null")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("7")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//play the anim walk")]),t._v("\n        golem"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("play")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token string"}},[t._v('"walk"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token boolean"}},[t._v("true")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n\n\n        "),s("span",{attrs:{class:"token comment"}},[t._v("//UI and extras")]),t._v("\n        "),s("span",{attrs:{class:"token keyword"}},[t._v("var")]),t._v(" text "),s("span",{attrs:{class:"token operator"}},[t._v("=")]),t._v(" Gecko"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("currentScene"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("createEntity")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n        text"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("addComponent")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("TextComponent"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("create")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token string"}},[t._v("\"Press 'z' to walk, 'x' to attack, 'c' to die\"")]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token string"}},[t._v('"Ubuntu-B.ttf"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("30")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n        text"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("transform"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("position"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("set")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("Screen"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("centerX"),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" Screen"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("height "),s("span",{attrs:{class:"token operator"}},[t._v("-")]),t._v(" "),s("span",{attrs:{class:"token number"}},[t._v("60")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n        text"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("transform"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("fixedToCamera "),s("span",{attrs:{class:"token operator"}},[t._v("=")]),t._v(" "),s("span",{attrs:{class:"token boolean"}},[t._v("true")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n\n        Keyboard"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("enable")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n        Keyboard"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("onPressed "),s("span",{attrs:{class:"token operator"}},[t._v("+")]),s("span",{attrs:{class:"token operator"}},[t._v("=")]),t._v(" "),s("span",{attrs:{class:"token keyword"}},[t._v("function")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("key"),s("span",{attrs:{class:"token punctuation"}},[t._v(":")]),t._v("KeyCode"),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),t._v(" "),s("span",{attrs:{class:"token punctuation"}},[t._v("{")]),t._v("\n            "),s("span",{attrs:{class:"token keyword"}},[t._v("if")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("golem "),s("span",{attrs:{class:"token operator"}},[t._v("!=")]),t._v(" "),s("span",{attrs:{class:"token keyword"}},[t._v("null")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v("{")]),t._v("\n                "),s("span",{attrs:{class:"token keyword"}},[t._v("switch")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),t._v("key"),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v("{")]),t._v("\n                    "),s("span",{attrs:{class:"token keyword"}},[t._v("case")]),t._v(" KeyCode"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("Z"),s("span",{attrs:{class:"token punctuation"}},[t._v(":")]),t._v(" golem"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("play")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token string"}},[t._v('"walk"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token boolean"}},[t._v("true")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n                    "),s("span",{attrs:{class:"token keyword"}},[t._v("case")]),t._v(" KeyCode"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("X"),s("span",{attrs:{class:"token punctuation"}},[t._v(":")]),t._v(" golem"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("play")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token string"}},[t._v('"attack"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token boolean"}},[t._v("true")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n                    "),s("span",{attrs:{class:"token keyword"}},[t._v("case")]),t._v(" KeyCode"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),t._v("C"),s("span",{attrs:{class:"token punctuation"}},[t._v(":")]),t._v(" golem"),s("span",{attrs:{class:"token punctuation"}},[t._v(".")]),s("span",{attrs:{class:"token function"}},[t._v("play")]),s("span",{attrs:{class:"token punctuation"}},[t._v("(")]),s("span",{attrs:{class:"token string"}},[t._v('"die"')]),s("span",{attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),s("span",{attrs:{class:"token boolean"}},[t._v("true")]),s("span",{attrs:{class:"token punctuation"}},[t._v(")")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n                    "),s("span",{attrs:{class:"token keyword"}},[t._v("default")]),s("span",{attrs:{class:"token punctuation"}},[t._v(":")]),t._v("\n                "),s("span",{attrs:{class:"token punctuation"}},[t._v("}")]),t._v("\n            "),s("span",{attrs:{class:"token punctuation"}},[t._v("}")]),t._v("\n        "),s("span",{attrs:{class:"token punctuation"}},[t._v("}")]),s("span",{attrs:{class:"token punctuation"}},[t._v(";")]),t._v("\n    "),s("span",{attrs:{class:"token punctuation"}},[t._v("}")]),t._v("\n"),s("span",{attrs:{class:"token punctuation"}},[t._v("}")]),t._v("\n")])])},function(){var t=this.$createElement,n=this._self._c||t;return n("p",[n("a",{attrs:{href:"https://github.com/Nazariglez/Gecko2D/tree/master/examples/animation",target:"_blank",rel:"noopener noreferrer"}},[this._v("Source Code")])])}],!1,null,null,null);n.default=o.exports}}]);
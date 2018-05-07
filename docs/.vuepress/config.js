let baseDir = (process.env.baseDir === false || process.env.baseDir === 'false') ? null : '/Gecko2D/'; 

module.exports = {
    title: "Gecko2D",
    description: "A flexible and powerful Cross-Platform 2D Game Framework",
    base: baseDir,
    
    themeConfig: {
        repo: "Nazariglez/Gecko2D",
        docsDir: 'docs',
        nav: [
            { text: 'Home', link: '/' },
            { 
                text: 'Getting Started', 
                link: '/getting-started/',
            },
            {
                text: 'Guide',
                link: '/guide/'
            },
            { 
                text: 'Examples', 
                link: '/examples/',
            },
            {
                text: 'API',
                link: '/api'
            }
        ],
        sidebar: {
            "/examples/": require("./examples.json"),
            "/guide/": [
                {
                    title: "Guide",
                    collapsable: false,
                    children: [
                        '',
                        'ecs',
                        'screen'
                    ]
                }
            ]
        }
    }
};
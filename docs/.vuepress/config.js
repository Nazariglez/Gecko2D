let baseDir = (process.env.baseDir === false || process.env.baseDir === 'false') ? null : '/Gecko2D/'; 

module.exports = {
    title: "Gecko2D",
    description: "A flexible and powerful Cross-Platform 2D Game Framework",
    base: baseDir,
    
    themeConfig: {
        docsDir: 'docs',
        nav: [
            { text: 'Home', link: '/' },
            { 
                text: 'Guide', 
                link: '/guide/',
            },
            { text: 'FAQs', link: '/faq.html' },
            { text: 'Github', link: 'https://github.com/Nazariglez/Gecko2D' },
        ]
    }
};
const siteConfig = {
    title: 'Rich Text View',
    //tagline: 'Yarn Version Manager',
    // For deploy
    cname: 'richtextview.com',
    url: 'https://richtextview.com',
    baseUrl: '/',
    projectName: 'RichTextView',
    organizationName: 'tophat',
    // End deploy options
    headerLinks: [
        { doc: 'overview', label: 'Docs' },
        { href: "https://github.com/tophat/RichTextView", label: "GitHub" },
    ],
    headerIcon: 'img/rtv.png',
    footerIcon: 'img/rtv.png',
    favicon: 'img/favicon.png',
    colors: {
        primaryColor: '#934af4',
        secondaryColor: '#934af4',
    },
    customDocsPath: 'docs',
    gaTrackingId: 'UA-129741728-1',

    copyright: `Top Hat Open Source`,

    highlight: {
        // Highlight.js theme to use for syntax highlighting in code blocks.
        theme: 'default',
    },

    // Add custom scripts here that would be placed in <script> tags.
    scripts: ['https://buttons.github.io/buttons.js'],
    onPageNav: 'separate', // On page navigation for the current documentation page.
    cleanUrl: true, // No .html extensions for paths.

    // Open Graph and Twitter card images.
    ogImage: 'img/rtv.png',
    twitterImage: 'img/rtv.png',

    // Show documentation's last contributor's name.
    enableUpdateBy: true,
}

module.exports = siteConfig

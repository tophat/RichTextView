const siteConfig = {
    title: 'Rich Text View',
    //tagline: 'Yarn Version Manager',
    // For deploy
    //cname: 'yvm.js.org',
    url: 'https://tophat.github.io',
    baseUrl: '/RichTextView/',
    projectName: 'RichTextView',
    organizationName: 'tophat',
    // End deploy options
    headerLinks: [
        { doc: 'overview', label: 'Docs' },
        { href: "https://github.com/tophat/RichTextView", label: "GitHub" },
    ],
    headerIcon: 'img/ml.png',
    footerIcon: 'img/ml.png',
    favicon: 'img/favicon.png',
    colors: {
        primaryColor: '#3471c5',
        secondaryColor: '#f9316d',
    },
    customDocsPath: 'docs',
    gaTrackingId: '',

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
    ogImage: 'img/ml.png',
    twitterImage: 'img/ml.png',

    // Show documentation's last contributor's name.
    enableUpdateBy: true,
}

module.exports = siteConfig

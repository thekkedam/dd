# Deepthi Devaki Akkoorath

Personal site of [Deepthi Devaki Akkoorath](https://dd.thekkedam.org).

## This site is 

1. Remix of [Yevgeniy Brikman](http://www.ybrikman.com), 
[Jonathan McGlone](http://jmcglone.com/), 
[jekyll-resume](https://github.com/philipithomas/jekyll-resume) 
and [Post via web](https://github.com/vrypan/jekyll-post-via-web).
1. The design is loosely based on [Kasper](https://github.com/rosario/kasper),
   [Pixyll](http://pixyll.com/), and [Medium](https://medium.com/).
1. Use [Basscss](http://www.basscss.com/), [Sass](http://sass-lang.com/),
   [Font Awesome Icons](http://fortawesome.github.io/Font-Awesome/icons/),
   [Hint.css](http://kushagragour.in/lab/hint/),and
   [Google Fonts](https://www.google.com/fonts) for styling.
1. Use [jQuery](https://jquery.com/), [lazySizes](http://afarkas.github.io/lazysizes/),
   and [responsive-nav.js](http://responsive-nav.com/) for behavior.
1. [Disqus](https://disqus.com/websites/) as a commenting system.
1. [UptimeRobot](http://uptimerobot.com/) and
   [Google Analytics](http://www.google.com/analytics/) for monitoring and
   metrics.
1. Better writer by [Grammarly](https://app.grammarly.com/).
1. IPv6, https support and made faster by [CloudFlare](https://www.cloudflare.com/).
1. Images are served by [RawGit](http://rawgit.com/).

## Run dd.thekkedam.org

1. Use Git to clone this repo  `git clone https://github.com/thekkedam/dd.git`
1. run `git submodule update --init --recursive` to get submodules
1. Make sure you have [Jekyll](http://jekyllrb.com/docs/installation/) installed
1. Update all data under `_data`, `_config.yml` and page informations.
1. run `./build -u` to update all required packages ( if there any problem in updating - run `git submodule foreach git pull origin master`)
1. run `./build -r` to run the site
1. To test: `http://localhost:4000`
1. run `./update` to update git

See the [Jekyll](http://jekyllrb.com/) and [GitHub Pages](https://pages.github.com/)
documentation for more info.

# License

See [LICENSE](http://dd.thekkedam.org/LICENSE/).

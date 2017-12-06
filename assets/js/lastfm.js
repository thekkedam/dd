/* 
 * A simple wraper to basic Last.fm API functionality
 *
 * Only supports GET and unauthenticated methods, which is 90% of what you 
 * need usually, reliant on jquery.
 *
 * @todo add a error callback, catch and handle lfm errors
 *
 */
LastfmAPI = function(api_key) {
    this.api_key = api_key;
};
LastfmAPI.prototype = {
    root: 'https://ws.audioscrobbler.com/2.0/',
    
    get: function (method, params, success, error)
    {
        jQuery.ajax({
            url: this.root,
            dataType: "jsonp",
            data: jQuery.extend({
                'api_key': this.api_key,
                'format': 'json',
                'method': method
            }, params),
            // Forces JSONP errors to fire, needs re-evaluation if long polling is used
            timeout: 2000
        })
        .success(function(response) { 
            (response.error ? error : success)(response);
        })
        .error(function() {
            // JSONP limitations mean we'll only get timeout errors
            console.log({error: 0, message: 'HTTP Error'});
        });
    },
    
    getNowPlayingTrack: function(user, success, error)
    {
        this.get('user.getrecenttracks', {user: user}, function(response) {
            var track = response.recenttracks.track[0];
            
            if (track && track['@attr'] && track['@attr'].nowplaying) {
                success(track);
            }
            else {
                success(false);
            }
        }, error);
    }
};
NowPlaying = function(api, user, interval) {
    this.api = api;
    this.user = user;
    
    /* AutoUpdate frequency - Last.fm API rate limits at 1/sec */
    this.interval = interval || 180;
};
NowPlaying.prototype = {
    
    display: function(track)
    {        
        $('#artist').text(track.artist);
        $('#track').text(track.name);
    },
    
    update: function()
    {
        this.api.getNowPlayingTrack(
            this.user,
            jQuery.proxy(this.handleResponse, this), 
            function(error) { console && console.log(error); }
        );
    },
    
    autoUpdate: function()
    {
        // Do an immediate update, don't wait an interval period
        this.update();
        
        // Try and avoid repainting the screen when the track hasn't changed
        setInterval(jQuery.proxy(this.update, this), this.interval * 1000);
    },
    
    handleResponse: function(response)
    {
        if (response) {
            this.display({
                // The API response can vary depending on the user, so be defensive
                artist: response.artist['#text'] || response.artist.name,
                name: response.name
            });
        }
        else {
            this.display({artist: ' ', name: ''});
        }
    }
};

    (function (document) {
        
        $(document).ready(function() {        
            // Canonicalise/Persist hash
            document.location.hash = username = 'vipintm';
        
            var api = new LastfmAPI('597ec1adbbc339889cd7b441bcd889e9');
            np = new NowPlaying(api, username);
            np.autoUpdate();
        });
    
        // Needs replacing with a cross browser jquery plugin
        window.onhashchange = function(event) {
            username = 'vipintm';
            if (username != np.user) {
                np.user = username;
                np.update();
            }
        };
        
    })(document);


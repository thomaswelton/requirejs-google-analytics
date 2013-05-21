
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define('GoogleAnalytics',['module'], function(module) {
    var GoogleAnalytics;

    GoogleAnalytics = (function() {
      function GoogleAnalytics(config) {
        var src;

        this.config = config;
        this.injectScript = __bind(this.injectScript, this);
        console.log('GoogleAnalytics Class', this.config);
        src = ('https:' === document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga';
        requirejs.config({
          paths: {
            'ga': src
          },
          shim: {
            'ga': {
              exports: '_gaq'
            }
          }
        });
        this.injectScript();
      }

      GoogleAnalytics.prototype.injectScript = function(cb) {
        var _this = this;

        return requirejs(['ga'], function(_gaq) {
          _gaq.push(['_setAccount', _this.config.id]);
          return _gaq.push(['_trackPageview']);
        });
      };

      return GoogleAnalytics;

    })();
    return new GoogleAnalytics(module.config());
  });

}).call(this);

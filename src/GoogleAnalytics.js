(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['module'], function(module) {
    var GoogleAnalytics;

    GoogleAnalytics = (function() {
      function GoogleAnalytics(config) {
        this.config = config;
        this.injectScript = __bind(this.injectScript, this);
        console.log('GoogleAnalytics Class', this.config);
        this.injectScript();
      }

      GoogleAnalytics.prototype.injectScript = function(cb) {
        var src,
          _this = this;

        src = ('https:' === document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        return requirejs([src], function() {
          var _gaq;

          _gaq = window._gaq;
          _gaq.push(['_setAccount', _this.config.id]);
          return _gaq.push(['_trackPageview']);
        });
      };

      return GoogleAnalytics;

    })();
    return new GoogleAnalytics(module.config());
  });

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['module'], function(module) {
    var GoogleAnalytics;

    GoogleAnalytics = (function() {
      function GoogleAnalytics(config) {
        this.config = config;
        this.injectScript = __bind(this.injectScript, this);
        console.log('GoogleAnalytics Class', this.config);
        requirejs.config({
          paths: {
            'ga': '//www.google-analytics.com/analytics'
          },
          shim: {
            'ga': {
              exports: 'ga'
            }
          }
        });
        this.injectScript();
      }

      GoogleAnalytics.prototype.injectScript = function(cb) {
        var _this = this;

        return requirejs(['ga'], function(ga) {
          ga('create', _this.config.id);
          return ga('send', 'pageview');
        });
      };

      return GoogleAnalytics;

    })();
    return new GoogleAnalytics(module.config());
  });

}).call(this);

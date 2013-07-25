(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['module', 'EventEmitter'], function(module, EventEmitter) {
    var GoogleAnalytics;

    GoogleAnalytics = (function(_super) {
      __extends(GoogleAnalytics, _super);

      function GoogleAnalytics(config) {
        this.config = config;
        this.trackEvent = __bind(this.trackEvent, this);
        this.onReady = __bind(this.onReady, this);
        this.injectScript = __bind(this.injectScript, this);
        GoogleAnalytics.__super__.constructor.call(this);
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
          _this.ga = ga;
          ga('create', _this.config.id);
          ga('send', 'pageview');
          return _this.fireEvent('gaReady', ga);
        });
      };

      GoogleAnalytics.prototype.onReady = function(cb) {
        var _this = this;

        if (this.ga != null) {
          return cb(this.ga);
        } else {
          return this.once('gaReady', function(ga) {
            return cb(ga);
          });
        }
      };

      GoogleAnalytics.prototype.trackEvent = function(category, action, label, value) {
        return this.onReady(function(ga) {
          return ga('send', 'event', category, action, label, value);
        });
      };

      return GoogleAnalytics;

    })(EventEmitter);
    return new GoogleAnalytics(module.config());
  });

}).call(this);

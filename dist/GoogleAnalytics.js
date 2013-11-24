(function() {
  'use strict';
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
        this.ready = __bind(this.ready, this);
        this.injectScript = __bind(this.injectScript, this);
        GoogleAnalytics.__super__.constructor.call(this);
        console.log('Running Google Analytics', this.config);
        require.config({
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

      GoogleAnalytics.prototype.injectScript = function() {
        var _this = this;
        return require(['ga'], function(ga) {
          _this.ga = ga;
          ga('create', _this.config.id, _this.config.fields);
          ga('send', 'pageview');
          return _this.fireEvent('gaReady', ga);
        });
      };

      GoogleAnalytics.prototype.ready = function(cb) {
        if (this.ga != null) {
          return cb(this.ga);
        } else {
          return this.once('gaReady', function(ga) {
            return cb(ga);
          });
        }
      };

      GoogleAnalytics.prototype.trackEvent = function(category, action, label, value) {
        return this.ready(function(ga) {
          return ga('send', 'event', category, action, label, value);
        });
      };

      return GoogleAnalytics;

    })(EventEmitter);
    return new GoogleAnalytics(module.config());
  });

}).call(this);

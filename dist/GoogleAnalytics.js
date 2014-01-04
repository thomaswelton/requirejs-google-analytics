(function() {
  'use strict';
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  define(['module', 'EventEmitter'], function(module, EventEmitter) {
    var GoogleAnalytics;
    GoogleAnalytics = (function(_super) {
      __extends(GoogleAnalytics, _super);

      function GoogleAnalytics(config) {
        var _this = this;
        this.config = config;
        this.ecomClear = __bind(this.ecomClear, this);
        this.ecomSend = __bind(this.ecomSend, this);
        this.ecomItem = __bind(this.ecomItem, this);
        this.ecomTran = __bind(this.ecomTran, this);
        this.ecomLoad = __bind(this.ecomLoad, this);
        this.timing = __bind(this.timing, this);
        this.social = __bind(this.social, this);
        this.event = __bind(this.event, this);
        this.view = __bind(this.view, this);
        this.require = __bind(this.require, this);
        this.send = __bind(this.send, this);
        this.set = __bind(this.set, this);
        this.create = __bind(this.create, this);
        this.__ga = __bind(this.__ga, this);
        this.ready = __bind(this.ready, this);
        GoogleAnalytics.__super__.constructor.call(this);
        if (!(this.config.fields && this.config.fields.name)) {
          console.log('GA: Created tracker for ' + this.config.id);
        } else {
          console.log('GA: Created ' + this.config.fields.name + ' for ' + this.config.id);
        }
        this.create(this.config.id, this.config.fields);
        if (this.config.expId) {
          this.set('expId', this.config.expId);
        }
        if (this.config.expVar) {
          this.set('expVar', this.config.expVar);
        }
        this.view();
        if (!this.config.ga) {
          require(['//www.google-analytics.com/analytics'], function(ga) {
            _this.ga = ga;
            return _this.fireEvent('ready', _this.ga);
          });
        } else {
          this.ga = this.config.ga;
          this.fireEvent('ready', this.ga);
        }
        return this;
      }

      GoogleAnalytics.prototype.newTracker = function(config) {
        return new GoogleAnalytics(config);
      };

      GoogleAnalytics.prototype.ready = function(cb) {
        if (this.ga) {
          cb(this.ga);
        } else {
          this.once('ready', function(ga) {
            return cb(ga);
          });
        }
        return this;
      };

      GoogleAnalytics.prototype.__ga = function() {
        var args,
          _this = this;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        if (args.length && this.config.fields && this.config.fields.name) {
          args[0] = this.config.fields.name + '.' + args[0];
        }
        return this.ready(function(ga) {
          return ga.apply(_this, args);
        });
      };

      GoogleAnalytics.prototype.create = function() {
        var args,
          _this = this;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        this.ready(function(ga) {
          return ga.apply(_this, ['create'].concat(args));
        });
        return this;
      };

      GoogleAnalytics.prototype.set = function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return this.__ga.apply(this, ['set'].concat(args));
      };

      GoogleAnalytics.prototype.send = function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return this.__ga.apply(this, ['send'].concat(args));
      };

      GoogleAnalytics.prototype.require = function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return this.__ga.apply(this, ['require'].concat(args));
      };

      GoogleAnalytics.prototype.view = function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return this.send.apply(this, ['pageview'].concat(args));
      };

      GoogleAnalytics.prototype.event = function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return this.send.apply(this, ['event'].concat(args));
      };

      GoogleAnalytics.prototype.social = function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return this.send.apply(this, ['social'].concat(args));
      };

      GoogleAnalytics.prototype.timing = function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return this.send.apply(this, ['timing'].concat(args));
      };

      GoogleAnalytics.prototype.ecomLoad = function() {
        if (!this.ecomLoaded) {
          this.require.apply(this, ['ecommerce', 'ecommerce.js']);
          this.ecomLoaded = true;
        }
        return this;
      };

      GoogleAnalytics.prototype.ecomTran = function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return this.__ga.apply(this.ecomLoad(), ['ecommerce:addTransaction'].concat(args));
      };

      GoogleAnalytics.prototype.ecomItem = function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return this.__ga.apply(this.ecomLoad(), ['ecommerce:addItem'].concat(args));
      };

      GoogleAnalytics.prototype.ecomSend = function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return this.__ga.apply(this.ecomLoad(), ['ecommerce:send'].concat(args));
      };

      GoogleAnalytics.prototype.ecomClear = function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return this.__ga.apply(this.ecomLoad(), ['ecommerce:clear'].concat(args));
      };

      return GoogleAnalytics;

    })(EventEmitter);
    return new GoogleAnalytics(module.config());
  });

}).call(this);

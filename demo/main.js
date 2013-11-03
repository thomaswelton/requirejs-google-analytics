(function() {
  require.config({
    config: {
      GoogleAnalytics: {
        id: 'UA-40648658-5',
        fields: {
          name: 'MyTracker'
        }
      }
    },
    paths: {
      EventEmitter: 'components/event-emitter/EventEmitter',
      GoogleAnalytics: 'GoogleAnalytics'
    }
  });

  require(['GoogleAnalytics'], function(GoogleAnalytics) {
    return GoogleAnalytics.ready(function(ga) {
      return console.log(ga);
    });
  });

}).call(this);

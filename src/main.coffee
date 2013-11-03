require.config
    config:
        # Google Universal Analytics:
        # https://developers.google.com/analytics/devguides/collection/analyticsjs/
        GoogleAnalytics:
            # Change UA-40648658-5 to be your site's ID.
            id: 'UA-40648658-5'
            fields:
                name: 'MyTracker'
    paths:
        EventEmitter : 'components/event-emitter/EventEmitter'
        GoogleAnalytics : 'GoogleAnalytics'

require ['GoogleAnalytics'], (GoogleAnalytics) ->
    GoogleAnalytics.ready (ga) ->
       # GA is fully loaded
       console.log ga

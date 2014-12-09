'use strict'

require.config
    config:
        # Google Universal Analytics:
        # https://developers.google.com/analytics/devguides/collection/analyticsjs/
        GA:
            # Change UA-XXXX-Y to be your site's ID.
            id: 'UA-XXXX-Y'
            # Set to false for SPA apps
            viewOnLoad: true
    paths:
        EventEmitter: 'event-emitter/dist/EventEmitter'
        GA: 'GoogleAnalytics'

require ['GA'], (GA) ->
    GA.ready (ga) ->
        # GA is fully loaded
        console.log ga

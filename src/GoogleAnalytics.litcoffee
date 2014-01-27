requirejs-google-analytics
==========================

https://github.com/thomaswelton/requirejs-google-analytics

Strict helps to trap more potential bugs.

    'use strict'

Load
[Google Analytics](https://developers.google.com/analytics/devguides/collection/analyticsjs/)
using requirejs.
Feel free to just use this snippet for a lightweight implementation.

    require.config
        paths:
            'ga': '//www.google-analytics.com/analytics'
        shim:
            'ga':
                exports: 'ga'

`module` is used to retrieve the
[configuration](http://requirejs.org/docs/api.html#config-moduleconfig) and
[EventEmitter](https://github.com/thomaswelton/bower-event-emitter) is used
for holding an event queue whilst Google Analytics downloads.

    define ['module', 'EventEmitter'], (module, EventEmitter) ->

        class GoogleAnalytics extends EventEmitter

            constructor: (@config) ->

                super()

                if @config.id?
                    @create @config.id, @config.fields

Set the chosen variation for the Visitor for
[experiments](https://developers.google.com/analytics/devguides/collection/analyticsjs/field-reference#experiments).

                    if @config.expId # The id of the experiment the user has been exposed to.
                        @set 'expId', @config.expId
                    if @config.expVar # The index of the variation shown to the visitor.
                        @set 'expVar', @config.expVar

                    @view()

                unless @config.ga
                    # Load the actual Google Analytics library
                    require ['ga'], (@ga) =>
                        @fireEvent 'ready', @ga
                else
                    @ga = @config.ga
                    @fireEvent 'ready', @ga

                return @ # Allow chaining

Multiple Trackers
-----------------

https://developers.google.com/analytics/devguides/collection/analyticsjs/advanced#multipletrackers

            newTracker: (config) ->
                return new GoogleAnalytics config

Ready Event Queue
-----------------

Collect callbacks to be called once Google Analytics loads. Once loaded then
call the callbacks straight away.

            ready: (cb) =>
                if @ga
                    cb @ga
                else
                    @once 'ready', (ga) ->
                        cb ga
                return @ # Allow chaining

Tracker Name and onReady Shim
-----------------------------

            __ga: (args...) =>
                if args.length and @config.fields and @config.fields.name
                    args[0] = @config.fields.name + '.' + args[0]

                @ready (ga) =>
                    ga.apply @, args

Creating Tracker Objects
------------------------

https://developers.google.com/analytics/devguides/collection/analyticsjs/advanced#creation

            create: (args...) =>
                @ready (ga) =>
                    ga.apply @, ['create'].concat args
                return @ # Allow chaining

Custom Dimensions & Metrics
---------------------------

https://developers.google.com/analytics/devguides/collection/analyticsjs/field-reference#general

            set: (args...) =>
                @__ga.apply @, ['set'].concat args

Sending Data
------------

            send: (args...) =>
                @__ga.apply @, ['send'].concat args

Requiring Plugins
-----------------

            require: (args...) =>
                @__ga.apply @, ['require'].concat args

Page Tracking
-------------

https://developers.google.com/analytics/devguides/collection/analyticsjs/pages

            view: (args...) =>
                @send.apply @, ['pageview'].concat args

Event Tracking
--------------

https://developers.google.com/analytics/devguides/collection/analyticsjs/events

            event: (args...) =>
                @send.apply @, ['event'].concat args

Social Interactions
-------------------

https://developers.google.com/analytics/devguides/collection/analyticsjs/social-interactions

            social: (args...) =>
                @send.apply @, ['social'].concat args

User Timings
------------

https://developers.google.com/analytics/devguides/collection/analyticsjs/user-timings

            timing: (args...) =>
                @send.apply @, ['timing'].concat args

Ecommerce
---------

https://developers.google.com/analytics/devguides/collection/analyticsjs/ecommerce

            ecomLoad: =>
                unless @ecomLoaded
                    @require.apply @, ['ecommerce', 'ecommerce.js']
                    @ecomLoaded = true
                return @ # Allow chaining

Adding a Transaction
--------------------

https://developers.google.com/analytics/devguides/collection/analyticsjs/ecommerce#addTrans

            ecomTran: (args...) =>
                @__ga.apply @ecomLoad(), ['ecommerce:addTransaction'].concat args

Adding Items
------------

https://developers.google.com/analytics/devguides/collection/analyticsjs/ecommerce#addItem

            ecomItem: (args...) =>
                @__ga.apply @ecomLoad(), ['ecommerce:addItem'].concat args

Sending Data
------------

https://developers.google.com/analytics/devguides/collection/analyticsjs/ecommerce#sendingData

            ecomSend: (args...) =>
                @__ga.apply @ecomLoad(), ['ecommerce:send'].concat args

Clearing Data
-------------

https://developers.google.com/analytics/devguides/collection/analyticsjs/ecommerce#clearingData

            ecomClear: (args...) =>
                @__ga.apply @ecomLoad(), ['ecommerce:clear'].concat args

Create and return a new instance of GoogleAnalytics.
module.config() returns a JSON object as defined in requirejs.config.GoogleAnalytics

        new GoogleAnalytics module.config()

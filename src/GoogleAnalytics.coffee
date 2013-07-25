define ['module', 'EventEmitter'], (module, EventEmitter) ->
	class GoogleAnalytics extends EventEmitter 
		constructor: (@config) ->
			super()

			console.log 'GoogleAnalytics Class', @config

			requirejs.config
				paths:
					'ga': '//www.google-analytics.com/analytics'
				shim:
					'ga':
						exports: 'ga'

			@injectScript()

		injectScript: (cb) =>
			requirejs ['ga'], (@ga) =>
				ga 'create', @config.id
				ga 'send', 'pageview'

				@fireEvent 'gaReady', ga

		onReady: (cb) =>
			if @ga?
				cb @ga
			else
				@once 'gaReady', (ga) =>
					cb ga

		trackEvent: (category, action, label, value ) =>
			@onReady (ga) ->
				ga('send', 'event', category, action, label, value)

	## Create and return a new instance of GoogleAnalytics
	## module.config() returns a JSON object as defined in requirejs.config.GoogleAnalytics
	new GoogleAnalytics module.config()
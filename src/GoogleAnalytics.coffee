define ['module'], (module) ->
	class GoogleAnalytics 
		constructor: (@config) ->
			console.log 'GoogleAnalytics Class', @config

			requirejs.config
				paths:
					'ga': '//www.google-analytics.com/analytics'
				shim:
					'ga':
						exports: 'ga'

			@injectScript()
				

		injectScript: (cb) =>
			requirejs ['ga'], (ga) =>
				ga 'create', @config.id
				ga 'send', 'pageview'

	## Create and return a new instance of GoogleAnalytics
	## module.config() returns a JSON object as defined in requirejs.config.GoogleAnalytics
	new GoogleAnalytics module.config()
define ['module'], (module) ->
	class GoogleAnalytics 
		constructor: (@config) ->
			console.log 'GoogleAnalytics Class', @config

			src = (if 'https:' is document.location.protocol then 'https://ssl' else 'http://www') + '.google-analytics.com/ga'

			requirejs.config
				paths:
					'ga': src
				shim:
					'ga':
						exports: '_gaq'

			@injectScript()
				

		injectScript: (cb) =>
			requirejs ['ga'], (_gaq) =>
				_gaq.push ['_setAccount', @config.id]
				_gaq.push ['_trackPageview']

	## Create and return a new instance of GoogleAnalytics
	## module.config() returns a JSON object as defined in requirejs.config.GoogleAnalytics
	new GoogleAnalytics module.config()
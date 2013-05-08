define ['module'], (module) ->
	class GoogleAnalytics 
		constructor: (@config) ->
			console.log 'GoogleAnalytics Class', @config

			@injectScript()
				

		injectScript: (cb) =>
			src = (if 'https:' is document.location.protocol then 'https://ssl' else 'http://www') + '.google-analytics.com/ga.js'

			requirejs [src], () =>
				_gaq = window._gaq

				_gaq.push ['_setAccount', @config.id]
				_gaq.push ['_trackPageview']

	## Create and return a new instance of GoogleAnalytics
	## module.config() returns a JSON object as defined in requirejs.config.GoogleAnalytics
	new GoogleAnalytics module.config()
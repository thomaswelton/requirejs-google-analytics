#requirejs-google-analytics
[![Build Status](https://travis-ci.org/thomaswelton/requirejs-google-analytics.png)](https://travis-ci.org/thomaswelton/requirejs-google-analytics)
[![Dependency Status](https://david-dm.org/thomaswelton/requirejs-google-analytics.png)](https://david-dm.org/thomaswelton/requirejs-google-analytics)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/thomaswelton/requirejs-google-analytics/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

Asynchronously load Google Analytics using requirejs.
## Setup

This module utilises requirejs module configuration. It requires the following JS to be added to the page

```javascript
requirejs.config({
	config:{
		'GoogleAnalytics': {
			'id' : 'ACCOUNT_ID'
		}
	}
});
```

## Installation

Instalation via bower

```json
{
  "dependencies": {
  	"GoogleAnalytics": "git://github.com/thomaswelton/bower-google-analytics.git#0.1.1"
  }
}
```

### Usage

#### GoogleAnalytics.onReady(cb)

- cb - (function) Callback to fire when Google Analytic is fully loaded

```javascript
GoogleAnalytics.onReady(function(ga){
	// GA is fully loaded
	console.log(ga);
});
```

#### GoogleAnalytics.trackEvent(category, action, label, value )

* category - Typically the object that was interacted with (e.g. button) - required
* action - The type of interaction (e.g. click) - required
* label - Useful for categorizing events (e.g. nav buttons)
* value - Values must be non-negative. Useful to pass counts (e.g. 4 times)

Custom event tracking (https://developers.google.com/analytics/devguides/collection/analyticsjs/events)

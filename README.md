#requirejs-google-analytics
[![Build Status](https://travis-ci.org/thomaswelton/requirejs-google-analytics.png)](https://travis-ci.org/thomaswelton/requirejs-google-analytics)
[![Dependency Status](https://david-dm.org/thomaswelton/requirejs-google-analytics.png)](https://david-dm.org/thomaswelton/requirejs-google-analytics)
[![DevDependency Status](https://david-dm.org/thomaswelton/requirejs-google-analytics/dev-status.png)](https://david-dm.org/thomaswelton/requirejs-google-analytics#info=devDependencies)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/thomaswelton/requirejs-google-analytics/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

Asynchronously load Google Analytics using requirejs.
## Setup

This module utilises requirejs module configuration. It requires the following JS to be added to the page

```javascript
requirejs.config({
	config: {
		'GA': {
			'id' : 'ACCOUNT_ID'
		}
	},
    paths: {
        EventEmitter: 'bower_components/event-emitter/dist/EventEmitter'
        GA: 'bower_components/requirejs-google-analytics/dist/GoogleAnalytics'
    }
});
```

## Installation

Installation via bower

```json
{
  "dependencies": {
  	"requirejs-google-analytics": "~0.1.6"
  }
}
```

## Usage

### GA.ready(cb)

- cb - (function) Callback to fire when Google Analytics is fully loaded

```javascript
require(['GA'], function (GA) {
    GA.ready(function (ga) {
        // GA is fully loaded
        console.log(ga);
    });
});
```

### GA.view(override)

[Page Tracking](https://developers.google.com/analytics/devguides/collection/analyticsjs/pages)

* override (string/object) - Either a string to override the default page or an object to override the title/location as well

### GA.event(category, action, label, value, fields)

[Event Tracking](https://developers.google.com/analytics/devguides/collection/analyticsjs/events)

* category (string) - Typically the object that was interacted with (e.g. button) - required
* action (string) - The type of interaction (e.g. click) - required
* label (string) - Useful for categorizing events (e.g. nav buttons)
* value (number) - Values must be non-negative. Useful to pass counts (e.g. 4 times)
* fields (object) - The field object is a standard JavaScript object, but defines specific field names and values accepted by analytics.js

### GA.social(network, action, target, fields)

[Social Interactions](https://developers.google.com/analytics/devguides/collection/analyticsjs/social-interactions)

* network (string) - The network on which the action occurs (e.g. Facebook, Twitter) - required
* action (string) - The type of action that happens (e.g. Like, Send, Tweet) - required
* target (string) - Specifies the target of a social interaction. This value is typically a URL but can be any text (e.g. http://mycoolpage.com) - required
* fields (number) - The field object is a standard JavaScript object, but defines specific field names and values accepted by analytics.js

### GA.timing(category, action, label, value, fields)

[User Timings](https://developers.google.com/analytics/devguides/collection/analyticsjs/user-timings)

* category (string) - A string for categorizing all user timing variables into logical groups (e.g jQuery) - required
* var (string) - A string to identify the variable being recorded. (e.g. JavaScript Load) - required
* value (number) - The number of milliseconds in elapsed time to report to Google Analytics (e.g. 20) - required
* label (string) - A string that can be used to add flexibility in visualizing user timings in the reports (e.g. Google CDN)
* fields (number) - The field object is a standard JavaScript object, but defines specific field names and values accepted by analytics.js

## Ecommerce

### GA.ecomTran(data)

[Adding a Transaction](https://developers.google.com/analytics/devguides/collection/analyticsjs/ecommerce#addTrans)

* data (object) - an object with the following attributes:
    * id (string) - The transaction ID (e.g. 1234) - required
    * affiliation (string) - The store or affiliation from which this transaction occurred (e.g. Acme Clothing)
    * revenue (currency) - Specifies the total revenue / grand total associated with the transaction. This value should include any shipping or tax costs (e.g. 11.99)
    * shipping (currency) - Specifies the total shipping cost of the transaction (e.g. 5)
    * tax (currency) - Specifies the total tax of the transaction (e.g. 1.29)

### GA.ecomItem(data)

[Adding Items](https://developers.google.com/analytics/devguides/collection/analyticsjs/ecommerce#addItem)

* data (object) - an object with the following attributes:
    * id (string) - The transaction ID (e.g. 1234) - required
    * name (string) - The item name (e.g. Fluffy Pink Bunnies) - required
    * sku (string) - Specifies the SKU or item code (e.g. SKU47)
    * category (string) - The category to which the item belongs (e.g. Party Toys)
    * price (currency) - The individual, unit, price for each item (e.g. 11.99)
    * quantity (currency) - The number of units purchased in the transaction (e.g. 1)

### GA.ecomSend()

[Sending Data](https://developers.google.com/analytics/devguides/collection/analyticsjs/ecommerce#sendingData)

### GA.ecomClear()

[Clearing Data](https://developers.google.com/analytics/devguides/collection/analyticsjs/ecommerce#clearingData)

## Advanced Usage

### GA.newTracker(config)

[Multiple Trackers](https://developers.google.com/analytics/devguides/collection/analyticsjs/advanced#multipletrackers)

* config (object) - An object the same that would be specified in requirejs.config.config.GA

### GA.set(field, value)

[Fields](https://developers.google.com/analytics/devguides/collection/analyticsjs/field-reference#general)

* field (string/object) - Either a string containing the name of a field or a mapping of fields and values - required
* value (any) - the value of the field

### [Create Only Fields](https://developers.google.com/analytics/devguides/collection/analyticsjs/field-reference#create)

```javascript
requirejs.config({
    config: {
        'GA': {
            'id' : 'ACCOUNT_ID',
            'fields': {
                // Create only fields go here:
                name: 'myTracker'
            }
        }
    },
    paths: {
        EventEmitter: 'bower_components/event-emitter/dist/EventEmitter'
        GA: 'bower_components/requirejs-google-analytics/dist/GoogleAnalytics'
    }
});
```

### [Experiments](https://developers.google.com/analytics/devguides/collection/analyticsjs/experiments)

```javascript
requirejs.config({
    config: {
        'GA': {
            'id' : 'ACCOUNT_ID',
            // Experiment ID and Var go here:
            'expId' : $expermentId,
            'expVar' : $expermentVar,
        }
    },
    paths: {
        EventEmitter: 'bower_components/event-emitter/dist/EventEmitter'
        GA: 'bower_components/requirejs-google-analytics/dist/GoogleAnalytics'
    }
});
```

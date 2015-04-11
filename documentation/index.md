# Notificare Module

## Description

Titanium module for Notificare Mobile Marketing Platform. Before start make sure you grab the DefaultTheme.bundle, Notificare.plist and NotificareTags.plist from https://github.com/Notificare/notificare-push-lib and place it in your app's assets folder. Notificare.plist is the configuration file where you should make changes to match your app's settings.

## Accessing the Notificare Module

To access this module from JavaScript, you would do the following:

	var Notificare = require("ti.notificare");

The Notificare variable is a reference to the Module object.	

## Reference

### Notificare.addEventListener

Notificare will be initialized at launch automatically. But before you can request any of the methods you must wait for the 'ready' event to be fired. 
Additionally you can also listen to the 'registered' event, triggered in response to Notificare.registerDevice(), the 'range' event that is fired any time iBeacons are in range,
the 'location' event which is fired any time a user moves significantly and the 'transaction' and 'download' events in response to a buyProduct() request.

Parameters:

- event (required) {String} A string representing the event to listen to
- callback {Function} A callback ({Object})

### Notificare.userID

Set this value to register the device with a userID. It should be set before calling Notificare.registerDevice().

### Notificare.userName

Set this value to register the device with a userName. To use this, userID must be also set. It should be set before calling Notificare.registerDevice().


### Notificare.registerDevice

Registers the device with Notificare. It should be used in used from the success function of Ti.Network.registerForPushNotifications.

Parameters:

- token (required) {String}


### Notificare.openNotification

Open an incoming notification. It should be used in used from the callback function of Ti.Network.registerForPushNotifications.

Parameters:

- notification {Object} The payload received of the incoming notification 

### Notificare.startLocationUpdates

Start location services. This should only be called after the event 'registered' has been fired.

Parameters:

- notification {Object} The payload received of the incoming notification 

### Notificare.addTags

Adds one or more tags to the device. This should only be called after the event 'registered' has been fired.

Parameters:

- tags [{String}]

### Notificare.removeTag

Removes a tag from the device.  This should only be called after the event 'registered' has been fired.

Parameters:

- tag {String}

### Notificare.buyProduct

Starts a transaction with the App Store. This should only be called after the event 'store' has been fired.

Parameters:

- identifier {String} Use the product identifier to start a transaction

## Usage

See sample app in example/app.js


## Authors

Joel Oliveira <joel@notifica.re>
Joris Verbogt <joris@notifica.re>

Copyright (c) 2015 Notificare B.V.


## License

Simplified BSD
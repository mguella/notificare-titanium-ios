# Notificare Module

## Description

Titanium module for Notificare Mobile Marketing Platform. Before you start make sure you grab the DefaultTheme.bundle, Notificare.plist and NotificareTags.plist from https://github.com/Notificare/notificare-push-lib and place it in your app's assets folder. Notificare.plist is the configuration file where you should make changes to match your app's settings.

## Accessing the Notificare Module

To access this module from JavaScript, you would do the following:

	var Notificare = require("ti.notificare");

The Notificare variable is a reference to the Module object.	

## Reference

### Notificare.addEventListener

Notificare will be initialized at launch automatically. But before you can request any of the methods you must wait for the 'ready' event to be fired. 

Events:
- ready (required) {String} Fired whenever the Notificare library is ready
- registration (required) {String} Fired in response to registerForNotifications or enableNotifications. Contains the device token, use it to register to Notificare
- registered (optional) {String} Fired when the device is registered with Notificare
- location (optional) {String} Fired when the device's location is updated
- notification (optional) {String} Fired when a notification is received
- range (optional) {String} Fired when beacons are in range. This only occurs in foreground
- errors (optional) {String} Fired whenever there's errors

Parameters:

- event (required) {String} A string representing the event to listen to
- callback {Function} A callback ({Object})

### Notificare.registerForNotifications

Registers the device with APNS. First time it will prompt the user with a permissions dialog.


### Notificare.userID

Set this value to register the device with a userID. It should be set before calling Notificare.registerDevice().

### Notificare.userName

Set this value to register the device with a userName. To use this, userID must be also set. It should be set before calling Notificare.registerDevice().


### Notificare.registerDevice

Registers the device with Notificare. It should be invoked after the 'ready' event.

Parameters:

- token (required) {String}


### Notificare.startLocationUpdates

Start location services. This should only be called after the event 'registered' has been fired.


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

See sample app in example/app.js. For documentation please refer to: https://notificare.atlassian.net/wiki/display/notificare/Getting+started+with+Titanium


## Authors

- Joel Oliveira <joel@notifica.re>
- Joris Verbogt <joris@notifica.re>

Copyright (c) 2015 Notificare B.V.


## License

Simplified BSD
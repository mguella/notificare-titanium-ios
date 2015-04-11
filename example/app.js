// This is a test harness for your module
// You should do something interesting in this harness
// to test out the module and to provide instructions
// to users on how to use it by example.


// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});
var label = Ti.UI.createLabel();
win.add(label);
win.open();

var notificare = require('ti.notificare');

Ti.API.info("module is => " + notificare);

var deviceToken = null;

notificare.addEventListener('ready',function(e){
	
	//For iOS
	if (Ti.Platform.name == "iPhone OS"){
		// Check if the device is running iOS 8 or later
		if (parseInt(Ti.Platform.version.split(".")[0]) >= 8) {
		 
		 // Wait for user settings to be registered before registering for push notifications
		    Ti.App.iOS.addEventListener('usernotificationsettings', function registerForPush() {
		 
		 // Remove event listener once registered for push notifications
		        Ti.App.iOS.removeEventListener('usernotificationsettings', registerForPush); 
		 
		        Ti.Network.registerForPushNotifications({
		            success: deviceTokenSuccess,
		            error: deviceTokenError,
		            callback: receivePush
		        });
		    });
		 
		 // Register notification types to use
		    Ti.App.iOS.registerUserNotificationSettings({
			    types: [
		            Ti.App.iOS.USER_NOTIFICATION_TYPE_ALERT,
		            Ti.App.iOS.USER_NOTIFICATION_TYPE_SOUND,
		            Ti.App.iOS.USER_NOTIFICATION_TYPE_BADGE
		        ]
		    });
		} else {
		    Ti.Network.registerForPushNotifications({
		 // Specifies which notifications to receive
		        types: [
		            Ti.Network.NOTIFICATION_TYPE_BADGE,
		            Ti.Network.NOTIFICATION_TYPE_ALERT,
		            Ti.Network.NOTIFICATION_TYPE_SOUND
		        ],
		        success: deviceTokenSuccess,
		        error: deviceTokenError,
		        callback: receivePush
		    });
		}	
	}
	
	
	//For Android
});

//Listen for the device registered event
//Only after this event occurs it is safe call any other method
notificare.addEventListener('registered', function(e){
	 startLocationUpdates(e);
	 //addTags(['one','two']);
	 //openUserPreferences(e);
	 //openBeacons(e);
	 var tag = "one,two";
	 removeTag(tag);
});

notificare.addEventListener('tags', function(e){
	e.tags.forEach(function(tag){
		Ti.API.info("Device Tag: " + tag);
	});
	 
});

notificare.addEventListener('location', function(e){
	 Ti.API.info("User location changed " + e.latitude + e.longitude);
});

notificare.addEventListener('store', function(e){
	 Ti.API.info("In-App Products Store loaded " + e.products);
});

notificare.addEventListener('transaction', function(e){
	 Ti.API.info(e.message + e.transaction);
});

notificare.addEventListener('download', function(e){
	 Ti.API.info(e.message + e.download);
});

notificare.addEventListener('store', function(e){
	 e.products.forEach(function(product){
		Ti.API.info("Product: " + product.identifer + product.name);
	});
	 //After this trigger is it safe to buy products
	 // use Notificare.buyProduct(product.identifier);
	 // To buy products
	 
});

notificare.addEventListener('errors', function(e){
	 Ti.API.info("There was an error " + e.error);
	 Ti.API.info("with message " + e.message);
});

notificare.addEventListener('range', function(e){
	e.beacons.forEach(function(beacon){
		Ti.API.info("Beacon: " + beacon.uuid + beacon.proximity);
	});
});


// Let Notificare handle an incoming notification
function receivePush(e) {
    notificare.openNotification(e.data);
}

// Register the device with Notificare
function deviceTokenSuccess(e) {
    deviceToken = e.deviceToken;
    // notificare.userID = 'testing123';
    // notificare.userName = 'Name here';
    notificare.registerDevice(deviceToken);
}
function deviceTokenError(e) {
    alert('Failed to register for push notifications! ' + e.error);
}
//Start location updates 
function startLocationUpdates(e) {
    notificare.startLocationUpdates(e);
}
//Add tags
function addTags(e) {
    notificare.addTags(e);
}

//Remove tag
function removeTag(e) {
    notificare.removeTag(e);
}

//Open Beacons
function openBeacons(e) {
    notificare.openBeacons(e);
}
//Open User Preferences
function openUserPreferences(e) {
    notificare.openUserPreferences(e);
}

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
//Only after this event occurs it is safe to start location updates or add/remove tags
notificare.addEventListener('registered', function(e){
	 startLocationUpdates(e);
	 addTags(['one','two']);
});

notificare.addEventListener('range', function(e){
	 Ti.API.info("list of beacons in range " + e);
});


// Let Notificare handle an incoming notification
function receivePush(e) {
    notificare.openNotification(e.data);
}

// Register the device with Notificare
function deviceTokenSuccess(e) {
    deviceToken = e.deviceToken;
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

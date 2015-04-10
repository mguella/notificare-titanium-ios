/**
 * notificare-titanium-ios
 *
 * Created by Your Name
 * Copyright (c) 2015 Your Company. All rights reserved.
 */

#import "TiNotificareModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiNotificareModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"d68e92a8-c6e7-4a31-a140-2d00ab8e0dab";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.notificare";
}

#pragma mark Lifecycle

-(void)startup
{
    // this method is called when the module is first loaded
    // you *must* call the superclass
    [super startup];
    
    TiThreadPerformOnMainThread(^{
        [[NotificarePushLib shared] launch];
        [[NotificarePushLib shared] setDelegate:self];
    }, NO);

    
    NSLog(@"[INFO] %@ loaded",self);
}

+(void)load
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppCreate:)
                                                 name:@"UIApplicationDidFinishLaunchingNotification" object:nil];
}

+(void)onAppCreate:(NSNotification *)notification
{

    ENSURE_CONSISTENCY([NSThread isMainThread]);
    
    [[NotificarePushLib shared] handleOptions:notification.userInfo];
    
}



- (void)notificarePushLib:(NotificarePushLib *)library onReady:(NSDictionary *)info{
    
    [self fireEvent:@"ready" withObject:info];
    
}

- (void)notificarePushLib:(NotificarePushLib *)library didLoadStore:(NSArray *)products{
    
    [self fireEvent:@"store" withObject:products];
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailToStartLocationServiceWithError:(NSError *)error{
    
    [self fireEvent:@"errors" withObject:error];
    
}

- (void)notificarePushLib:(NotificarePushLib *)library didUpdateLocations:(NSArray *)locations{
    
    [self fireEvent:@"location" withObject:locations];
}

- (void)notificarePushLib:(NotificarePushLib *)library didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    
    [self fireEvent:@"range" withObject:beacons];
    
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably

	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
    
    RELEASE_TO_NIL(userId);
    RELEASE_TO_NIL(username);
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(id)userID
{
    return userId;
}

-(void)setUserID:(id)value
{
    // Macro from TiBase.h to type check the data
    ENSURE_STRING(value);
    // Call the retain method to keep a reference to the passed value
    userId = [value retain];
}


-(id)userName
{
    return username;
}

-(void)setUserName:(id)value
{
    // Macro from TiBase.h to type check the data
    ENSURE_STRING(value);
    // Call the retain method to keep a reference to the passed value
    username = [value retain];
}

-(void)registerDevice:(id)arg
{
    ENSURE_SINGLE_ARG(arg, NSString);
    ENSURE_UI_THREAD_1_ARG(arg);
    
    // The token received in the success callback to 'Ti.Network.registerForPushNotifications' is a hex-encode
    // string. We need to convert it back to it's byte format as an NSData object.
    
    NSMutableData *token = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = { '\0', '\0', '\0' };
    int i;
    for (i=0; i<[arg length]/2; i++) {
        byte_chars[0] = [arg characterAtIndex:i*2];
        byte_chars[1] = [arg characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [token appendBytes:&whole_byte length:1];
    }
    

    if(userId && username){
        
        [[NotificarePushLib shared] registerDevice:token withUserID:userId withUsername:username completionHandler:^(NSDictionary *info) {
            //
            [self fireEvent:@"registered" withObject:info];
            
        } errorHandler:^(NSError *error) {
            //
        }];

    } else if(userId && !username){
        [[NotificarePushLib shared] registerDevice:token withUserID:userId completionHandler:^(NSDictionary *info) {
            //
            [self fireEvent:@"registered" withObject:info];
            
        } errorHandler:^(NSError *error) {
            //
        }];
    } else {
        [[NotificarePushLib shared] registerDevice:token completionHandler:^(NSDictionary *info) {
            //
            [self fireEvent:@"registered" withObject:info];
            
        } errorHandler:^(NSError *error) {
            //
        }];
    }
    
    
}

-(void)startLocationUpdates:(id)arg
{

    ENSURE_UI_THREAD(startLocationUpdates, arg);
    [[NotificarePushLib shared] startLocationUpdates];
    
}


-(void)openNotification:(id)arg
{
    // The only argument to this method is the userInfo dictionary received from
    // the remote notification
    
    ENSURE_UI_THREAD_1_ARG(arg);

    id userInfo = [arg objectAtIndex:0];
    ENSURE_DICT(userInfo);
    
   [[NotificarePushLib shared] openNotification:userInfo];
    
}

-(void)addTags:(id)arg
{

    ENSURE_UI_THREAD_1_ARG(arg);
    ENSURE_ARRAY(arg);
    
    [[NotificarePushLib shared] addTags:arg];
    
}

-(void)removeTag:(id)arg
{
    
    ENSURE_SINGLE_ARG(arg, NSString);
    ENSURE_UI_THREAD_1_ARG(arg);
        
    [[NotificarePushLib shared] removeTag:arg];
        
}


@end
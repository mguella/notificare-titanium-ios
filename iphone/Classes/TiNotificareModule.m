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
    
    NSMutableArray * prods = [NSMutableArray array];
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    NSMutableDictionary * prod = [NSMutableDictionary dictionary];
    
    for (NotificareProduct * product  in products) {
        [prod setObject:product.productName forKey:@"name"];
        [prod setObject:product.productDescription forKey:@"description"];
        [prod setObject:product.identifier forKey:@"identifier"];
        [prod setObject:product.type forKey:@"type"];
        [prod setObject:[NSNumber numberWithBool:product.purchased] forKey:@"purchased"];
        [prod setObject:product.priceLocale forKey:@"price"];
        
        NSMutableArray * downloads = [NSMutableArray array];
        NSMutableDictionary * download = [NSMutableDictionary dictionary];
        
        for (SKDownload * d in product.downloads) {
            [d setValue:d.contentIdentifier forKey:@"contentIdentifier"];
            [d setValue:[NSString stringWithFormat:@"%f",d.progress] forKey:@"progress"];
            [d setValue:[NSString stringWithFormat:@"%f",d.timeRemaining] forKey:@"timeRemaining"];
            [d setValue:[NSNumber numberWithInt:d.downloadState] forKey:@"downloadState"];
            [downloads addObject:download];
        }
        [prod setObject:downloads forKey:@"downloads"];
        [prods addObject:prod];
    }
    
    [result setValue:prods forKey:@"products"];
    [self fireEvent:@"store" withObject:result];
}


- (void)notificarePushLib:(NotificarePushLib *)library didFailProductTransaction:(SKPaymentTransaction *)transaction withError:(NSError *)error{
    
    NSMutableDictionary * err = [NSMutableDictionary dictionary];
    [err setValue:@"Transaction failed" forKey:@"message"];
    [err setValue:error.userInfo.description forKey:@"error"];
    [self fireEvent:@"errors" withObject:err];
}

- (void)notificarePushLib:(NotificarePushLib *)library didCompleteProductTransaction:(SKPaymentTransaction *)transaction{
    
    NSMutableDictionary * trans = [NSMutableDictionary dictionary];
    [trans setValue:@"Transaction completed" forKey:@"message"];
    [trans setValue:transaction.payment.productIdentifier forKey:@"transaction"];
    [self fireEvent:@"transaction" withObject:trans];
}

- (void)notificarePushLib:(NotificarePushLib *)library didRestoreProductTransaction:(SKPaymentTransaction *)transaction{
    
    NSMutableDictionary * trans = [NSMutableDictionary dictionary];
    [trans setValue:@"Transaction restored" forKey:@"message"];
    [trans setValue:transaction.payment.productIdentifier forKey:@"transaction"];
    [self fireEvent:@"transaction" withObject:trans];
    
}

- (void)notificarePushLib:(NotificarePushLib *)library didStartDownloadContent:(SKPaymentTransaction *)transaction{
    
    NSMutableDictionary * trans = [NSMutableDictionary dictionary];
    [trans setValue:@"Started download for transaction" forKey:@"message"];
    [trans setValue:transaction.payment.productIdentifier forKey:@"transaction"];
    [self fireEvent:@"transaction" withObject:trans];
}

- (void)notificarePushLib:(NotificarePushLib *)library didFinishDownloadContent:(SKDownload *)download{
    
    NSMutableDictionary * d = [NSMutableDictionary dictionary];
    [d setValue:@"Download finished" forKey:@"message"];
    [d setValue:download.transaction.payment.productIdentifier forKey:@"download"];
    [self fireEvent:@"download" withObject:d];
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailToLoadStore:(NSError *)error{
    
    NSMutableDictionary * err = [NSMutableDictionary dictionary];
    [err setValue:@"Load store failed" forKey:@"message"];
    [err setValue:error.userInfo.description forKey:@"error"];
    [self fireEvent:@"errors" withObject:err];
    
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailToStartLocationServiceWithError:(NSError *)error{
    
    NSMutableDictionary * err = [NSMutableDictionary dictionary];
    [err setValue:@"Location services failed" forKey:@"message"];
    [err setValue:error.userInfo.description forKey:@"error"];
    [self fireEvent:@"errors" withObject:err];
    
}

- (void)notificarePushLib:(NotificarePushLib *)library didUpdateLocations:(NSArray *)locations{
    CLLocation * lastLocation = (CLLocation *)[locations lastObject];
    NSMutableDictionary * location = [NSMutableDictionary dictionary];
    [location setValue:[NSNumber numberWithFloat:[lastLocation coordinate].latitude] forKey:@"latitude"];
    [location setValue:[NSNumber numberWithFloat:[lastLocation coordinate].longitude] forKey:@"longitude"];
    [self fireEvent:@"location" withObject:location];
}

- (void)notificarePushLib:(NotificarePushLib *)library didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    NSMutableDictionary * b = [NSMutableDictionary dictionary];
    NSMutableArray * bcn = [NSMutableArray array];
    for (NotificareBeacon * beacon in beacons) {
        [b setObject:beacon.name forKey:@"name"];
        [b setObject:beacon.purpose forKey:@"purpose"];
        [b setObject:beacon.notification forKey:@"notification"];
        [b setObject:beacon.region forKey:@"region"];
        [b setObject:beacon.beacon.major forKey:@"major"];
        [b setObject:beacon.beacon.minor forKey:@"minor"];
        [b setObject:beacon.beacon.proximityUUID forKey:@"uuid"];
        [b setObject:beacon.beacon.proximity forKey:@"proximity"];
        [b setObject:beacon.proximityNotifications forKey:@"notifications"];
        [bcn addObject:b];
    }
    [result setValue:bcn forKey:@"beacons"];
    [self fireEvent:@"range" withObject:result];
    
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
            
            [self getTags];
            
        } errorHandler:^(NSError *error) {
            //
        }];

    } else if(userId && !username){
        [[NotificarePushLib shared] registerDevice:token withUserID:userId completionHandler:^(NSDictionary *info) {
            //
            [self fireEvent:@"registered" withObject:info];
            [self getTags];
        } errorHandler:^(NSError *error) {
            //
        }];
    } else {
        [[NotificarePushLib shared] registerDevice:token completionHandler:^(NSDictionary *info) {
            //
            [self fireEvent:@"registered" withObject:info];
            [self getTags];
        } errorHandler:^(NSError *error) {
            //
        }];
    }
 
}

-(void)getTags{
    [[NotificarePushLib shared] getTags:^(NSDictionary *info) {
        NSMutableArray * t = [NSMutableArray array];
        for (NSString * tag in [info objectForKey:@"tags"]) {
            [t addObject:tag];
        }
        
        NSMutableDictionary * tags = [NSMutableDictionary dictionary];
        [tags setValue:t forKey:@"tags"];
        
        [self fireEvent:@"tags" withObject:tags];
        
    } errorHandler:^(NSError *error) {
        //
    }];
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
    ENSURE_SINGLE_ARG(arg, NSArray);
    
    [[NotificarePushLib shared] addTags:arg completionHandler:^(NSDictionary *info) {
        //
        [self getTags];
    } errorHandler:^(NSError *error) {
        //
    }];
    
}

-(void)removeTag:(id)arg
{
    ENSURE_UI_THREAD_1_ARG(arg);
    ENSURE_SINGLE_ARG(arg, NSString);

    [[NotificarePushLib shared] removeTag:arg completionHandler:^(NSDictionary *info) {
        [self getTags];
    } errorHandler:^(NSError *error) {
        //
    }];
    
    
        
}

-(void)openBeacons:(id)arg
{
    ENSURE_UI_THREAD_0_ARGS;
    
    [[NotificarePushLib shared] openBeacons];
    
}

-(void)openUserPreferences:(id)arg
{
    
    ENSURE_UI_THREAD_0_ARGS;
    
    [[NotificarePushLib shared] openUserPreferences];
    
}


-(void)openInbox:(id)arg
{
    
    ENSURE_UI_THREAD_0_ARGS;
    
    [[NotificarePushLib shared] openInbox];
    
}

-(void)buyProduct:(id)arg
{
    
    ENSURE_UI_THREAD_1_ARG(arg);
    ENSURE_SINGLE_ARG(arg, NSString);
    
    [[NotificarePushLib shared]  fetchProduct:arg completionHandler:^(NotificareProduct *product) {
        //
        [[NotificarePushLib shared] buyProduct:product];
        
    } errorHandler:^(NSError *error) {
        //
    }];
    
}


@end
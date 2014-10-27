//
//  CTXAppDelegate.m
//  JohnnyEnglish
//
//  Created by Dmitry Makarenko on 31/08/2014.
//  Copyright (c) 2014 EF CTX. All rights reserved.
//  Licensed under the MIT license.
//

#import "CTXAppDelegate.h"
#import "CTXMainViewController.h"
#import "CTXJohnnyEnglishGoogleAnalyticsConfiguration.h"

#import <JohnnyEnglish/CTXJohnnyEnglish.h>

@interface CTXAppDelegate()

@property (strong, nonatomic) CTXUserActivityTrackingManager *trackingManager;

@end


@implementation CTXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self trackerSetup];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self.window setRootViewController:[[UINavigationController alloc] initWithRootViewController:[[CTXMainViewController alloc] init]]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)trackerSetup
{
    self.trackingManager = [[CTXUserActivityTrackingManager alloc] init];
    
    NSError *error = nil;
    
    void (^checkError)(NSError *) = ^(NSError *error){
        if (error) {
            NSLog(@"ERROR: %@", error);
        }
    };
    
    [self.trackingManager registerScreenTrackerFromClass:NSClassFromString(@"CTXMainViewController") screenName:@"Main Screen" error:&error];
    checkError(error);
    
    [self.trackingManager registerScreenTrackerFromClass:NSClassFromString(@"CTXBaseViewController") screenCallback:^CTXUserActivityScreenHit *(CTXMethodCallInfo *callInfo) {
        CTXUserActivityScreenHit *hitScreen = [[CTXUserActivityScreenHit alloc] init];
        hitScreen.screenName = [NSString stringWithFormat:@"Base => %@", [[callInfo instance] class]];
        return hitScreen;
    } error:&error];
    checkError(error);
    
    [self.trackingManager registerScreenTrackerFromClass:NSClassFromString(@"CTXSecondViewController") screenCallback:^CTXUserActivityScreenHit *(CTXMethodCallInfo *callInfo) {
        CTXUserActivityScreenHit *hitScreen = [[CTXUserActivityScreenHit alloc] init];
        hitScreen.screenName = [[callInfo instance] title];
        return hitScreen;
    } error:&error];
    checkError(error);
    
    [self.trackingManager registerTimeTrackerFromClass:NSClassFromString(@"CTXMainViewController") startSelector:NSSelectorFromString(@"startTimer") stopSelector:NSSelectorFromString(@"stopTimer") eventCallback:^CTXUserActivityTiming *(CTXMethodCallInfo *startMethodCallInfo, CTXMethodCallInfo *stopMethodCallInfo, NSTimeInterval duration) {
        CTXUserActivityTiming *timing = [[CTXUserActivityTiming alloc] init];
        timing.category = @"UX";
        timing.name = @"timer";
        timing.interval = @(duration);
        return timing;
    } error:&error];
    checkError(error);
    
    [self.trackingManager registerEventTrackerFromClass:NSClassFromString(@"CTXMainViewController") selector:NSSelectorFromString(@"dispatchEvent") eventCallback:^CTXUserActivityEvent *(CTXMethodCallInfo *callInfo) {
        CTXUserActivityEvent *event = [[CTXUserActivityEvent alloc] init];
        event.category = @"UX";
        event.action = @"touch";
        [event setCustomMetric:@"1" withValue:[@(rand()) stringValue]];
        return event;
    } error:&error];
    checkError(error);
    
    [self.trackingManager registerEventTrackerFromClass:NSClassFromString(@"CTXMainViewController") selector:NSSelectorFromString(@"startSession") eventCallback:^CTXUserActivityEvent *(CTXMethodCallInfo *callInfo) {
        CTXUserActivityEvent *event = [[CTXUserActivityEvent alloc] init];
        event.category = @"UX";
        event.action = @"touch";
        event.label = @"session start button";
        event.sessionControl = CTXSessionControlStart;
        return event;
    } error:&error];
    checkError(error);
    
    [self.trackingManager registerEventTrackerFromClass:NSClassFromString(@"CTXMainViewController") selector:NSSelectorFromString(@"stopSession") eventCallback:^CTXUserActivityEvent *(CTXMethodCallInfo *callInfo) {
        CTXUserActivityEvent *event = [[CTXUserActivityEvent alloc] init];
        event.category = @"UX";
        event.action = @"touch";
        event.label = @"session start button";
        event.sessionControl = CTXSessionControlStop;
        return event;
    } error:&error];
    checkError(error);
    
    CTXGATracker *tracker = [[CTXGATracker alloc] initWithTrackingId:CTXJohnnyEnglishGoogleAnalyticsConfigurationTrackingID];
    tracker.debugMode = YES;
    tracker.sampleRate = 1.0;
    
    [self.trackingManager registerTracker:tracker];
}

@end

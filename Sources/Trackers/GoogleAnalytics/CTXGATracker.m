//
//  CTXGATracker.m
//  Pods
//
//  Created by Mario on 06/10/2014.
//
//

#import "CTXGATracker.h"

#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import "CTXUserActivityEvent.h"
#import "CTXUserActivityTiming.h"
#import "CTXUserActivityScreenHit.h"

static NSUInteger const kTrackerDispatchInterval = 120;

@interface CTXGATracker()

@property (nonatomic, strong) id<GAITracker> tracker;
@property (nonatomic, strong) GAIDictionaryBuilder *builder;

@end

@implementation CTXGATracker

- (instancetype)initWithTrackingId:(NSString *)trackingId
{
    if (self = [super init]) {
        [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
        [[GAI sharedInstance] setDispatchInterval:kTrackerDispatchInterval];
        [[GAI sharedInstance] setDryRun:YES];//TODO: Temporary
        self.tracker = [[GAI sharedInstance] trackerWithTrackingId:trackingId];
    }
    
    return self;
}

#pragma mark - CTXUserActivityTrackerProtocol Methods

- (void)trackUserId:(NSString *)userId
{
    [self.tracker set:@"&uid" value:userId];
}

- (void)startSessionWithScreenHit:(NSString *)screenName
{
    self.builder = [GAIDictionaryBuilder createScreenView];
    [self.builder set:@"start" forKey:kGAISessionControl];
    [self.tracker set:kGAIScreenName value:screenName];
    [self.tracker send:[self.builder build]];
}

- (void)stopSession
{
    if (self.builder) {
        [self.builder set:@"end" forKey:kGAISessionControl];
        self.builder = nil;
    } else {
        NSLog(@"Warning: [%@] You're trying to stop a session without starting it", NSStringFromSelector(_cmd));
    }
}

- (void)trackScreenHit:(CTXUserActivityScreenHit *)screenHit
{
    [screenHit.customDimensions enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [self.tracker set:[GAIFields customDimensionForIndex:[obj integerValue]] value:key];//TODO: check if key is really a number
    }];
    
    [screenHit.customMetrics enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [self.tracker set:[GAIFields customMetricForIndex:[obj integerValue]] value:key];//TODO: check if key is really a number
    }];
    
    [self.tracker set:kGAIScreenName value:screenHit.screenName];
    
    [self.tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)trackEvent:(CTXUserActivityEvent *)event
{
    [event.customDimensions enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [self.tracker set:[GAIFields customDimensionForIndex:[obj integerValue]] value:key];//TODO: check if key is really a number
    }];
    
    [event.customMetrics enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [self.tracker set:[GAIFields customMetricForIndex:[obj integerValue]] value:key];//TODO: check if key is really a number
    }];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:[event category]
                                                               action:[event action]
                                                                label:[event label]
                                                                value:[event value]] build]];
}

- (void)trackTiming:(CTXUserActivityTiming *)timing
{
    [timing.customDimensions enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [self.tracker set:[GAIFields customDimensionForIndex:[obj integerValue]] value:key];//TODO: check if key is really a number
    }];
    
    [timing.customMetrics enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [self.tracker set:[GAIFields customMetricForIndex:[obj integerValue]] value:key];//TODO: check if key is really a number
    }];
    
    [self.tracker send:[[GAIDictionaryBuilder createTimingWithCategory:timing.category
                                                              interval:timing.interval
                                                                  name:timing.name
                                                                 label:timing.label] build]];
}

@end

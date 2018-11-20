//
//  CTXSegmentTracker.m
//  JohnnyEnglish
//
//  Created by Stefan Ceriu on 20/11/2018.
//  Copyright (c) 2018 EF CTX. All rights reserved.
//  Licensed under the MIT license.

#import "CTXSegmentTracker.h"

#import <Analytics/SEGAnalytics.h>
#import "CTXUserActivityEvent.h"
#import "CTXUserActivityTiming.h"
#import "CTXUserActivityScreenHit.h"

#import "CTXCustomDefinitionKey.h"

static NSUInteger const kTrackerDispatchIntervalDebug   = 10;
static NSUInteger const kTrackerDispatchIntervalRelease = 120;

@interface CTXSegmentTracker()

@property (nonatomic, strong) SEGAnalytics *tracker;

@end

@implementation CTXSegmentTracker

- (instancetype)initWithTrackingId:(NSString *)trackingId
{
    return [self initWithTrackingId:trackingId debugMode:NO];
}

- (instancetype)initWithTrackingId:(NSString *)trackingId debugMode:(BOOL)debugMode
{
    if (self = [super init]) {
        
        [SEGAnalytics debug:debugMode];
        
        SEGAnalyticsConfiguration *configuration = [SEGAnalyticsConfiguration configurationWithWriteKey:trackingId];
        [configuration setTrackApplicationLifecycleEvents:YES];
        [configuration setTrackDeepLinks:YES];
        [configuration setFlushAt:(debugMode ? kTrackerDispatchIntervalDebug : kTrackerDispatchIntervalRelease)];
        
        
        _tracker = [[SEGAnalytics alloc] initWithConfiguration:configuration];
    }
    
    return self;
}

#pragma mark - CTXUserActivityTrackerProtocol Methods

- (void)trackUserId:(NSString *)userId
{
    [self.tracker identify:userId];
}

- (void)trackScreenHit:(CTXUserActivityScreenHit *)screenHit
{
    NSParameterAssert(screenHit.screenName);
    
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [self _appendCustomDefintionsFromActivity:screenHit toProperties:properties];
    
    [self.tracker screen:screenHit.screenName properties:properties];
}

- (void)trackEvent:(CTXUserActivityEvent *)event
{
    NSParameterAssert(event.category);
    NSParameterAssert(event.action);
    
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [self _appendCustomDefintionsFromActivity:event toProperties:properties];
    
    [properties setObject:event.category forKey:@"category"];
    [properties setObject:event.action forKey:@"action"];
    
    if(event.label.length) {
        [properties setObject:event.label forKey:@"label"];
    }
    
    if(event.value) {
        [properties setObject:event.value forKey:@"value"];
    }
    
    [self.tracker track:event.action properties:properties];
}

- (void)trackTiming:(CTXUserActivityTiming *)timing
{
    NSParameterAssert(timing.category);
    NSParameterAssert(timing.interval);
    
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [self _appendCustomDefintionsFromActivity:timing toProperties:properties];
    
    [properties setObject:timing.category forKey:@"category"];
    [properties setObject:timing.interval forKey:@"interval"];
    
    if(timing.name.length) {
        [properties setObject:timing.label forKey:@"name"];
    }
    
    if(timing.label.length) {
        [properties setObject:timing.label forKey:@"label"];
    }
    
    [self.tracker track:(timing.name.length ? timing.name : timing.category) properties:properties];
}

#pragma mark - Private

- (void)_appendCustomDefintionsFromActivity:(CTXUserActivity *)activity toProperties:(NSMutableDictionary *)properties
{
    [activity.customDimensions enumerateKeysAndObjectsUsingBlock:^(CTXCustomDefinitionKey *customKey, NSString *obj, BOOL *stop) {
        [properties setObject:obj forKey:customKey.name];
    }];
    
    [activity.customMetrics enumerateKeysAndObjectsUsingBlock:^(CTXCustomDefinitionKey *customKey, NSString *obj, BOOL *stop) {
        [properties setObject:obj forKey:customKey.name];
    }];
}

@end

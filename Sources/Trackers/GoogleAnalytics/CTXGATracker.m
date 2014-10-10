//
//  CTXGATracker.m
//  Pods
//
//  Created by Mario Araújo on 06/10/2014.
//  Copyright (c) 2014 EF CTX. All rights reserved.
//  Licensed under the MIT license.

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

@end

@implementation CTXGATracker

- (instancetype)initWithTrackingId:(NSString *)trackingId
{
    if (self = [super init]) {
        [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
        [[GAI sharedInstance] setDispatchInterval:kTrackerDispatchInterval];
        
        self.tracker = [[GAI sharedInstance] trackerWithTrackingId:trackingId];
    }
    
    return self;
}

- (void)setDebugMode:(BOOL)value
{
    _debugMode = value;
    
    [[GAI sharedInstance].logger setLogLevel:value ? kGAILogLevelVerbose : kGAILogLevelError];
}

#pragma mark - CTXUserActivityTrackerProtocol Methods

- (void)trackUserId:(NSString *)userId
{
    [self.tracker set:@"&uid" value:userId];
}

- (void)trackScreenHit:(CTXUserActivityScreenHit *)screenHit
{
    NSParameterAssert(screenHit.screenName);
    
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createScreenView];
    [self configureBuilder:builder withUserActivity:screenHit];
    
    [self.tracker set:kGAIScreenName value:screenHit.screenName];
    [self.tracker send:[builder build]];
}

- (void)trackEvent:(CTXUserActivityEvent *)event
{
    NSParameterAssert(event.category);
    NSParameterAssert(event.action);
    
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createEventWithCategory:event.category
                                                                           action:event.action
                                                                            label:event.label
                                                                            value:event.value];
    [self configureBuilder:builder withUserActivity:event];
    [self.tracker send:[builder build]];
}

- (void)trackTiming:(CTXUserActivityTiming *)timing
{
    NSParameterAssert(timing.category);
    NSParameterAssert(timing.interval);
    
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createTimingWithCategory:timing.category
                                                                          interval:timing.interval
                                                                              name:timing.name
                                                                             label:timing.label];
    [self configureBuilder:builder withUserActivity:timing];
    [self.tracker send:[builder build]];
}

#pragma mark - Private

- (void)configureBuilder:(GAIDictionaryBuilder *)builder withUserActivity:(CTXUserActivity *)userActivity
{
    switch (userActivity.sessionControl) {
        case CTXSessionControlStart:
        {
            [builder set:@"start" forKey:kGAISessionControl];
        } break;
        case CTXSessionControlStop:
        {
            [builder set:@"stop" forKey:kGAISessionControl];
        } break;
        default:
            break;
    }
    
    [userActivity.customDimensions enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [self.tracker set:[GAIFields customDimensionForIndex:[obj integerValue]] value:key];//TODO: check if key is really a number
    }];
    
    [userActivity.customMetrics enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [self.tracker set:[GAIFields customMetricForIndex:[obj integerValue]] value:key];//TODO: check if key is really a number
    }];
}

@end

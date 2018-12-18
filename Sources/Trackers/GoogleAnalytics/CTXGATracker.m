//
//  CTXGATracker.m
//  Pods
//
//  Created by Mario Araújo on 06/10/2014.
//  Copyright (c) 2014 EF CTX. All rights reserved.
//  Licensed under the MIT license.

#import "CTXGATracker.h"

#import <GoogleAnalytics/GAI.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>
#import <GoogleAnalytics/GAIFields.h>
#import "CTXUserActivityEvent.h"
#import "CTXUserActivityTiming.h"
#import "CTXUserActivityScreenHit.h"
#import "CTXCustomDefinitionKey.h"

static NSUInteger const kTrackerDispatchIntervalDebug   = 10;
static NSUInteger const kTrackerDispatchIntervalRelease = 120;

@interface CTXGATracker()

@property (nonatomic, strong) id<GAITracker> tracker;

@end

@implementation CTXGATracker

- (instancetype)initWithTrackingId:(NSString *)trackingId
{
    return [self initWithTrackingId:trackingId debugMode:NO];
}

- (instancetype)initWithTrackingId:(NSString *)trackingId debugMode:(BOOL)debugMode
{
    if (self = [super init]) {
        [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
        [[GAI sharedInstance] setDispatchInterval:kTrackerDispatchIntervalRelease];
        
        self.tracker = [[GAI sharedInstance] trackerWithTrackingId:trackingId];
        
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
        [self.tracker set:kGAIAppVersion value:version];
        
        [self setSampleRate:1.0f];
        
        [[GAI sharedInstance] setDispatchInterval: (debugMode ? kTrackerDispatchIntervalDebug : kTrackerDispatchIntervalRelease)];
        [[GAI sharedInstance].logger setLogLevel:(debugMode ? kGAILogLevelVerbose : kGAILogLevelError)];
    }
    
    return self;
}

- (void)setSampleRate:(CGFloat)sampleRate
{
    CGFloat value = sampleRate;
    value = MIN(value, 1);
    value = MAX(value, 0);
    
    _sampleRate = value;
    
    [self.tracker set:kGAISampleRate value:[@(value*100) stringValue]];
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

    NSString *label = event.label;
    NSMutableDictionary *properties = event.properties.mutableCopy;
    if(properties) {
        
        if(label.length) {
            [properties setObject:label forKey:@"label"];
        }
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:properties options:0 error:&error];
        if (jsonData) {
            label = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        } else {
            NSLog(@"Could not encode event properties with error %@", error);
        }
    }
    
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createEventWithCategory:event.category
                                                                           action:event.action
                                                                            label:label
                                                                            value:event.value];
    [self configureBuilder:builder withUserActivity:event];
    [self.tracker send:[builder build]];
}

- (void)trackTiming:(CTXUserActivityTiming *)timing
{
    NSParameterAssert(timing.category);
    NSParameterAssert(timing.interval);
    
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createTimingWithCategory:timing.category
                                                                          interval:@((int)([timing.interval floatValue]*1000))//sec to millisec
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
    
    [userActivity.customDimensions enumerateKeysAndObjectsUsingBlock:^(CTXCustomDefinitionKey *customKey, NSString *obj, BOOL *stop) {
		if ([customKey.key integerValue] != 0) {//Custom index begin from 1, and invalid convertion will return 0
			[self.tracker set:[GAIFields customDimensionForIndex:[customKey.key integerValue]] value:obj];
		} else {
			NSLog(@"[CTXGATracker] Fail to track custom dimension with invalid index:%@ with value:%@", customKey, obj);
		}
    }];
    
    [userActivity.customMetrics enumerateKeysAndObjectsUsingBlock:^(CTXCustomDefinitionKey *customKey, NSString *obj, BOOL *stop) {
		if ([customKey.key integerValue] != 0) {//Custom index begin from 1, and invalid convertion will return 0
			[self.tracker set:[GAIFields customMetricForIndex:[customKey.key integerValue]] value:obj];
		} else {
			NSLog(@"[CTXGATracker] Fail to track custom metric with invalid index:%@ with value:%@", customKey, obj);
		}
    }];
}

@end

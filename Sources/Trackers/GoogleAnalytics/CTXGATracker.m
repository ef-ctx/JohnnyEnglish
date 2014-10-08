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

- (void)trackScreenHit:(CTXUserActivityScreenHit *)screenHit
{
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createScreenView];
    [self configureBuilder:builder withUserActivity:screenHit];
    
    [self.tracker set:kGAIScreenName value:screenHit.screenName];
    [self.tracker send:[builder build]];
}

- (void)trackEvent:(CTXUserActivityEvent *)event
{
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createEventWithCategory:event.category
                                                                           action:event.action
                                                                            label:event.label
                                                                            value:event.value];
    [self configureBuilder:builder withUserActivity:event];
    [self.tracker send:[builder build]];
}

- (void)trackTiming:(CTXUserActivityTiming *)timing
{
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

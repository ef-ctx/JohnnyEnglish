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

static NSUInteger const kTrackerDispatchInterval 120

@interface CTXGATracker()

@property (nonatomic, weak) id<GAITracker> tracker;

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

- (void)trackScreenHitWithName:(NSString *)screenName
{
    [self.tracker send:[[[GAIDictionaryBuilder createAppView] set:screenName forKey:kGAIScreenName] build]];
}

- (void)trackEvent:(id<CTXUserActivityEventProtocol>)event
{
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:[event category]
                                                               action:[event action]
                                                                label:[event label]
                                                                value:[event value]] build]];
}

@end

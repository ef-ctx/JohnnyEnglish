//
//  CTXUserActivityTrackingManager.m
//  CTXFramework
//
//  Created by Alberto De Bortoli on 29/01/2014.
//  Copyright (c) 2014 EF. All rights reserved.
//

#import "CTXUserActivityTrackingManager.h"

#import "CTXUserActivityTrackerProtocol.h"
#import "CTXUserActivityButtonPressedEvent.h"

#import "Aspects.h"

static NSString *const CTXUserActivityTrackingManagerConfigurationTrackedScreens        = @"trackedScreens";
static NSString *const CTXUserActivityTrackingManagerConfigurationTrackedEvents         = @"trackedEvents";
static NSString *const CTXUserActivityTrackingManagerConfigurationTrackedClass          = @"class";
static NSString *const CTXUserActivityTrackingManagerConfigurationTrackedScreenName     = @"screenName";
static NSString *const CTXUserActivityTrackingManagerConfigurationTrackedEventSelector  = @"selector";
static NSString *const CTXUserActivityTrackingManagerConfigurationTrackedEventLabel     = @"label";


@interface CTXUserActivityTrackingManager ()

@property (nonatomic, strong) NSMutableArray *trackers;

@end


@implementation CTXUserActivityTrackingManager
{
    dispatch_queue_t _workingQueue;
}

- (instancetype)init
{
    if (self = [super init]) {
        _trackers = [NSMutableArray array];
        _workingQueue = dispatch_queue_create("com.ef.ctx.framework.userActivityTrackingManager.workingQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

- (void)setupWithConfiguration:(NSDictionary *)configuration
{
    for (NSDictionary *trackedScreen in configuration[CTXUserActivityTrackingManagerConfigurationTrackedScreens]) {
        
        Class clazz = NSClassFromString(trackedScreen[CTXUserActivityTrackingManagerConfigurationTrackedClass]);

        NSError *error = nil;
        [clazz aspect_hookSelector:@selector(viewDidAppear:)
                       withOptions:AspectPositionAfter
                        usingBlock:^(id<AspectInfo> invocation) {
                            dispatch_async(_workingQueue, ^{
                                NSString *viewName = trackedScreen[CTXUserActivityTrackingManagerConfigurationTrackedScreenName];
                                for (id<CTXUserActivityTrackerProtocol> tracker in self.trackers) {
                                    [tracker trackScreenHitWithName:viewName];
                                }
                            });
                        }
                             error:&error];
    }
    
    for (NSDictionary *trackedEvents in configuration[CTXUserActivityTrackingManagerConfigurationTrackedEvents]) {
        
        Class clazz = NSClassFromString(trackedEvents[CTXUserActivityTrackingManagerConfigurationTrackedClass]);
        SEL selektor = NSSelectorFromString(trackedEvents[CTXUserActivityTrackingManagerConfigurationTrackedEventSelector]);

        NSError *error = nil;
        [clazz aspect_hookSelector:selektor
                       withOptions:AspectPositionBefore
                        usingBlock:^(id<AspectInfo> invocation) {
                            dispatch_async(_workingQueue, ^{
                                CTXUserActivityButtonPressedEvent *buttonPressEvent = [CTXUserActivityButtonPressedEvent eventWithLabel:trackedEvents[CTXUserActivityTrackingManagerConfigurationTrackedEventLabel]];
                                for (id<CTXUserActivityTrackerProtocol> tracker in self.trackers) {
                                    [tracker trackEvent:buttonPressEvent];
                                }
                            });
                        }
                             error:&error];
    }
}

- (void)registerTracker:(id<CTXUserActivityTrackerProtocol>)tracker
{
    if ([tracker conformsToProtocol:@protocol(CTXUserActivityTrackerProtocol)]) {
        [self.trackers addObject:tracker];
    }
}

@end

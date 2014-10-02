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

static NSString *const CTXUserActivityTrackingManagerConfigurationScreens = @"trackedScreens";
static NSString *const CTXUserActivityTrackingManagerConfigurationEvents = @"trackedEvents";
static NSString *const CTXUserActivityTrackingManagerConfigurationClass = @"class";
static NSString *const CTXUserActivityTrackingManagerConfigurationScreenName = @"screenName";
static NSString *const CTXUserActivityTrackingManagerConfigurationEventSelector = @"selector";
static NSString *const CTXUserActivityTrackingManagerConfigurationEventLabel = @"label";


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
    for (NSDictionary *trackedScreen in configuration[CTXUserActivityTrackingManagerConfigurationScreens]) {
        
        Class clazz = NSClassFromString(trackedScreen[CTXUserActivityTrackingManagerConfigurationClass]);

        NSError *error = nil;
        [clazz aspect_hookSelector:@selector(viewDidAppear:)
                       withOptions:AspectPositionAfter
                        usingBlock:^(id<AspectInfo> invocation) {
                            dispatch_async(_workingQueue, ^{
                                NSString *viewName = trackedScreen[CTXUserActivityTrackingManagerConfigurationScreenName];
                                for (id<CTXUserActivityTrackerProtocol> tracker in self.trackers) {
                                    [tracker trackScreenHitWithName:viewName];
                                }
                            });
                        }
                             error:&error];
    }
    
    for (NSDictionary *trackedEvents in configuration[CTXUserActivityTrackingManagerConfigurationEvents]) {
        
        Class clazz = NSClassFromString(trackedEvents[CTXUserActivityTrackingManagerConfigurationClass]);
        SEL selektor = NSSelectorFromString(trackedEvents[CTXUserActivityTrackingManagerConfigurationEventSelector]);

        NSError *error = nil;
        [clazz aspect_hookSelector:selektor
                       withOptions:AspectPositionBefore
                        usingBlock:^(id<AspectInfo> invocation) {
                            dispatch_async(_workingQueue, ^{
                                CTXUserActivityButtonPressedEvent *buttonPressEvent = [CTXUserActivityButtonPressedEvent eventWithLabel:trackedEvents[CTXUserActivityTrackingManagerConfigurationEventLabel]];
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

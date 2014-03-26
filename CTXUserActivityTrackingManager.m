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

#import "CTXLog.h"

#import "AOPAspect.h"

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
    if ((self = [super init])) {
        _trackers = [NSMutableArray array];
        _workingQueue = dispatch_queue_create("com.ef.ctx.framework.userActivityTrackingManager.workingQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

- (void)setupWithConfiguration:(NSDictionary *)configuration
{
    for (NSDictionary *trackedScreen in configuration[CTXUserActivityTrackingManagerConfigurationTrackedScreens]) {
        
        Class clazz = NSClassFromString(trackedScreen[CTXUserActivityTrackingManagerConfigurationTrackedClass]);

        [[AOPAspect instance] interceptClass:clazz
                      afterExecutingSelector:@selector(viewDidAppear:)
                                  usingBlock:^(NSInvocation *invocation) {
            dispatch_async(_workingQueue, ^{
                NSString *viewName = trackedScreen[CTXUserActivityTrackingManagerConfigurationTrackedScreenName];
                for (id<CTXUserActivityTrackerProtocol> tracker in self.trackers) {
                    [tracker trackScreenHitWithName:viewName];
                }
                
                CTXLogInfo(CTXLogContextAppTrace, @"[Tracking] view from class %@ has been shown.", clazz);
            });
        }];
        
    }
    
    for (NSDictionary *trackedEvents in configuration[CTXUserActivityTrackingManagerConfigurationTrackedEvents]) {
        
        Class clazz = NSClassFromString(trackedEvents[CTXUserActivityTrackingManagerConfigurationTrackedClass]);
        SEL selektor = NSSelectorFromString(trackedEvents[CTXUserActivityTrackingManagerConfigurationTrackedEventSelector]);
        
        [[AOPAspect instance] interceptClass:clazz
                      afterExecutingSelector:selektor
                                  usingBlock:^(NSInvocation *invocation) {
            dispatch_async(_workingQueue, ^{
                CTXUserActivityButtonPressedEvent *buttonPressEvent = [CTXUserActivityButtonPressedEvent eventWithLabel:trackedEvents[CTXUserActivityTrackingManagerConfigurationTrackedEventLabel]];
                for (id<CTXUserActivityTrackerProtocol> tracker in self.trackers) {
                    [tracker trackEvent:buttonPressEvent];
                }
                
                CTXLogInfo(CTXLogContextAppTrace, @"[Tracking] method %@ from class %@ has been called.", NSStringFromSelector(selektor), clazz);
            });
        }];
        
    }
}

- (void)registerTracker:(id<CTXUserActivityTrackerProtocol>)tracker
{
    if ([tracker conformsToProtocol:@protocol(CTXUserActivityTrackerProtocol)]) {
        [self.trackers addObject:tracker];
    }
}

@end

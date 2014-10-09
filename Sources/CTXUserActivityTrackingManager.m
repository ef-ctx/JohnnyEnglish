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

//static NSString *const CTXUserActivityTrackingManagerConfigurationScreens = @"trackedScreens";
//static NSString *const CTXUserActivityTrackingManagerConfigurationEvents = @"trackedEvents";
//static NSString *const CTXUserActivityTrackingManagerConfigurationClass = @"class";
//static NSString *const CTXUserActivityTrackingManagerConfigurationScreenName = @"screenName";
//static NSString *const CTXUserActivityTrackingManagerConfigurationEventSelector = @"selector";
//static NSString *const CTXUserActivityTrackingManagerConfigurationEventLabel = @"label";

static NSString *const CTXTrackTimerStartDate           = @"startTimer";
static NSString *const CTXTrackTimerStartMethodInfo     = @"startMethodInfo";



@interface CTXUserActivityTrackingManager ()

@property (nonatomic, strong) NSMutableArray *trackers;

@property (nonatomic, strong) NSMutableDictionary *timerTrackers;

@end


@implementation CTXUserActivityTrackingManager
{
    dispatch_queue_t _workingQueue;
}

- (instancetype)init
{
    if (self = [super init]) {
        _trackers = [NSMutableArray array];
        _timerTrackers = [NSMutableDictionary dictionary];
        _workingQueue = dispatch_queue_create("com.ef.ctx.framework.userActivityTrackingManager.workingQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

- (void)registerScreenTrackerFromClass:(Class)clazz screenName:(NSString *)screenName error:(NSError *)error
{
    [clazz aspect_hookSelector:@selector(viewDidAppear:)
                   withOptions:AspectPositionAfter
                    usingBlock:^(id<AspectInfo> invocation) {
                        dispatch_async(_workingQueue, ^{
                            for (id<CTXUserActivityTrackerProtocol> tracker in self.trackers) {
                                [tracker trackScreenHitWithName:screenName];
                            }
                        });
                    }
                         error:&error];
}

- (void)registerEventTrackerFromClass:(Class)clazz selector:(SEL)selektor event:(id<CTXUserActivityEventProtocol>)event error:(NSError *)error
{
    [clazz aspect_hookSelector:selektor
                   withOptions:AspectPositionBefore
                    usingBlock:^(id<AspectInfo> invocation) {
                        dispatch_async(_workingQueue, ^{
                            for (id<CTXUserActivityTrackerProtocol> tracker in self.trackers) {
                                [tracker trackEvent:event];
                            }
                        });
                    }
                         error:&error];
}

- (void)registerEventTrackerFromClass:(Class)clazz selector:(SEL)selektor eventCallback:(id<CTXUserActivityEventProtocol> (^)(id<CTXMethodCallInfo> callInfo))eventCallback error:(NSError *)error
{
    [clazz aspect_hookSelector:selektor
                   withOptions:AspectPositionBefore
                    usingBlock:^(id<AspectInfo> invocation) {
                        dispatch_async(_workingQueue, ^{
                            for (id<CTXUserActivityTrackerProtocol> tracker in self.trackers) {
                                [tracker trackEvent:eventCallback((id<CTXMethodCallInfo>)invocation)];
                            }
                        });
                    }
                         error:&error];
}

- (void)registerStartTimerTrackerFromClass:(Class)clazz selector:(SEL)selektor timerUUIDCallback:(NSString * (^)(id<CTXMethodCallInfo> callInfo))uuidCallback error:(NSError *)error
{
    __weak typeof(self) weakSelf = self;
    
    [clazz aspect_hookSelector:selektor
                   withOptions:AspectPositionBefore
                    usingBlock:^(id<AspectInfo> invocation) {
                        dispatch_async(_workingQueue, ^{
                            NSString *uuid = uuidCallback((id<CTXMethodCallInfo>)invocation);
                            //TODO: Should check if the timer already exist and log to the user?
                            
                            weakSelf.timerTrackers[uuid] = @{CTXTrackTimerStartDate:[NSDate new], CTXTrackTimerStartMethodInfo:(id<CTXMethodCallInfo>)invocation} ;
                        });
                    }
                         error:&error];
}

- (void)registerStopTimerTrackerFromClass:(Class)clazz selector:(SEL)selektor
                        timerUUIDCallback:(NSString * (^)(id<CTXMethodCallInfo> callInfo))uuidCallback
                            eventCallback:(id<CTXUserActivityEventProtocol> (^)(id<CTXMethodCallInfo> startMethodCallInfo, id<CTXMethodCallInfo> stopMethodCallInfo, NSTimeInterval duration))eventCallback
                                    error:(NSError *)error
{
    __weak typeof(self) weakSelf = self;
    
    [clazz aspect_hookSelector:selektor
                   withOptions:AspectPositionBefore
                    usingBlock:^(id<AspectInfo> invocation) {
                        dispatch_async(_workingQueue, ^{
                            NSString *uuid = uuidCallback((id<CTXMethodCallInfo>)invocation);
                            
                            NSDictionary *startInfo = weakSelf.timerTrackers[uuid];
                            
                            if (!startInfo) {
                                NSLog(@"WARNING: [%@] Stop timer without a proper start with uuid %@", NSStringFromSelector(_cmd), uuid);
                                return;
                            }
                            
                            NSTimeInterval duration = [startInfo[CTXTrackTimerStartDate] timeIntervalSinceDate:[NSDate new]];
                            
                            for (id<CTXUserActivityTrackerProtocol> tracker in self.trackers) {
                                [tracker trackEvent:eventCallback(startInfo[CTXTrackTimerStartMethodInfo], (id<CTXMethodCallInfo>)invocation, duration)];
                            }
                        });
                    }
                         error:&error];
}

- (void)registerTimeTrackerFromClass:(Class)clazz
                       startSelector:(SEL)startSelektor
                        stopSelector:(SEL)stopSelektor
                       eventCallback:(id<CTXUserActivityEventProtocol> (^)(id<CTXMethodCallInfo> startMethodCallInfo, id<CTXMethodCallInfo> stopMethodCallInfo, NSTimeInterval duration))eventCallback
                               error:(NSError *)error
{
    NSString *(^timerCallback)(id<CTXMethodCallInfo> callInfo) = ^NSString *(id<CTXMethodCallInfo> callInfo){
        return [NSString stringWithFormat:@"%lu|%@|%@", (unsigned long)[[callInfo instance] hash], NSStringFromSelector(startSelektor), NSStringFromSelector(stopSelektor)];
    };
    
    [self registerStartTimerTrackerFromClass:clazz
                                    selector:startSelektor
                           timerUUIDCallback:timerCallback
                                       error:error];
    
    if (error)
        return;
    
    [self registerStopTimerTrackerFromClass:clazz
                                   selector:stopSelektor
                          timerUUIDCallback:timerCallback
                              eventCallback:eventCallback
                                      error:error];
}



//- (void)setupWithConfiguration:(NSDictionary *)configuration
//{
//    for (NSDictionary *trackedScreen in configuration[CTXUserActivityTrackingManagerConfigurationScreens]) {
//        
//        Class clazz = NSClassFromString(trackedScreen[CTXUserActivityTrackingManagerConfigurationClass]);
//
//        NSError *error = nil;
//        [clazz aspect_hookSelector:@selector(viewDidAppear:)
//                       withOptions:AspectPositionAfter
//                        usingBlock:^(id<AspectInfo> invocation) {
//                            dispatch_async(_workingQueue, ^{
//                                NSString *viewName = trackedScreen[CTXUserActivityTrackingManagerConfigurationScreenName];
//                                for (id<CTXUserActivityTrackerProtocol> tracker in self.trackers) {
//                                    [tracker trackScreenHitWithName:viewName];
//                                }
//                            });
//                        }
//                             error:&error];
//    }
//    
//    for (NSDictionary *trackedEvents in configuration[CTXUserActivityTrackingManagerConfigurationEvents]) {
//        
//        Class clazz = NSClassFromString(trackedEvents[CTXUserActivityTrackingManagerConfigurationClass]);
//        SEL selektor = NSSelectorFromString(trackedEvents[CTXUserActivityTrackingManagerConfigurationEventSelector]);
//
//        NSError *error = nil;
//        [clazz aspect_hookSelector:selektor
//                       withOptions:AspectPositionBefore
//                        usingBlock:^(id<AspectInfo> invocation) {
//                            dispatch_async(_workingQueue, ^{
//                                CTXUserActivityButtonPressedEvent *buttonPressEvent = [CTXUserActivityButtonPressedEvent eventWithLabel:trackedEvents[CTXUserActivityTrackingManagerConfigurationEventLabel]];
//                                for (id<CTXUserActivityTrackerProtocol> tracker in self.trackers) {
//                                    [tracker trackEvent:buttonPressEvent];
//                                }
//                            });
//                        }
//                             error:&error];
//    }
//}

- (void)registerTracker:(id<CTXUserActivityTrackerProtocol>)tracker
{
    if ([tracker conformsToProtocol:@protocol(CTXUserActivityTrackerProtocol)]) {
        [self.trackers addObject:tracker];
    }
}

@end

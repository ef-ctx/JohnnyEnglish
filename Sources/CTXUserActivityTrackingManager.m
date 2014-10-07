//
//  CTXUserActivityTrackingManager.m
//  JohnnyEnglish
//
//  Created by Alberto De Bortoli on 29/01/2014.
//  Copyright (c) 2014 EF CTX. All rights reserved.
//  Licensed under the MIT license.
//

#import "CTXUserActivityTrackingManager.h"

#import "CTXUserActivityTrackerProtocol.h"

#import "CTXUserActivityEvent.h"
#import "CTXUserActivityTiming.h"
#import "CTXUserActivityScreenHit.h"

#import "Aspects.h"

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
        _workingQueue = dispatch_queue_create("com.ef.ctx.user-activity-tracking-manager", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

- (void)registerUserIdFromClass:(Class)clazz selector:(SEL)selektor userIdCallback:(NSString * (^)(id<CTXMethodCallInfo> callInfo))userIdCallback error:(NSError **)error
{
    [clazz aspect_hookSelector:selektor
                   withOptions:AspectPositionAfter
                    usingBlock:^(id<AspectInfo> invocation) {
                        dispatch_async(_workingQueue, ^{
                            for (id<CTXUserActivityTrackerProtocol> tracker in self.trackers) {
                                [tracker trackUserId:userIdCallback((id<CTXMethodCallInfo>) invocation)];
                            }
                        });
                    }
                         error:error];
}

- (void)registerStartSessionFromClass:(Class)clazz screenName:(NSString *)screenName error:(NSError **)error
{
    [clazz aspect_hookSelector:@selector(viewDidAppear:)
                   withOptions:AspectPositionAfter
                    usingBlock:^(id<AspectInfo> invocation) {
                        dispatch_async(_workingQueue, ^{
                            for (id<CTXUserActivityTrackerProtocol> tracker in self.trackers) {
                                [tracker startSessionWithScreenHit:screenName];
                            }
                        });
                    }
                         error:error];
}

- (void)registerStopSessionFromClass:(Class)clazz selector:(SEL)selektor error:(NSError **)error
{
    [clazz aspect_hookSelector:selektor
                   withOptions:AspectPositionAfter
                    usingBlock:^(id<AspectInfo> invocation) {
                        dispatch_async(_workingQueue, ^{
                            for (id<CTXUserActivityTrackerProtocol> tracker in self.trackers) {
                                [tracker stopSession];
                            }
                        });
                    }
                         error:error];
}

- (void)registerScreenTrackerFromClass:(Class)clazz screenCallback:(CTXUserActivityScreenHit * (^)(id<CTXMethodCallInfo> callInfo))screenCallback error:(NSError **)error
{
    [clazz aspect_hookSelector:@selector(viewDidAppear:)
                   withOptions:AspectPositionAfter
                    usingBlock:^(id<AspectInfo> invocation) {
                        dispatch_async(_workingQueue, ^{
                            for (id<CTXUserActivityTrackerProtocol> tracker in self.trackers) {
                                [tracker trackScreenHit:screenCallback((id<CTXMethodCallInfo>)invocation)];
                            }
                        });
                    }
                         error:error];
}

- (void)registerEventTrackerFromClass:(Class)clazz selector:(SEL)selektor event:(CTXUserActivityEvent *)event error:(NSError **)error
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
                         error:error];
}

- (void)registerEventTrackerFromClass:(Class)clazz selector:(SEL)selektor eventCallback:(CTXUserActivityEvent * (^)(id<CTXMethodCallInfo> callInfo))eventCallback error:(NSError **)error
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
                         error:error];
}

- (void)registerStartTimerTrackerFromClass:(Class)clazz selector:(SEL)selektor timerUUIDCallback:(NSString * (^)(id<CTXMethodCallInfo> callInfo))uuidCallback error:(NSError **)error
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
                         error:error];
}

- (void)registerStopTimerTrackerFromClass:(Class)clazz selector:(SEL)selektor
                        timerUUIDCallback:(NSString * (^)(id<CTXMethodCallInfo> callInfo))uuidCallback
                            eventCallback:(CTXUserActivityTiming * (^)(id<CTXMethodCallInfo> startMethodCallInfo, id<CTXMethodCallInfo> stopMethodCallInfo, NSTimeInterval duration))eventCallback
                                    error:(NSError **)error
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
                                [tracker trackTiming:eventCallback(startInfo[CTXTrackTimerStartMethodInfo], (id<CTXMethodCallInfo>)invocation, duration)];
                            }
                        });
                    }
                         error:error];
}

- (void)registerTimeTrackerFromClass:(Class)clazz
                       startSelector:(SEL)startSelektor
                        stopSelector:(SEL)stopSelektor
                       eventCallback:(CTXUserActivityTiming * (^)(id<CTXMethodCallInfo> startMethodCallInfo, id<CTXMethodCallInfo> stopMethodCallInfo, NSTimeInterval duration))eventCallback
                               error:(NSError **)error
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



- (void)registerTracker:(id<CTXUserActivityTrackerProtocol>)tracker
{
    if ([tracker conformsToProtocol:@protocol(CTXUserActivityTrackerProtocol)]) {
        [self.trackers addObject:tracker];
    }
}

@end

//
//  CTXUserActivityTrackingManager.h
//  JohnnyEnglish
//
//  Created by Alberto De Bortoli on 29/01/2014.
//  Copyright (c) 2014 EF CTX. All rights reserved.
//  Licensed under the MIT license.
//

#import <Foundation/Foundation.h>
#import "CTXUserActivityEvent.h"
#import "CTXUserActivityScreenHit.h"
#import "CTXUserActivityTiming.h"


@protocol CTXMethodCallInfo <NSObject>

- (id)instance;
- (NSInvocation *)originalInvocation;
- (NSArray *)arguments;

@end


@protocol CTXUserActivityTrackerProtocol;

@interface CTXUserActivityTrackingManager : NSObject

- (void)registerTracker:(id<CTXUserActivityTrackerProtocol>)tracker;

- (void)registerUserIdFromClass:(Class)clazz selector:(SEL)selektor userIdCallback:(NSString * (^)(id<CTXMethodCallInfo> callInfo))userIdCallback error:(NSError **)error;

- (void)registerScreenTrackerFromClass:(Class)clazz screenCallback:(CTXUserActivityScreenHit * (^)(id<CTXMethodCallInfo> callInfo))screenCallback error:(NSError **)error;

- (void)registerEventTrackerFromClass:(Class)clazz selector:(SEL)selektor event:(CTXUserActivityEvent *)event error:(NSError **)error;
- (void)registerEventTrackerFromClass:(Class)clazz selector:(SEL)selektor eventCallback:(CTXUserActivityEvent * (^)(id<CTXMethodCallInfo> callInfo))eventCallback error:(NSError **)error;

- (void)registerStartTimerTrackerFromClass:(Class)clazz selector:(SEL)selektor timerUUIDCallback:(NSString * (^)(id<CTXMethodCallInfo> callInfo))uuidCallback error:(NSError **)error;
- (void)registerStopTimerTrackerFromClass:(Class)clazz selector:(SEL)selektor
                        timerUUIDCallback:(NSString * (^)(id<CTXMethodCallInfo> callInfo))uuidCallback
                            eventCallback:(CTXUserActivityTiming * (^)(id<CTXMethodCallInfo> startMethodCallInfo, id<CTXMethodCallInfo> stopMethodCallInfo, NSTimeInterval duration))eventCallback
                                    error:(NSError **)error;
- (void)registerTimeTrackerFromClass:(Class)clazz
                       startSelector:(SEL)startSelektor
                        stopSelector:(SEL)stopSelektor
                       eventCallback:(CTXUserActivityTiming * (^)(id<CTXMethodCallInfo> startMethodCallInfo, id<CTXMethodCallInfo> stopMethodCallInfo, NSTimeInterval duration))eventCallback
                               error:(NSError **)error;

@end

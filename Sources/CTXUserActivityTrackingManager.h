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

@interface CTXMethodCallInfo : NSObject

@property (strong, nonatomic) id instance;
@property (strong, nonatomic) NSInvocation * originalInvocation;
@property (strong, nonatomic) NSArray * arguments;

- (instancetype)initWithInstance:(id)instance args:(NSArray *)args;

@end


@protocol CTXUserActivityTrackerProtocol;

@interface CTXUserActivityTrackingManager : NSObject

- (void)registerTracker:(id<CTXUserActivityTrackerProtocol>)tracker;

- (void)registerUserIdFromClass:(Class)clazz selector:(SEL)selektor userIdCallback:(NSString * (^)(CTXMethodCallInfo *callInfo))userIdCallback error:(NSError **)error;

- (void)registerScreenTrackerFromClass:(Class)clazz screenName:(NSString *)screenName error:(NSError **)error;
- (void)registerScreenTrackerFromClass:(Class)clazz screenCallback:(CTXUserActivityScreenHit * (^)(CTXMethodCallInfo *callInfo))screenCallback error:(NSError **)error;

- (void)registerEventTrackerFromClass:(Class)clazz selector:(SEL)selektor event:(CTXUserActivityEvent *)event error:(NSError **)error;
- (void)registerEventTrackerFromClass:(Class)clazz selector:(SEL)selektor eventCallback:(CTXUserActivityEvent * (^)(CTXMethodCallInfo *callInfo))eventCallback error:(NSError **)error;

- (void)registerStartTimerTrackerFromClass:(Class)clazz selector:(SEL)selektor timerUUIDCallback:(NSString * (^)(CTXMethodCallInfo *callInfo))uuidCallback error:(NSError **)error;
- (void)registerStopTimerTrackerFromClass:(Class)clazz selector:(SEL)selektor
                        timerUUIDCallback:(NSString * (^)(CTXMethodCallInfo *callInfo))uuidCallback
                            eventCallback:(CTXUserActivityTiming * (^)(CTXMethodCallInfo *startMethodCallInfo, CTXMethodCallInfo *stopMethodCallInfo, NSTimeInterval duration))eventCallback
                                    error:(NSError **)error;
- (void)registerTimeTrackerFromClass:(Class)clazz
                       startSelector:(SEL)startSelektor
                        stopSelector:(SEL)stopSelektor
                       eventCallback:(CTXUserActivityTiming * (^)(CTXMethodCallInfo *startMethodCallInfo, CTXMethodCallInfo *stopMethodCallInfo, NSTimeInterval duration))eventCallback
                               error:(NSError **)error;

@end

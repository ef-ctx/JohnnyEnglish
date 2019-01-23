//
//  CTXUserActivityTrackingManager.h
//  JohnnyEnglish
//
//  Created by Alberto De Bortoli on 29/01/2014.
//  Copyright (c) 2014 EF CTX. All rights reserved.
//  Licensed under the MIT license.
//

#import "CTXUserActivityTrackerProtocol.h"

@class CTXUserActivityEvent;
@class CTXUserActivityScreenHit;
@class CTXUserActivityTiming;
@class CTXUserActivityUser;
@class CTXCustomDefinitionKey;

@class CTXMethodCallInfo;

@interface CTXUserActivityTrackingManager : NSObject <CTXUserActivityTrackerProtocol>

- (void)registerTracker:(id<CTXUserActivityTrackerProtocol>)tracker;

- (void)registerUserFromClass:(Class)clazz selector:(SEL)selektor userCallback:(CTXUserActivityUser * (^)(CTXMethodCallInfo *callInfo))userCallback error:(NSError **)error;

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

- (void)setGlobalDimension:(id)globalDimension forKey:(CTXCustomDefinitionKey *)key;
- (void)removeGlobalDimensionForKey:(CTXCustomDefinitionKey *)key;

- (void)setGlobalMetric:(id)globalMetric forKey:(CTXCustomDefinitionKey *)key;
- (void)removeGlobalMetricForKey:(CTXCustomDefinitionKey *)key;

@end

@interface CTXMethodCallInfo : NSObject

@property (strong, nonatomic, readonly) id instance;
@property (strong, nonatomic, readonly) NSInvocation * originalInvocation;
@property (strong, nonatomic, readonly) NSArray * arguments;

@end

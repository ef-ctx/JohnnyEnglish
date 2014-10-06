//
//  CTXUserActivityTrackingManager.h
//  JohnnyEnglish
//
//  Created by Alberto De Bortoli on 29/01/2014.
//  Copyright (c) 2014 EF CTX. All rights reserved.
//  Licensed under the MIT license.
//

#import <Foundation/Foundation.h>


@protocol CTXMethodCallInfo <NSObject>

- (id)instance;
- (NSInvocation *)originalInvocation;
- (NSArray *)arguments;

@end


@protocol CTXUserActivityTrackerProtocol;

@interface CTXUserActivityTrackingManager : NSObject

//- (void)setupWithConfiguration:(NSDictionary *)configuration;

- (void)registerTracker:(id<CTXUserActivityTrackerProtocol>)tracker;

@end

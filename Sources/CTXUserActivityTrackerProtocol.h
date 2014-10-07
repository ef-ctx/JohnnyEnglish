//
//  CTXUserActivityTrackerProtocol.h
//  JohnnyEnglish
//
//  Created by Alberto De Bortoli on 29/01/2014.
//  Copyright (c) 2014 EF CTX. All rights reserved.
//  Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

@class CTXUserActivityTiming;
@class CTXUserActivityEvent;
@class CTXUserActivityScreenHit;

@protocol CTXUserActivityTrackerProtocol <NSObject>

@optional

- (void)startSessionWithScreenHit:(NSString *)screenName;
- (void)stopSession;

- (void)trackUserId:(NSString *)userId;

- (void)trackScreenHit:(CTXUserActivityScreenHit *)screenHit;
- (void)trackEvent:(CTXUserActivityEvent *)event;
- (void)trackTiming:(CTXUserActivityTiming *)timing;


@end

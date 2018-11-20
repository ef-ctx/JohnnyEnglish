//
//  CTXSegmentTracker.h
//  JohnnyEnglish
//
//  Created by Stefan Ceriu on 20/11/2018.
//  Copyright (c) 2018 EF CTX. All rights reserved.
//  Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "CTXUserActivityTrackerProtocol.h"

@interface CTXSegmentTracker : NSObject<CTXUserActivityTrackerProtocol>

- (instancetype)initWithTrackingId:(NSString *)trackingId;

- (instancetype)initWithTrackingId:(NSString *)trackingId debugMode:(BOOL)debugMode;

@end

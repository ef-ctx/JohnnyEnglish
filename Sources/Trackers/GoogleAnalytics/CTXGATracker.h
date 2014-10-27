//
//  CTXGATracker.h
//  Pods
//
//  Created by Mario Araújo on 06/10/2014.
//  Copyright (c) 2014 EF CTX. All rights reserved.
//  Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "CTXUserActivityTrackerProtocol.h"

@interface CTXGATracker : NSObject<CTXUserActivityTrackerProtocol>

@property (assign, nonatomic) BOOL debugMode;
@property (assign, nonatomic) CGFloat sampleRate;//[0-1]

- (id)initWithTrackingId:(NSString *)trackingId;

@end

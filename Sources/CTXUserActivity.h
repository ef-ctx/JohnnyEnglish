//
//  CTXUserActivity.h
//  Pods
//
//  Created by Mario Araújo on 07/10/2014.
//  Copyright (c) 2014 EF CTX. All rights reserved.
//  Licensed under the MIT license.

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    CTXSessionControlNone,
    CTXSessionControlStart,
    CTXSessionControlStop,
} CTXUserActivitySessionControl;


@interface CTXUserActivity : NSObject

@property (strong, nonatomic, readonly) NSMutableDictionary *customDimensions;
@property (strong, nonatomic, readonly) NSMutableDictionary *customMetrics;
@property (assign, nonatomic) CTXUserActivitySessionControl sessionControl;

- (void)setCustomDimension:(NSString *)dimension withValue:(NSString *)value;
- (void)setCustomMetric:(NSString *)dimension withValue:(NSString *)value;

@end

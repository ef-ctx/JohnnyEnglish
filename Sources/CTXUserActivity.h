//
//  CTXUserActivity.h
//  Pods
//
//  Created by Mario Araújo on 07/10/2014.
//  Copyright (c) 2014 EF CTX. All rights reserved.
//  Licensed under the MIT license.

#import <Foundation/Foundation.h>

@class CTXCustomDefinitionKey;

typedef enum : NSUInteger {
    CTXSessionControlNone,
    CTXSessionControlStart,
    CTXSessionControlStop,
} CTXUserActivitySessionControl;


@interface CTXUserActivity : NSObject

@property (strong, nonatomic, readonly) NSMutableDictionary<CTXCustomDefinitionKey *, id> *customDimensions;
@property (strong, nonatomic, readonly) NSMutableDictionary<CTXCustomDefinitionKey *, id> *customMetrics;
@property (assign, nonatomic) CTXUserActivitySessionControl sessionControl;

@end

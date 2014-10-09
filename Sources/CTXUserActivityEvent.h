//
//  CTXUserActivityEvent.h
//  Pods
//
//  Created by Mario Araújo on 07/10/2014.
//  Copyright (c) 2014 EF CTX. All rights reserved.
//  Licensed under the MIT license.

#import "CTXUserActivity.h"

@interface CTXUserActivityEvent : CTXUserActivity

@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSNumber *value;

@end

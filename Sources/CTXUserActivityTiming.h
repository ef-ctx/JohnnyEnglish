//
//  CTXUserActivityTiming.h
//  Pods
//
//  Created by Mario Araújo on 07/10/2014.
//  Copyright (c) 2014 EF CTX. All rights reserved.
//  Licensed under the MIT license.

#import "CTXUserActivity.h"

@interface CTXUserActivityTiming : CTXUserActivity

@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSNumber *interval;

@end

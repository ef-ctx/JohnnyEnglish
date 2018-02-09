//
//  CTXUserActivity.m
//  Pods
//
//  Created by Mario Araújo on 07/10/2014.
//  Copyright (c) 2014 EF CTX. All rights reserved.
//  Licensed under the MIT license.

#import "CTXUserActivity.h"

@interface CTXUserActivity()

@property (strong, nonatomic) NSMutableDictionary *customDimensions;
@property (strong, nonatomic) NSMutableDictionary *customMetrics;

@end

@implementation CTXUserActivity

- (instancetype)init
{
    if (self = [super init]) {
        self.customDimensions = [NSMutableDictionary dictionary];
        self.customMetrics = [NSMutableDictionary dictionary];
        self.sessionControl = CTXSessionControlNone;
    }
    
    return self;
}

@end

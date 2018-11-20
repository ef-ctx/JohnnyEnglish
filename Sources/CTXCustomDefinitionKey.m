//
//  CTXCustomDefinitionKey.m
//  Pods
//
//  Created by Stefan Ceriu on 20/11/2018.
//  Copyright (c) 2018 EF CTX. All rights reserved.
//  Licensed under the MIT license.

#import "CTXCustomDefinitionKey.h"

@interface CTXCustomDefinitionKey ()

@end

@implementation CTXCustomDefinitionKey

- (instancetype)initWithName:(NSString *)name key:(NSString *)key
{
    NSParameterAssert(name);
    NSParameterAssert(key);
    
    if(self = [super init]) {
        _name = name;
        _key = key;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithName:self.name key:self.key];
}

@end

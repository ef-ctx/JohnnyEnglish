//
//  CTXCustomDefinitionKey.m
//  Pods
//
//  Created by Stefan Ceriu on 20/11/2018.
//  Copyright (c) 2018 EF CTX. All rights reserved.
//  Licensed under the MIT license.

#import "CTXCustomDefinitionKey.h"

@interface CTXCustomDefinitionKey ()

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *key;

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
    CTXCustomDefinitionKey *copy = [[[self class] allocWithZone:zone] init];
    [copy setName:self.name.copy];
    [copy setKey:self.key.copy];
    return copy;
}

@end

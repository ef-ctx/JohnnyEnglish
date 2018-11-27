//
//  CTXCustomDefinitionKey.m
//  Pods
//
//  Created by Stefan Ceriu on 20/11/2018.
//  Copyright (c) 2018 EF CTX. All rights reserved.
//  Licensed under the MIT license.

#import "CTXCustomDefinitionKey.h"

#ifndef CTX_NSUINTEGER_BIT
#define CTX_NSUINTEGER_BIT (CHAR_BIT * sizeof(NSUInteger))
#endif
#ifndef CTX_NSUINTROTATE
#define CTX_NSUINTROTATE(val, howmuch) ((((NSUInteger)(val)) << (howmuch)) | (((NSUInteger)(val)) >> (CTX_NSUINTEGER_BIT - (howmuch))))
#endif

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

- (NSUInteger)hash
{
    NSUInteger hashResult = 31;
    
    int denominator = 1;
    
    ++denominator;
    hashResult = CTX_NSUINTROTATE([self.name hash], CTX_NSUINTEGER_BIT / denominator) ^ hashResult;
    
    ++denominator;
    hashResult = CTX_NSUINTROTATE([self.key hash], CTX_NSUINTEGER_BIT / denominator) ^ hashResult;
    
    return hashResult;
}

@end

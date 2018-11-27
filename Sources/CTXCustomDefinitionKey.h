//
//  CTXCustomDefinitionKey.h
//  Pods
//
//  Created by Stefan Ceriu on 20/11/2018.
//  Copyright (c) 2018 EF CTX. All rights reserved.
//  Licensed under the MIT license.

#import <Foundation/Foundation.h>

@interface CTXCustomDefinitionKey : NSObject <NSCopying>

@property (nonatomic, strong, readonly, nonnull) NSString *name;

@property (nonatomic, strong, readonly, nonnull) NSString *key;

- (nonnull instancetype)initWithName:(nonnull NSString *)name key:(nonnull NSString *)key;

@end

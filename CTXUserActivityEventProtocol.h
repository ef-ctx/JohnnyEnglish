//
//  CTXUserActivityEventProtocol.h
//  CTXFramework
//
//  Created by Alberto De Bortoli on 29/01/2014.
//  Copyright (c) 2014 EF. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CTXUserActivityEventProtocol <NSObject>

@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSNumber *value;

@end

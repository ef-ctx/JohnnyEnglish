//
//  CTXUserActivityButtonPressedEvent.h
//  CTXFramework
//
//  Created by Alberto De Bortoli on 29/01/2014.
//  Copyright (c) 2014 EF. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CTXUserActivityEventProtocol.h"

@interface CTXUserActivityButtonPressedEvent : NSObject <CTXUserActivityEventProtocol>

+ (instancetype)eventWithLabel:(NSString *)label;

@end

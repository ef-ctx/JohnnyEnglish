//
//  CTXUserActivityButtonPressedEvent.h
//  JohnnyEnglish
//
//  Created by Alberto De Bortoli on 29/01/2014.
//  Copyright (c) 2014 EF CTX. All rights reserved.
//  Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

#import "CTXUserActivityEventProtocol.h"

@interface CTXUserActivityButtonPressedEvent : NSObject <CTXUserActivityEventProtocol>

+ (instancetype)eventWithLabel:(NSString *)label;

@end

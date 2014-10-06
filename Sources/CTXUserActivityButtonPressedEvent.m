//
//  CTXUserActivityButtonPressedEvent.m
//  JohnnyEnglish
//
//  Created by Alberto De Bortoli on 29/01/2014.
//  Copyright (c) 2014 EF CTX. All rights reserved.
//  Licensed under the MIT license.
//

#import "CTXUserActivityButtonPressedEvent.h"

static NSString *const kCTXUserActivityButtonPressedEventCategory = @"UI Interaction";
static NSString *const kCTXUserActivityButtonPressedEventAction = @"Button press";

@implementation CTXUserActivityButtonPressedEvent

@synthesize category = _category;
@synthesize action = _action;
@synthesize label = _label;
@synthesize value = _value;

+ (instancetype)eventWithLabel:(NSString *)label
{
    CTXUserActivityButtonPressedEvent *event = [[[self class] alloc] init];
    event.category = kCTXUserActivityButtonPressedEventCategory;
    event.action = kCTXUserActivityButtonPressedEventAction;
    event.label = label;
    
    return event;
}

@end

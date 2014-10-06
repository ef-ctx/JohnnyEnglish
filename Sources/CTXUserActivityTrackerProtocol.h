//
//  CTXUserActivityTrackerProtocol.h
//  JohnnyEnglish
//
//  Created by Alberto De Bortoli on 29/01/2014.
//  Copyright (c) 2014 EF CTX. All rights reserved.
//  Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

#import "CTXUserActivityEventProtocol.h"

@protocol CTXUserActivityTrackerProtocol <NSObject>

@optional

- (void)trackScreenHitWithName:(NSString *)screenName;
- (void)trackEvent:(id<CTXUserActivityEventProtocol>)event;

@end

//
//  CTXUserActivityTrackerProtocol.h
//  CTXFramework
//
//  Created by Alberto De Bortoli on 29/01/2014.
//  Copyright (c) 2014 EF. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CTXUserActivityEventProtocol.h"

@protocol CTXUserActivityTrackerProtocol <NSObject>

@optional

- (void)trackScreenHitWithName:(NSString *)screenName;
- (void)trackEvent:(id<CTXUserActivityEventProtocol>)event;

@end

//
//  CTXGATracker.h
//  Pods
//
//  Created by Mario on 06/10/2014.
//
//

#import <Foundation/Foundation.h>
#import "CTXUserActivityTrackerProtocol.h"

@interface CTXGATracker : NSObject<CTXUserActivityTrackerProtocol>

- (id)initWithTrackingId:(NSString *)trackingId;

@end

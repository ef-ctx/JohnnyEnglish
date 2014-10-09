//
//  CTXUserActivityTiming.h
//  Pods
//
//  Created by Mario on 07/10/2014.
//
//

#import "CTXUserActivity.h"

@interface CTXUserActivityTiming : CTXUserActivity

@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSNumber *interval;

@end

//
//  CTXUserActivityEvent.h
//  Pods
//
//  Created by Mario on 07/10/2014.
//
//

#import "CTXUserActivity.h"

@interface CTXUserActivityEvent : CTXUserActivity

@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSNumber *value;

@end

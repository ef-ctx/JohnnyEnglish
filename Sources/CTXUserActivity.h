//
//  CTXUserActivity.h
//  Pods
//
//  Created by Mario on 07/10/2014.
//
//

#import <Foundation/Foundation.h>

@interface CTXUserActivity : NSObject

@property (strong, nonatomic, readonly) NSMutableDictionary *customDimensions;
@property (strong, nonatomic, readonly) NSMutableDictionary *customMetrics;

- (void)setCustomDimension:(NSString *)dimension withValue:(NSString *)value;
- (void)setCustomMetric:(NSString *)dimension withValue:(NSString *)value;

@end

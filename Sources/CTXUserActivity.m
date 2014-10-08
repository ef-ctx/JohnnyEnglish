//
//  CTXUserActivity.m
//  Pods
//
//  Created by Mario on 07/10/2014.
//
//

#import "CTXUserActivity.h"

@interface CTXUserActivity()

@property (strong, nonatomic) NSMutableDictionary *customDimensions;
@property (strong, nonatomic) NSMutableDictionary *customMetrics;

@end

@implementation CTXUserActivity

- (instancetype)init
{
    if (self = [super init]) {
        self.customDimensions = [NSMutableDictionary dictionary];
        self.customMetrics = [NSMutableDictionary dictionary];
        self.sessionControl = CTXSessionControlNone;
    }
    
    return self;
}

- (void)setCustomDimension:(NSString *)dimension withValue:(NSString *)value
{
    [self.customDimensions setObject:value forKey:dimension];
}

- (void)setCustomMetric:(NSString *)metric withValue:(NSString *)value
{
    [self.customMetrics setObject:value forKey:metric];
}

@end

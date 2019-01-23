//
//  CTXUserActivityUser.h
//  JohnnyEnglish
//
//  Created by Stefan Ceriu on 23/01/2019.
//  Copyright (c) 2019 EF CTX. All rights reserved.
//  Licensed under the MIT license.
//

#import "CTXUserActivity.h"

@interface CTXUserActivityUser : CTXUserActivity

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSDictionary *traits;

@end

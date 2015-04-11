//
//  UITableViewCell+Identifier.m
//  Restu
//
//  Created by Aleš Kocur on 05/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import "UITableViewCell+Identifier.h"

@implementation UITableViewCell (Identifier)

+ (NSString *)identifier {
    return [NSString stringWithFormat:@"%@%@", NSStringFromClass([self class]), @"Identifier"];
}

@end

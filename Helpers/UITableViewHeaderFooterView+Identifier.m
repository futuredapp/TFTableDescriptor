//
//  UITableViewHeaderFooterView+Identifier.m
//  Restu
//
//  Created by Aleš Kocur on 08/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import "UITableViewHeaderFooterView+Identifier.h"

@implementation UITableViewHeaderFooterView (Identifier)

+ (NSString *)identifier {
    return [NSString stringWithFormat:@"%@%@", NSStringFromClass([self class]), @"Identifier"];
}

@end

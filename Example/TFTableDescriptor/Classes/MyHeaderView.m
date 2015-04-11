//
//  MyHeaderView.m
//  TFTableDescriptorDemo
//
//  Created by Aleš Kocur on 08/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import "MyHeaderView.h"

@implementation MyHeaderView

- (void)configureWithData:(id)data {
    
    // If we have suitable data for this cell
    if ([data isKindOfClass:[NSString class]]) {
        // configure cell
        self.titleLabel.text = data;
    }
    
}

+ (NSNumber *)height {
    return @40;
}

@end

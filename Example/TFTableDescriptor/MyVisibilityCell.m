//
//  MyVisibilityCell.m
//  TFTableDescriptor
//
//  Created by Jakub Knejzlik on 28/04/15.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//

#import "MyVisibilityCell.h"

@implementation MyVisibilityCell

- (IBAction)hideMeTapped:(id)sender {
    if ([self.rowDescriptor canTriggerAction]) {
        [self.rowDescriptor triggerAction:[TFAction actionWithSender:self.rowDescriptor type:0]];
    }
}

@end

//
//  MyWideButtonCell.m
//  TFTableDescriptor
//
//  Created by Jakub Knejzlik on 25/04/15.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//

#import "MyWideButtonCell.h"
#import <TFRowDescriptor.h>

@implementation MyWideButtonCell

+(NSNumber *)height{
    return @60;
}

- (IBAction)buttonAction:(id)sender {
    if ([self.rowDescriptor canTriggerAction]) {
        [self.rowDescriptor triggerAction:[TFRowAction actionWithSender:sender actionType:MyWideButtonCellActionTypeTriggerButton]];
    }
}

@end

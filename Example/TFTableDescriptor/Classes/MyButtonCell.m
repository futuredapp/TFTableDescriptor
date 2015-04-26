//
//  MyButtonCell.m
//  TFTableDescriptor
//
//  Created by Aleš Kocur on 17/04/15.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//

#import "MyButtonCell.h"

@implementation MyButtonCell

+(NSNumber *)height{
    return @130;
}

- (IBAction)buttonActions:(id)sender {

    if ([self.rowDescriptor canTriggerAction]) {
        
        if (sender == self.button1) {
            [self.rowDescriptor triggerAction:[TFRowAction actionWithSender:sender type:MyButtonCellActionTypeTriggerButton1]];
        } else if (sender == self.button2) {
            [self.rowDescriptor triggerAction:[TFRowAction actionWithSender:sender type:MyButtonCellActionTypeTriggerButton2]];
        }
    }
}

@end

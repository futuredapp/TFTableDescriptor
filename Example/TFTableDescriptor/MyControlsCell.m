//
//  MySwitchCell.m
//  TFTableDescriptor
//
//  Created by Jakub Knejzlik on 25/04/15.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//

#import "MyControlsCell.h"

#import <TFRowDescriptor.h>

@implementation MyControlsCell

+(NSNumber *)height{
    return @100;
}

- (IBAction)switchChangedValue:(id)sender {
    if ([self.rowDescriptor canTriggerAction]) {
        [self.rowDescriptor triggerAction:[TFRowAction actionWithSender:sender actionType:MyControlsCellActionTypeSwitch]];
    }
}

- (IBAction)segmendSelected:(id)sender {
    if ([self.rowDescriptor canTriggerAction]) {
        [self.rowDescriptor triggerAction:[TFRowAction actionWithSender:sender actionType:MyControlsCellActionTypeSegmend]];
    }
}

@end

//
//  MySliderCell.m
//  TFTableDescriptor
//
//  Created by Jakub Knejzlik on 25/04/15.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//

#import "MySliderCell.h"

#import <TFRowDescriptor.h>


@implementation MySliderCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self updateValue];
}

- (IBAction)sliderValueChanged:(id)sender {
    [self updateValue];
    if ([self.rowDescriptor canTriggerAction]) {
        [self.rowDescriptor triggerAction:[TFAction actionWithSender:sender type:0]];
    }
}

-(void)updateValue{
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f",self.slider.value];
}

@end

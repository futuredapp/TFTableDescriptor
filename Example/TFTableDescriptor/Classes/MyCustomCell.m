//
//  MyCustomCell.m
//  TFTableDescriptorDemo
//
//  Created by Aleš Kocur on 08/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import "MyCustomCell.h"

@implementation MyCustomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - TFTableDescriptorConfigurableCellProtocol

// Configure cell with given data

- (void)configureWithData:(id)data {
    
    // If we have suitable data for this cell
    if ([data isKindOfClass:[NSString class]]) {
        // configure cell
        self.titleLabel.text = data;
    }
    
}


// We know precise height

+ (NSNumber *)height {
    return @44.0;
}


@end

//
//  BasicDescriptedCell.h
//  Restu
//
//  Created by Aleš Kocur on 06/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFRowDescriptor.h"

@protocol TFTableDescriptorConfigurableCellProtocol <NSObject>

/// Configure cell with data given by row descriptor
- (void)configureWithData:(id)data;

@optional
/// Preferred height for cell, otherwise is calculated by autolayout
+ (NSNumber *)height;

@end


@interface TFBasicDescriptedCell : UITableViewCell<TFTableDescriptorConfigurableCellProtocol>

@property (nonatomic) TFRowDescriptor *rowDescriptor;

@end

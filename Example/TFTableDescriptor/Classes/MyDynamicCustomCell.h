//
//  MyDynamicCustomCell.h
//  TFTableDescriptorDemo
//
//  Created by Aleš Kocur on 08/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFBasicDescriptedCell.h"

// If we want cell to size itself dynamically
// only thing we need is to set up constraint from top to bottom
// and don't implement +height method

@interface MyDynamicCustomCell : TFBasicDescriptedCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

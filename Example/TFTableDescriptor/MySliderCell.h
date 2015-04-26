//
//  MySliderCell.h
//  TFTableDescriptor
//
//  Created by Jakub Knejzlik on 25/04/15.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TFBasicDescriptedCell.h>

@interface MySliderCell : TFBasicDescriptedCell
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UISlider *slider;

@end

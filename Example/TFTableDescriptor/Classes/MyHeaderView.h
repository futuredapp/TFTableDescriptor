//
//  MyHeaderView.h
//  TFTableDescriptorDemo
//
//  Created by Aleš Kocur on 08/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFBasicDescriptedHeaderFooterView.h"

@interface MyHeaderView : TFBasicDescriptedHeaderFooterView

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

//
//  MyButtonCell.h
//  TFTableDescriptor
//
//  Created by Aleš Kocur on 17/04/15.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TFBasicDescriptedCell.h>

typedef NS_ENUM(NSUInteger, MyButtonCellActionType) {
    MyButtonCellActionTypeTriggerButton1,
    MyButtonCellActionTypeTriggerButton2
};

@interface MyButtonCell : TFBasicDescriptedCell

@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;


@end

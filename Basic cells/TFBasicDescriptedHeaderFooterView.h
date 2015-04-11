//
//  BasicDescriptedHeaderFooterView.h
//  Restu
//
//  Created by Aleš Kocur on 06/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFSectionDescriptor;

@protocol TFTableDescriptorHeaderFooterProtocol <NSObject>

@required
- (void)configureWithData:(id)data;

@optional
+ (NSNumber *)height;

@end

@interface TFBasicDescriptedHeaderFooterView : UITableViewHeaderFooterView<TFTableDescriptorHeaderFooterProtocol>

@property (nonatomic) TFSectionDescriptor *sectionDescriptor;

@end

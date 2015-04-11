//
//  SectionDescriptor.h
//  Restu
//
//  Created by Aleš Kocur on 05/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFRowDescriptor;

@interface TFSectionDescriptor : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSAttributedString *attributedTitle;
@property (nonatomic) NSInteger tag;
@property (nonatomic) Class sectionClass;
@property (nonatomic) id data;

+ (instancetype)descriptorWithTitle:(NSString *)title;
+ (instancetype)descriptorWithTag:(NSInteger)tag title:(NSString *)title;
+ (instancetype)descriptorWithTag:(NSInteger)tag attributedTitle:(NSAttributedString *)attrTitle;

- (void)addRow:(TFRowDescriptor *)rowDescriptor;
- (NSArray *)allRows;
- (NSInteger)numberOfRows;
- (TFRowDescriptor *)rowAtRowIndex:(NSInteger)rowIndex;

@end

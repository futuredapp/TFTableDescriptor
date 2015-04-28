//
//  SectionDescriptor.h
//  Restu
//
//  Created by Aleš Kocur on 05/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFRowDescriptor, TFTableDescriptor;

@interface TFSectionDescriptor : NSObject

@property (nonatomic) NSInteger tag;
@property (nonatomic) Class headerClass;
@property (nonatomic) Class footerClass;
@property (nonatomic) id data;
@property (weak, nonatomic) TFTableDescriptor *tableDescriptor;

@property (nonatomic,getter=isHidden) BOOL hidden;

+ (instancetype)descriptorWithData:(id)data;
+ (instancetype)descriptorWithTag:(NSInteger)tag data:(id)data;

- (void)addRow:(TFRowDescriptor *)rowDescriptor;
- (void)addRowToTop:(TFRowDescriptor *)rowDescriptor;
- (void)addRowToBottom:(TFRowDescriptor *)rowDescriptor;
- (void)addRow:(TFRowDescriptor *)row afterRow:(TFRowDescriptor *)afterRow;
- (void)addRow:(TFRowDescriptor *)row inFronOfRow:(TFRowDescriptor *)inFrontOfRow;

- (void)removeRow:(TFRowDescriptor *)rowDescriptor;

- (NSArray *)allRows;
- (NSInteger)numberOfRows;
- (TFRowDescriptor *)rowAtRowIndex:(NSInteger)rowIndex;


#pragma mark - Visibility

- (NSArray *)allVisibleRows;
- (NSInteger)numberOfVisibleRows;

-(void)setHidden:(BOOL)hidden withRowAnimation:(UITableViewRowAnimation)rowAnimation;

@end

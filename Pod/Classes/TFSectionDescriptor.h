//
//  SectionDescriptor.h
//  Restu
//
//  Created by Aleš Kocur on 05/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFRowDescriptor, TFTableDescriptor, TFAction;

@interface TFSectionDescriptor : NSObject

@property (nonatomic) NSInteger tag;
@property (nonatomic) Class sectionHeaderClass;
@property (nonatomic) Class sectionFooterClass;
@property (nonatomic) id data;
@property (weak, nonatomic) TFTableDescriptor *tableDescriptor;
@property (nonatomic, copy) void (^actionBlock)(TFAction *action);

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

#pragma mark - Actions

- (void)setTarget:(id)target withSelector:(SEL)selector;
- (void)triggerAction:(TFAction *)action;

#pragma mark - Visibility

- (NSArray *)allVisibleRows;
- (NSInteger)numberOfVisibleRows;
- (TFRowDescriptor *)visibleRowAtRowIndex:(NSInteger)rowIndex;

-(void)setHidden:(BOOL)hidden withRowAnimation:(UITableViewRowAnimation)rowAnimation;

@end



@interface TFSectionDescriptor (PrivateMethods)

- (void)setHidden:(BOOL)hidden checkIfUpdating:(BOOL)check;

@end
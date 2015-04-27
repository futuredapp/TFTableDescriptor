//
//  TableDescriptor.h
//  Restu
//
//  Created by Aleš Kocur on 05/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFSectionDescriptor.h"
#import "TFRowDescriptor.h"
#import "TFBasicDescriptedCell.h"
#import "UITableViewHeaderFooterView+Identifier.h"
#import "UITableViewCell+Identifier.h"
#import "TFBasicDescriptedHeaderFooterView.h"

#define REGISTER_CELL_FOR_TABLE(_cellClass, _table) ([_table registerNib:[UINib nibWithNibName:NSStringFromClass([_cellClass class]) bundle:nil] forCellReuseIdentifier:[_cellClass identifier]])
#define REGISTER_HEADER_FOOTER_FOR_TABLE(_cellClass, _table) ([_table registerNib:[UINib nibWithNibName:NSStringFromClass([_cellClass class]) bundle:nil] forHeaderFooterViewReuseIdentifier:[_cellClass identifier]])

@class TFTableDescriptor;

@protocol TFTableDescriptorDelegate <NSObject>

@optional
- (CGFloat)tableDescriptor:(TFTableDescriptor *)descriptor heightForSection:(TFSectionDescriptor *)sectionDescriptor;
- (void)tableDescriptor:(TFTableDescriptor *)descriptor didSelectRow:(TFRowDescriptor *)rowDescriptor;

@end

@interface TFTableDescriptor : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readonly) BOOL isBeingUpdated;
@property (nonatomic, assign) id<TFTableDescriptorDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;

+ (instancetype)descriptor;
+ (instancetype)descriptorWithTable:(UITableView *)tableView;

/// Adds section into table
- (void)addSection:(TFSectionDescriptor *)sectionDescriptor;

/// Returns number of sections
- (NSInteger)numberOfSections;

/// Returns section at given index
- (TFSectionDescriptor *)sectionAtSectionIndex:(NSInteger)section;
- (TFSectionDescriptor *)sectionForTag:(NSInteger)tag;

/// Returns row at given NSIndexPath
- (TFRowDescriptor *)rowAtIndexPath:(NSIndexPath *)indexPath;
- (TFRowDescriptor *)rowForTag:(NSString *)tag;

/// Returns NSIndexPath for specific row tag
- (NSIndexPath *)indexPathForRowTag:(NSString *)tag;

/// Returns NSIndexPath for specific row descriptor
- (NSIndexPath *)indexPathForRow:(TFRowDescriptor *)row;

/// Returns UITableViewCell for given row descriptor
- (UITableViewCell *)cellForRow:(TFRowDescriptor *)row;

#pragma mark - Access rows

- (NSArray *)allRows;

#pragma mark - Inserting rows

- (void)insertRow:(TFRowDescriptor *)row atTopOfSection:(TFSectionDescriptor *)section;
- (void)insertRow:(TFRowDescriptor *)row atBottomOfSection:(TFSectionDescriptor *)section;
- (void)insertRow:(TFRowDescriptor *)row inFrontOfRow:(TFRowDescriptor *)inFrontOfRow;
- (void)insertRow:(TFRowDescriptor *)row afterRow:(TFRowDescriptor *)afterRow;

- (void)insertRow:(TFRowDescriptor *)row atTopOfSection:(TFSectionDescriptor *)section rowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)insertRow:(TFRowDescriptor *)row atBottomOfSection:(TFSectionDescriptor *)section rowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)insertRow:(TFRowDescriptor *)row inFrontOfRow:(TFRowDescriptor *)inFrontOfRow rowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)insertRow:(TFRowDescriptor *)row afterRow:(TFRowDescriptor *)afterRow rowAnimation:(UITableViewRowAnimation)rowAnimation;

#pragma mark - Deleting rows

- (void)removeRow:(TFRowDescriptor *)row;
- (void)removeRowWithTag:(NSString *)tag;

- (void)removeRow:(TFRowDescriptor *)row rowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)removeRowWithTag:(NSString *)tag rowAnimation:(UITableViewRowAnimation)rowAnimation;

#pragma mark - Animation flow control

/// Start manipulation with table
- (void)beginUpdates;
/// Commit changes in table
- (void)endUpdates;


@end


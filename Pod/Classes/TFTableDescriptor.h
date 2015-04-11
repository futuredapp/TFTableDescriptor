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

@protocol TFTableDescriptorProtocol <NSObject>

@optional
- (CGFloat)tableDescriptor:(TFTableDescriptor *)descriptor heightForSection:(TFSectionDescriptor *)sectionDescriptor;
- (void)tableDescriptor:(TFTableDescriptor *)descriptor didSelectRow:(TFRowDescriptor *)rowDescriptor;

@end

@interface TFTableDescriptor : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<TFTableDescriptorProtocol> delegate;

+ (instancetype)descriptor;
+ (instancetype)descriptorWithTable:(UITableView *)tableView;

/// Adds section into table
- (void)addSection:(TFSectionDescriptor *)sectionDescriptor;

/// Returns number of sections
- (NSInteger)numberOfSections;

/// Returns section at given index
- (TFSectionDescriptor *)sectionAtSectionIndex:(NSInteger)section;

/// Returns row at given NSIndexPath
- (TFRowDescriptor *)rowAtIndexPath:(NSIndexPath *)indexPath;

/// Returns NSIndexPath for specific row tag
- (NSIndexPath *)indexPathForRowTag:(NSString *)tag;

/// Returns NSIndexPath for specific row descriptor
- (NSIndexPath *)indexPathForRow:(TFRowDescriptor *)row;

/// Returns UITableViewCell for given row descriptor
- (UITableViewCell *)cellForRow:(TFRowDescriptor *)row;

@end


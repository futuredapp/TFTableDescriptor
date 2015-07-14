//
//  TableDescriptor.m
//  Restu
//
//  Created by Aleš Kocur on 05/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import "TFTableDescriptor.h"
#import "TFBasicDescriptedHeaderFooterView.h"

@interface TFTableDescriptor()

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSCache *cellSizeCache;
@property (nonatomic, strong) NSMutableArray *array;

@property (strong, nonatomic) NSMutableArray *indexPathsToDelete;
@property (strong, nonatomic) NSMutableArray *indexPathsToInsert;

@property (strong, nonatomic) NSMutableArray *sectionsToDelete;
@property (strong, nonatomic) NSMutableArray *sectionsToInsert;

@end

@implementation TFTableDescriptor

+ (instancetype)descriptor {
    return [[TFTableDescriptor alloc] init];
}

+ (instancetype)descriptorWithTable:(UITableView *)tableView {
    TFTableDescriptor *descriptor = [TFTableDescriptor descriptor];
    descriptor.tableView = tableView;
    
    tableView.dataSource = descriptor;
    tableView.delegate = descriptor;
    
    return descriptor;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isBeingUpdated = false;
    }
    return self;
}

- (NSMutableArray *)sections {
    if (!_sections) {
        _sections = [@[] mutableCopy];
    }
    
    return _sections;
}

- (void)addSection:(TFSectionDescriptor *)sectionDescriptor {
    [self.sections addObject:sectionDescriptor];
    sectionDescriptor.tableDescriptor = self;
}

- (NSInteger)numberOfSections {
    return self.sections.count;
}
- (NSInteger)numberOfVisibleSections{
    return self.allVisibleSections.count;
}


#pragma mark - Section access

- (NSArray *)allSections{
    return [NSArray arrayWithArray:self.sections];
}
- (NSArray *)allVisibleSections{
    return [[self allSections] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hidden = NO"]];
}

- (TFSectionDescriptor *)sectionAtSectionIndex:(NSInteger)section {
    if (section >= [self allSections].count) {
        [[NSException exceptionWithName:@"Out of bounds" reason:@"Attempt to reach nonexisting visible section" userInfo:@{@"sectionIndex": @(section), @"sections": self.sections}] raise];
    }
    return [self allSections][section];
}

- (TFSectionDescriptor *)sectionForTag:(NSInteger)tag {
    for (TFSectionDescriptor *section in self.sections) {
        if (section.tag == tag) {
            return section;
        }
    }
    
    return nil;
}

- (TFSectionDescriptor *)visibleSectionAtSectionIndex:(NSInteger)section{
    if (section >= [self allVisibleSections].count) {
        [[NSException exceptionWithName:@"Out of bounds" reason:@"Attempt to reach nonexisting visible section" userInfo:@{@"sectionIndex": @(section), @"sections": self.sections}] raise];
    }
    return [self allVisibleSections][section];
}
- (TFSectionDescriptor *)visibleSectionForTag:(NSInteger)tag{
    for (TFSectionDescriptor *section in self.allVisibleSections) {
        if (section.tag == tag) {
            return section;
        }
    }
    
    return nil;
}

#pragma mark - Row access

- (NSArray *)allRows {
    NSMutableArray *rows = [@[] mutableCopy];
    
    for (TFSectionDescriptor *sectionDescriptor in self.sections) {
        [rows addObjectsFromArray:[sectionDescriptor allRows]];
    }
    
    return [rows copy];
}

- (NSArray *)allVisibleRows{
    return [[self allRows] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hidden = NO"]];
}


- (TFRowDescriptor *)rowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSAssert(indexPath != nil, @"IndexPath cannot be nil!");
    
    NSArray *sections = [self allSections];
    
    if (indexPath.section >= sections.count) {
        [[NSException exceptionWithName:@"Out of bounds" reason:@"Attempt to reach nonexisting section" userInfo:@{@"indexPath": indexPath, @"sections": self.sections}] raise];
    }
    
    if (indexPath.row >= [sections[indexPath.section] numberOfRows]) {
        [[NSException exceptionWithName:@"Out of bounds" reason:@"Attempt to reach nonexisting row" userInfo:@{@"indexPath": indexPath, @"rows": self.sections[indexPath.section]}] raise];
    }
    
    return [sections[indexPath.section] rowAtRowIndex:indexPath.row];
}

- (TFRowDescriptor *)rowForTag:(NSString *)tag {
    NSIndexPath *indexPath = [self indexPathForRowTag:tag];
    if (indexPath) {
        return [self rowAtIndexPath:indexPath];
    } else {
        return nil;
    }
}

- (TFRowDescriptor *)visibleRowAtIndexPath:(NSIndexPath *)indexPath{
    NSAssert(indexPath != nil, @"IndexPath cannot be nil!");
    
    NSArray *sections = [self allVisibleSections];
    
    if (indexPath.section >= sections.count) {
        [[NSException exceptionWithName:@"Out of bounds" reason:@"Attempt to reach nonexisting section" userInfo:@{@"indexPath": indexPath, @"sections": self.sections}] raise];
    }
    
    if (indexPath.row >= [sections[indexPath.section] numberOfVisibleRows]) {
        [[NSException exceptionWithName:@"Out of bounds" reason:@"Attempt to reach nonexisting row" userInfo:@{@"indexPath": indexPath, @"rows": self.sections[indexPath.section]}] raise];
    }
    
    return [sections[indexPath.section] visibleRowAtRowIndex:indexPath.row];
}
- (TFRowDescriptor *)visibleRowForTag:(NSString *)tag{
    NSIndexPath *indexPath = [self indexPathForRowTag:tag];
    if (indexPath) {
        return [self visibleRowAtIndexPath:indexPath];
    } else {
        return nil;
    }
}

- (NSIndexPath *)indexPathForRowTag:(NSString *)tag {
    NSUInteger sectionIndex = 0;
    
    for (TFSectionDescriptor *section in self.sections) {
        for (int ri = 0; ri < section.numberOfRows; ri++) {
            if ([[section rowAtRowIndex:ri].tag isEqualToString:tag]) {
                return [NSIndexPath indexPathForRow:ri inSection:sectionIndex];
            }
        }
        sectionIndex++;
    }
    
    return nil;
}

- (NSIndexPath *)indexPathForVisibleRowTag:(NSString *)tag{
    NSUInteger sectionIndex = 0;
    
    for (TFSectionDescriptor *section in self.allVisibleSections) {
        for (int ri = 0; ri < section.numberOfVisibleRows; ri++) {
            if ([[section visibleRowAtRowIndex:ri].tag isEqualToString:tag]) {
                return [NSIndexPath indexPathForRow:ri inSection:sectionIndex];
            }
        }
        sectionIndex++;
    }
    
    return nil;
}

- (NSIndexPath *)indexPathForRow:(TFRowDescriptor *)row {
    NSUInteger sectionIndex = [self.sections indexOfObject:row.section];
    NSUInteger rowIndex = [[row.section allRows] indexOfObject:row];
    
    if (sectionIndex == NSNotFound || rowIndex == NSNotFound) {
        return nil;
    }
    
    return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
}
- (NSIndexPath *)indexPathForVisibleRow:(TFRowDescriptor *)row{
    NSUInteger sectionIndex = [self.allVisibleSections indexOfObject:row.section];
    NSUInteger rowIndex = [[row.section allVisibleRows] indexOfObject:row];
    
    if (sectionIndex == NSNotFound || rowIndex == NSNotFound) {
        return nil;
    }
    
    return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
}

- (UITableViewCell *)cellForRow:(TFRowDescriptor *)row {
    return [self.tableView cellForRowAtIndexPath:[self indexPathForVisibleRow:row]];
}

#pragma mark - Lazy initializations

- (NSCache *)cellSizeCache {
    if (!_cellSizeCache) {
        _cellSizeCache = [[NSCache alloc] init];
    }
    
    return _cellSizeCache;
}

- (UITableView *)tableView {
    if (!_tableView) {
        NSLog(@"You have to set tableView for descriptor");
        assert(true);
    }
    
    return _tableView;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self numberOfVisibleSections];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    
    return [[self visibleSectionAtSectionIndex:section] numberOfVisibleRows];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *cellHeight = [self.cellSizeCache objectForKey:indexPath];
    
    if (cellHeight) {
        return [cellHeight floatValue];
    } else {
        cellHeight = @0.0;
    }
    
    TFRowDescriptor *row = [self visibleRowAtIndexPath:indexPath];
    
    if (row.cellHeight.floatValue >= 0.0) {
        return row.cellHeight.floatValue;
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(tableDescriptor:heightForRow:)]) {
        cellHeight = @([self.delegate tableDescriptor:self heightForRow:row]);
    } else if ([row.rowClass respondsToSelector:@selector(height)]) {
        
        cellHeight = [row.rowClass performSelector:@selector(height)];
        
    } else if ([row.rowClass respondsToSelector:@selector(identifier)]) {
        cellHeight = @([self calculateDynamicHeightForRow:row]);
        
        if (self.tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
            cellHeight = @(cellHeight.floatValue + 1.0);
        }
        
    }
    
    [self.cellSizeCache setObject:cellHeight forKey:indexPath];
    
    return cellHeight.floatValue;
    
}

- (CGFloat)calculateDynamicHeightForRow:(TFRowDescriptor *)row {
    UITableViewCell<TFTableDescriptorConfigurableCellProtocol> *cell = [self.tableView dequeueReusableCellWithIdentifier:[row.rowClass performSelector:@selector(identifier)]];
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight(cell.bounds));
    
    if ([cell conformsToProtocol:@protocol(TFTableDescriptorConfigurableCellProtocol)]) {
        [cell configureWithData:row.data];
    }
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TFRowDescriptor *row = [self visibleRowAtIndexPath:indexPath];
    
    
    TFBasicDescriptedCell<TFTableDescriptorConfigurableCellProtocol> *cell = [self.tableView dequeueReusableCellWithIdentifier:[row.rowClass performSelector:@selector(identifier)]];
    
    NSAssert(cell != nil, ([NSString stringWithFormat:@"You probably forget to register %@ class", NSStringFromClass(row.rowClass)]));
    
    if (![cell isKindOfClass:[TFBasicDescriptedCell class]]) {
        NSLog(@"Cell must be subclass of BasicDescriptedCell!");
        assert(true);
    }
    
    cell.rowDescriptor = row;
    
    if ([cell conformsToProtocol:@protocol(TFTableDescriptorConfigurableCellProtocol)]) {
        [cell configureWithData:row.data];
    }
    
    //    if ([cell respondsToSelector:@selector(delegate)]) {
    //        [cell setValue:self forKey:@"delegate"];
    //    }
    
    return cell;
}

- (CGFloat)tableDescriptor:(TFTableDescriptor *)descriptor heightForRow:(TFRowDescriptor *)rowDescriptor {
    if (rowDescriptor.cellHeight.floatValue >= 0.0) {
        return rowDescriptor.cellHeight.floatValue;
    } else if ([rowDescriptor.rowClass respondsToSelector:@selector(height)]) {
        return [[rowDescriptor.rowClass performSelector:@selector(height)] floatValue];
    } else if ([rowDescriptor.rowClass respondsToSelector:@selector(identifier)]) {
        return [self calculateDynamicHeightForRow:rowDescriptor];
    } else {
        return 0;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableDescriptor:didSelectRow:)]) {
        [self.delegate tableDescriptor:self didSelectRow:[self visibleRowAtIndexPath:indexPath]];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableDescriptor:didDeselectRow:)]) {
        [self.delegate tableDescriptor:self didDeselectRow:[self visibleRowAtIndexPath:indexPath]];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TFSectionDescriptor *sectionDescriptor = [self visibleSectionAtSectionIndex:section];
    
    TFBasicDescriptedHeaderFooterView *view = nil;
    
    if (sectionDescriptor.sectionHeaderClass) {
        
        view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:[sectionDescriptor.sectionHeaderClass performSelector:@selector(identifier)]];
    } else {
        return nil;
    }
    
    view.sectionDescriptor = sectionDescriptor;
    
    
    if ([view conformsToProtocol:@protocol(TFTableDescriptorHeaderFooterProtocol)]) {
        if (sectionDescriptor.data) {
            [view configureWithData:sectionDescriptor.data];
        }
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    TFSectionDescriptor *sectionDescriptor = [self visibleSectionAtSectionIndex:section];
    
    if ([sectionDescriptor.sectionHeaderClass respondsToSelector:@selector(height)]) {
        return [[sectionDescriptor.sectionHeaderClass performSelector:@selector(height)] floatValue];
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(tableDescriptor:heightForSection:)]) {
        return [self.delegate tableDescriptor:self heightForSection:sectionDescriptor];
    } else {
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    TFSectionDescriptor *sectionDescriptor = [self visibleSectionAtSectionIndex:section];
    
    TFBasicDescriptedHeaderFooterView *view = nil;
    
    if (sectionDescriptor.sectionFooterClass) {
        
        view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:[sectionDescriptor.sectionFooterClass performSelector:@selector(identifier)]];
    } else {
        return nil;
    }
    
    view.sectionDescriptor = sectionDescriptor;
    
    
    if ([view conformsToProtocol:@protocol(TFTableDescriptorHeaderFooterProtocol)]) {
        if (sectionDescriptor.data) {
            [view configureWithData:sectionDescriptor.data];
        }
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    TFSectionDescriptor *sectionDescriptor = [self visibleSectionAtSectionIndex:section];
    
    if ([sectionDescriptor.sectionFooterClass respondsToSelector:@selector(height)]) {
        return [[sectionDescriptor.sectionFooterClass performSelector:@selector(height)] floatValue];
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(tableDescriptor:heightForSection:)]) {
        return [self.delegate tableDescriptor:self heightForSection:sectionDescriptor];
    } else {
        return CGFLOAT_MIN;
    }
}

#pragma mark - Manipulating with table

- (void)insertRow:(TFRowDescriptor *)row atTopOfSection:(TFSectionDescriptor *)section {
    [self insertRow:row atTopOfSection:section rowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)insertRow:(TFRowDescriptor *)row atBottomOfSection:(TFSectionDescriptor *)section {
    [self insertRow:row atBottomOfSection:section rowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)insertRow:(TFRowDescriptor *)row inFrontOfRow:(TFRowDescriptor *)inFrontOfRow {
    [self insertRow:row inFrontOfRow:inFrontOfRow rowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)insertRow:(TFRowDescriptor *)row afterRow:(TFRowDescriptor *)afterRow {
    [self insertRow:row afterRow:afterRow rowAnimation:UITableViewRowAnimationAutomatic];
}


- (void)insertRow:(TFRowDescriptor *)row atTopOfSection:(TFSectionDescriptor *)section rowAnimation:(UITableViewRowAnimation)rowAnimation {
    
    NSAssert([self containSection:section], @"Table descriptor doesn't contain section you are trying insert into!");
    
    [section addRowToTop:row];
    NSIndexPath *rowIndexPath = [self indexPathForRow:row];
    
    [self updateTableForInsertionAtIndexPath:rowIndexPath rowAnimation:rowAnimation];
    
    
}

- (void)insertRow:(TFRowDescriptor *)row atBottomOfSection:(TFSectionDescriptor *)section rowAnimation:(UITableViewRowAnimation)rowAnimation {
    NSAssert([self containSection:section], @"Table descriptor doesn't contain section you are trying insert into!");
    
    [section addRowToBottom:row];
    NSIndexPath *rowIndexPath = [self indexPathForRow:row];
    
    [self updateTableForInsertionAtIndexPath:rowIndexPath rowAnimation:rowAnimation];
    
}

- (void)insertRow:(TFRowDescriptor *)row inFrontOfRow:(TFRowDescriptor *)inFrontOfRow rowAnimation:(UITableViewRowAnimation)rowAnimation {
    
    NSAssert(inFrontOfRow != nil, @"inFrontOfRow cannot be nil!");
    NSAssert(inFrontOfRow.section != nil, @"Trying to add cell in front of cell which is not in section!");
    
    [inFrontOfRow.section addRow:row inFronOfRow:inFrontOfRow];
    NSIndexPath *rowIndexPath = [self indexPathForRow:row];
    
    [self updateTableForInsertionAtIndexPath:rowIndexPath rowAnimation:rowAnimation];
    
    
}

- (void)insertRow:(TFRowDescriptor *)row afterRow:(TFRowDescriptor *)afterRow rowAnimation:(UITableViewRowAnimation)rowAnimation {
    
    NSAssert(afterRow != nil, @"afterRow cannot be nil!");
    NSAssert(afterRow.section != nil, @"Trying to add cell after cell which is not in section!");
    
    [afterRow.section addRow:row afterRow:afterRow];
    NSIndexPath *rowIndexPath = [self indexPathForRow:row];
    
    [self updateTableForInsertionAtIndexPath:rowIndexPath rowAnimation:rowAnimation];
    
}

- (void)updateTableForInsertionAtIndexPath:(NSIndexPath *)indexPath rowAnimation:(UITableViewRowAnimation)rowAnimation {
    [self insertCellSizeCacheAtIndexPath:indexPath];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation];
    
}

- (void)updateTableForDeleteAtIndexPath:(NSIndexPath *)indexPath rowAnimation:(UITableViewRowAnimation)rowAnimation {
    [self deleteCellSizeCacheAtIndexPath:indexPath];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation];
    
}

#pragma mark - Removing rows

- (void)removeRow:(TFRowDescriptor *)row {
    [self removeRow:row rowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)removeRowWithTag:(NSString *)tag {
    [self removeRowWithTag:tag rowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)removeRow:(TFRowDescriptor *)row rowAnimation:(UITableViewRowAnimation)rowAnimation {
    
    NSAssert(row != nil, @"Row cannot be nil!");
    
    NSIndexPath *indexPath = [self indexPathForRow:row];
    
    [row.section removeRow:row];
    
    [self updateTableForDeleteAtIndexPath:indexPath rowAnimation:rowAnimation];
    
}

- (void)removeRowWithTag:(NSString *)tag rowAnimation:(UITableViewRowAnimation)rowAnimation {
    
    NSAssert(tag != nil, @"Tag cannot be nil!");
    
    TFRowDescriptor *row = [self rowForTag:tag];
    
    [self removeRow:row rowAnimation:rowAnimation];
}

#pragma mark - Helpers

- (BOOL)containSection:(TFSectionDescriptor *)section {
    return [self.sections containsObject:section];
}

- (NSArray *)indexPathsAfterIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *indexPaths = [@[] mutableCopy];
    
    for (NSUInteger ri = indexPath.row; ri < [self.sections[indexPath.section] numberOfRows]; ri++) {
        
        [indexPaths addObject:[NSIndexPath indexPathForRow:ri inSection:indexPath.section]];
        
    }
    
    return indexPaths;
}

#pragma mark - Cell size cache managment

/// This will shift all cached index paths values by indexPath.row + 1
- (void)insertCellSizeCacheAtIndexPath:(NSIndexPath *)rowIndexPath {
    
    NSArray *indexPaths = [self indexPathsAfterIndexPath:rowIndexPath];
    
    [indexPaths enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSIndexPath *obj, NSUInteger idx, BOOL *stop) {
        NSNumber *cache = [self.cellSizeCache objectForKey:obj];
        
        if (cache) {
            [self.cellSizeCache setObject:cache forKey:[NSIndexPath indexPathForRow:obj.row + 1 inSection:obj.section]];
        }
        
        if (idx == 0) {
            [self.cellSizeCache removeObjectForKey:obj];
        }
    }];
    
}

- (void)deleteCellSizeCacheAtIndexPath:(NSIndexPath *)rowIndexPath {
    
    NSArray *indexPaths = [self indexPathsAfterIndexPath:rowIndexPath];
    
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *obj, NSUInteger idx, BOOL *stop) {
        
        NSNumber *cache = [self.cellSizeCache objectForKey:[NSIndexPath indexPathForRow:obj.row + 1 inSection:obj.section]];
        
        if (cache) {
            [self.cellSizeCache setObject:cache forKey:obj];
        }
        
        if (idx == indexPaths.count-1) {
            [self.cellSizeCache removeObjectForKey:[NSIndexPath indexPathForRow:obj.row + 1 inSection:obj.section]];
        }
    }];
    
}

- (void)invalidCellSizeAtIndexPath:(NSIndexPath *)rowIndexPath {
    [self.cellSizeCache removeObjectForKey:rowIndexPath];
}

- (void)invalidateCellSizes{
    [self.cellSizeCache removeAllObjects];
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    RestaurantFooter *footer = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:[RestaurantFooter identifier]];
//
//    return footer;
//}

#pragma mark - Table updates

/// Start manipulation with table
- (void)beginUpdates {
    
    [self.tableView beginUpdates];
    _isBeingUpdated = YES;
    
}

- (NSMutableArray *)indexPathsToDelete{
    if (!_indexPathsToDelete) {
        _indexPathsToDelete = [NSMutableArray array];
    }
    return _indexPathsToDelete;
}
- (NSMutableArray *)indexPathsToInsert{
    if (!_indexPathsToInsert) {
        _indexPathsToInsert = [NSMutableArray array];
    }
    return _indexPathsToInsert;
}
- (NSMutableArray *)sectionsToDelete{
    if (!_sectionsToDelete) {
        _sectionsToDelete = [NSMutableArray array];
    }
    return _sectionsToDelete;
}
- (NSMutableArray *)sectionsToInsert{
    if (!_sectionsToInsert) {
        _sectionsToInsert = [NSMutableArray array];
    }
    return _sectionsToInsert;
}

/// Commit changes in table
- (void)endUpdates {
    
    for (NSDictionary *_dictionary in self.indexPathsToDelete) {
        TFRowDescriptor *row = _dictionary[@"row"];
        TFCustomRowAnimation rowAnimation = _dictionary[@"customAnimation"];
        if (rowAnimation) {
            rowAnimation([self cellForRow:row]);
        }
        NSIndexPath *indexPath = [self indexPathForVisibleRow:row];
        if (indexPath && indexPath.section != NSNotFound && indexPath.row != NSNotFound) {
            [self updateTableForDeleteAtIndexPath:indexPath rowAnimation:[_dictionary[@"animation"] integerValue]];
        }
    }
    for (NSDictionary *_dictionary in self.indexPathsToDelete) {
        TFRowDescriptor *row = _dictionary[@"row"];
        [row setHidden:YES checkIfUpdating:NO];
    }
    for (NSDictionary *_dictionary in self.indexPathsToInsert) {
        TFRowDescriptor *row = _dictionary[@"row"];
        [row setHidden:NO checkIfUpdating:NO];
        NSIndexPath *indexPath = [self indexPathForVisibleRow:row];
        if (indexPath && indexPath.section != NSNotFound && indexPath.row != NSNotFound) {
            [self updateTableForInsertionAtIndexPath:indexPath rowAnimation:[_dictionary[@"animation"] integerValue]];
        }
    }
    
    for (NSDictionary *_dictionary in self.sectionsToDelete) {
        TFSectionDescriptor *section = _dictionary[@"section"];
        NSInteger index = [self.allVisibleSections indexOfObject:section];
        if (index != NSNotFound) {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:[_dictionary[@"animation"] integerValue]];
        }
    }
    for (NSDictionary *_dictionary in self.sectionsToDelete) {
        TFSectionDescriptor *section = _dictionary[@"section"];
        [section setHidden:YES checkIfUpdating:NO];
    }
    for (NSDictionary *_dictionary in self.sectionsToInsert) {
        TFSectionDescriptor *section = _dictionary[@"section"];
        [section setHidden:NO checkIfUpdating:NO];
        NSInteger index = [self.allVisibleSections indexOfObject:section];
        if (index != NSNotFound) {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:[_dictionary[@"animation"] integerValue]];
        }
    }
    
    if (self.sectionsToDelete.count + self.sectionsToInsert.count > 0) {
        [self invalidateCellSizes];
    }
    
    [self.tableView endUpdates];
    
    
    for (NSDictionary *_dictionary in self.indexPathsToInsert) {
        TFRowDescriptor *row = _dictionary[@"row"];
        TFCustomRowAnimation rowAnimation = _dictionary[@"customAnimation"];
        if (rowAnimation) {
            rowAnimation([self cellForRow:row]);
        }
    }
    
    self.indexPathsToDelete = nil;
    self.indexPathsToInsert = nil;
    self.sectionsToDelete = nil;
    self.sectionsToInsert = nil;
    
    _isBeingUpdated = NO;
    
}

- (void)addRowForDeleting:(TFRowDescriptor *)row rowAnimation:(UITableViewRowAnimation)rowAnimation customAnimation:(TFCustomRowAnimation)customAnimation{
    NSAssert(_isBeingUpdated, @"tableDescriptor must be in updating state when updating visibility");
    NSMutableDictionary *dict = [@{@"row":row,@"animation":@(rowAnimation)} mutableCopy];
    if (customAnimation) {
        dict[@"customAnimation"] = [customAnimation copy];
    }
    [self.indexPathsToDelete addObject:dict];
}
- (void)addRowForInserting:(TFRowDescriptor *)row rowAnimation:(UITableViewRowAnimation)rowAnimation customAnimation:(TFCustomRowAnimation)customAnimation{
    NSAssert(_isBeingUpdated, @"tableDescriptor must be in updating state when updating visibility");
    NSMutableDictionary *dict = [@{@"row":row,@"animation":@(rowAnimation)} mutableCopy];
    if (customAnimation) {
        dict[@"customAnimation"] = [customAnimation copy];
    }
    [self.indexPathsToInsert addObject:dict];
}

- (void)addSectionForDeleting:(TFSectionDescriptor *)section rowAnimation:(UITableViewRowAnimation)rowAnimation{
    NSAssert(_isBeingUpdated, @"tableDescriptor must be in updating state when updating visibility");
    [self.sectionsToDelete addObject:@{@"animation":@(rowAnimation),@"section":section}];
}
- (void)addSectionForInserting:(TFSectionDescriptor *)section rowAnimation:(UITableViewRowAnimation)rowAnimation{
    NSAssert(_isBeingUpdated, @"tableDescriptor must be in updating state when updating visibility");
    [self.sectionsToInsert addObject:@{@"animation":@(rowAnimation),@"section":section}];
}

#pragma mark - Visibility

- (void)updateCellWithRowDescriptor:(TFRowDescriptor *)row {
    
    NSIndexPath *indexPath = [self indexPathForVisibleRow:row];
    
    if (indexPath) {
        [self invalidCellSizeAtIndexPath:indexPath];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

- (void)updateCellHeightWithRowDescriptor:(TFRowDescriptor *)row {
    NSIndexPath *indexPath = [self indexPathForVisibleRow:row];
    
    if (indexPath) {
        [self invalidCellSizeAtIndexPath:indexPath];
     
        [self setNeedsUpdate];
    }
}

- (void)setNeedsUpdate{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateIfNeeded) object:nil];
    [self performSelector:@selector(updateIfNeeded) withObject:nil afterDelay:0];
}
- (void)updateIfNeeded{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

             
- (void)updateVisibilityWithBlock:(void (^)(void))block{
    [self beginUpdates];
    block();
    [self endUpdates];
}


#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewDidScroll:)]) {
        [self.delegate tableViewDidScroll:self.tableView];
    }
}


#pragma mark - Scroll 

- (void)scrollToRow:(TFRowDescriptor *)row position:(UITableViewScrollPosition)position animated:(BOOL)animated {
    NSIndexPath *indexPath = [self indexPathForVisibleRow:row];

    if (indexPath) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:animated];
    }
}

@end

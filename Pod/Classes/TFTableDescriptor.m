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
@property (nonatomic, weak) UITableView *tableView;

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

- (NSMutableArray *)sections {
    if (!_sections) {
        _sections = [@[] mutableCopy];
    }
    
    return _sections;
}

- (void)addSection:(TFSectionDescriptor *)sectionDescriptor {
    [self.sections addObject:sectionDescriptor];
}

- (NSInteger)numberOfSections {
    return self.sections.count;
}

- (TFSectionDescriptor *)sectionAtSectionIndex:(NSInteger)section {
    return self.sections[section];
}

- (TFRowDescriptor *)rowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.sections[indexPath.section] rowAtRowIndex:indexPath.row];
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

- (NSIndexPath *)indexPathForRow:(TFRowDescriptor *)row {
    NSUInteger sectionIndex = 0;
    
    for (TFSectionDescriptor *section in self.sections) {
        for (int ri = 0; ri < section.numberOfRows; ri++) {
            if ([[section rowAtRowIndex:ri] isEqual:row]) {
                return [NSIndexPath indexPathForRow:ri inSection:sectionIndex];
            }
        }
        sectionIndex++;
    }
    
    return nil;
}

- (UITableViewCell *)cellForRow:(TFRowDescriptor *)row {
    return [self.tableView cellForRowAtIndexPath:[self indexPathForRow:row]];
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
    
    return [self numberOfSections];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    
    return [[self sectionAtSectionIndex:section] numberOfRows];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *cellHeight = [self.cellSizeCache objectForKey:indexPath];
    
    if (cellHeight) {
        return [cellHeight floatValue];
    } else {
        cellHeight = @0.0;
    }
    
    TFRowDescriptor *row = [self rowAtIndexPath:indexPath];
    
    if ([row.rowClass respondsToSelector:@selector(height)]) {
        cellHeight = [row.rowClass performSelector:@selector(height)];
        
    } else if ([row.rowClass respondsToSelector:@selector(identifier)]) {
        UITableViewCell<TFTableDescriptorConfigurableCellProtocol> *cell = [self.tableView dequeueReusableCellWithIdentifier:[row.rowClass performSelector:@selector(identifier)]];
        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight(cell.bounds));
        
        if ([cell conformsToProtocol:@protocol(TFTableDescriptorConfigurableCellProtocol)]) {
            [cell configureWithData:row.data];
        }
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        cellHeight = @([cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height);
        
        if (self.tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
            cellHeight = @(cellHeight.floatValue + 1.0);
        }
        
        
    }
    
    [self.cellSizeCache setObject:cellHeight forKey:indexPath];
    
    return cellHeight.floatValue;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TFRowDescriptor *row = [self rowAtIndexPath:indexPath];
    
    TFBasicDescriptedCell<TFTableDescriptorConfigurableCellProtocol> *cell = [self.tableView dequeueReusableCellWithIdentifier:[row.rowClass performSelector:@selector(identifier)]];
    
    if (![cell isKindOfClass:[TFBasicDescriptedCell class]]) {
        NSLog(@"Cell must be subclass of BasicDescriptedCell!");
        assert(true);
    }
    
    if ([cell conformsToProtocol:@protocol(TFTableDescriptorConfigurableCellProtocol)]) {
        [cell configureWithData:row.data];
    }
    
    if ([cell respondsToSelector:@selector(delegate)]) {
        [cell setValue:self forKey:@"delegate"];
    }
    
    cell.rowDescriptor = row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableDescriptor:didSelectRow:)]) {
        [self.delegate tableDescriptor:self didSelectRow:[self rowAtIndexPath:indexPath]];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TFSectionDescriptor *sectionDescriptor = [self sectionAtSectionIndex:section];
    
    TFBasicDescriptedHeaderFooterView *view = nil;
    
    if (sectionDescriptor.sectionClass) {
    
        view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:[sectionDescriptor.sectionClass performSelector:@selector(identifier)]];
    } else {
        return nil;
    }
    
    view.sectionDescriptor = sectionDescriptor;
    
    
    if ([view conformsToProtocol:@protocol(TFTableDescriptorHeaderFooterProtocol)]) {
        if (sectionDescriptor.attributedTitle) {
            [view configureWithData:sectionDescriptor.attributedTitle];
        } else if (sectionDescriptor.title) {
            [view configureWithData:sectionDescriptor.title];
        } else if (sectionDescriptor.data) {
            [view configureWithData:sectionDescriptor.data];
        }
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    TFSectionDescriptor *sectionDescriptor = [self sectionAtSectionIndex:section];
    
    if ([sectionDescriptor.sectionClass respondsToSelector:@selector(height)]) {
        return [[sectionDescriptor.sectionClass performSelector:@selector(height)] floatValue];
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(tableDescriptor:heightForSection:)]) {
        return [self.delegate tableDescriptor:self heightForSection:sectionDescriptor];
    } else {
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    RestaurantFooter *footer = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:[RestaurantFooter identifier]];
//    
//    return footer;
//}


@end

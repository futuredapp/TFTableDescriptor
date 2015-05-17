//
//  SectionDescriptor.m
//  Restu
//
//  Created by Aleš Kocur on 05/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import "TFSectionDescriptor.h"
#import "TFRowDescriptor.h"
#import "TFTableDescriptor.h"

@interface TFSectionDescriptor()

@property (nonatomic, strong) NSMutableArray *rows;
@property (weak) id target;
@property (nonatomic) SEL selector;

@end

@implementation TFSectionDescriptor

+ (instancetype)descriptorWithData:(id)data {
    TFSectionDescriptor *descriptor = [[TFSectionDescriptor alloc] init];
    descriptor.data = data;
    return descriptor;
}

+ (instancetype)descriptorWithTag:(NSInteger)tag data:(id)data {
    TFSectionDescriptor *descriptor = [[TFSectionDescriptor alloc] init];
    descriptor.tag = tag;
    descriptor.data = data;
    return descriptor;
}

#pragma mark - Adding row

- (void)addRow:(TFRowDescriptor *)rowDescriptor {
    [self.rows addObject:rowDescriptor];
    rowDescriptor.section = self;
}

- (void)addRowToTop:(TFRowDescriptor *)rowDescriptor {
    [self.rows insertObject:rowDescriptor atIndex:0];
    rowDescriptor.section = self;
}

- (void)addRowToBottom:(TFRowDescriptor *)rowDescriptor {
    [self.rows addObject:rowDescriptor];
    rowDescriptor.section = self;
}

- (void)addRow:(TFRowDescriptor *)row afterRow:(TFRowDescriptor *)afterRow {
    
    NSUInteger index = [self.rows indexOfObject:afterRow];
    
    // Return method unless index found
    if (index == NSNotFound) {
        NSLog(@"Trying add row into wrong section!");
        return ;
    }
    
    if (index == self.rows.count - 1) {
        [self addRowToBottom:row];
    } else {
        [self.rows insertObject:row atIndex:index + 1];
    }
    
    row.section = self;
    
}

- (void)addRow:(TFRowDescriptor *)row inFronOfRow:(TFRowDescriptor *)inFrontOfRow {
    
    NSUInteger index = [self.rows indexOfObject:inFrontOfRow];
    
    // Return method unless index found
    if (index == NSNotFound) {
        NSLog(@"Trying add row into wrong section!");
        return ;
    }
    
    [self.rows insertObject:row atIndex:index];
    row.section = self;
}

#pragma mark - Deleting rows

- (void)removeRow:(TFRowDescriptor *)rowDescriptor {
    if ([self.rows containsObject:rowDescriptor]) {
        [self.rows removeObject:rowDescriptor];
    }
}

#pragma mark - Actions 

- (void)setTarget:(id)target withSelector:(SEL)selector {
    self.selector = selector;
    self.target = target;
}

- (void)triggerAction:(TFAction *)action {
    
    if (self.target && self.selector) {
        if ([self.target respondsToSelector:self.selector]) {
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.selector withObject:action];
#pragma clang diagnostic pop
            
        }
        
    }
    
    if (self.actionBlock) {
        self.actionBlock(action);
    }
    
}

#pragma mark - Data source

- (NSInteger)numberOfRows {
    return self.rows.count;
}

- (TFRowDescriptor *)rowAtRowIndex:(NSInteger)rowIndex {
    return self.rows[rowIndex];
}

- (NSMutableArray *)rows {
    if (!_rows) {
        _rows = [@[] mutableCopy];
    }
    
    return _rows;
}

- (NSArray *)allRows {
    return [self.rows copy];
}

#pragma mark - Visibility

- (NSArray *)allVisibleRows{
    return [[self allRows] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hidden = NO"]];
}
- (NSInteger)numberOfVisibleRows{
    return [self allVisibleRows].count;
}
- (TFRowDescriptor *)visibleRowAtRowIndex:(NSInteger)rowIndex{
    return self.allVisibleRows[rowIndex];
}

-(void)setHidden:(BOOL)hidden withRowAnimation:(UITableViewRowAnimation)rowAnimation{
    if(hidden == _hidden)return;

    if (hidden) {
        [self.tableDescriptor addSectionForDeleting:self rowAnimation:rowAnimation];
    }else{
        [self.tableDescriptor addSectionForInserting:self rowAnimation:rowAnimation];
    }
//    NSInteger deleteSectionIndex = NSNotFound;
//    NSInteger insertSectionIndex = NSNotFound;
//    
//    if (hidden) {
//        deleteSectionIndex = [[self.tableDescriptor allVisibleSections] indexOfObject:self];
//    }
//    
//    _hidden = hidden;
//    
//    if (!hidden) {
//        insertSectionIndex = [[self.tableDescriptor allVisibleSections] indexOfObject:self];
//    }
//
//    if(deleteSectionIndex != NSNotFound)[self.tableDescriptor.tableView deleteSections:[NSIndexSet indexSetWithIndex:deleteSectionIndex] withRowAnimation:rowAnimation];
//    if(insertSectionIndex != NSNotFound)[self.tableDescriptor.tableView insertSections:[NSIndexSet indexSetWithIndex:insertSectionIndex] withRowAnimation:rowAnimation];
}




@end

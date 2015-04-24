//
//  SectionDescriptor.m
//  Restu
//
//  Created by Aleš Kocur on 05/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import "TFSectionDescriptor.h"
#import "TFRowDescriptor.h"

@interface TFSectionDescriptor()

@property (nonatomic, strong) NSMutableArray *rows;

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

@end

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

+ (instancetype)descriptorWithTitle:(NSString *)title {
    TFSectionDescriptor *descriptor = [[TFSectionDescriptor alloc] init];
    descriptor.title = title;
    return descriptor;
}

+ (instancetype)descriptorWithTag:(NSInteger)tag title:(NSString *)title {
    TFSectionDescriptor *descriptor = [[TFSectionDescriptor alloc] init];
    descriptor.tag = tag;
    descriptor.title = title;
    return descriptor;
}

+ (instancetype)descriptorWithTag:(NSInteger)tag attributedTitle:(NSAttributedString *)attrTitle {
    TFSectionDescriptor *descriptor = [[TFSectionDescriptor alloc] init];
    descriptor.tag = tag;
    descriptor.attributedTitle = attrTitle;
    return descriptor;
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

- (void)addRow:(TFRowDescriptor *)rowDescriptor {
    [self.rows addObject:rowDescriptor];
}

- (NSInteger)numberOfRows {
    return self.rows.count;
}

- (TFRowDescriptor *)rowAtRowIndex:(NSInteger)rowIndex {
    return self.rows[rowIndex];
}

@end

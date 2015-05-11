//
//  RowDescriptor.m
//  Restu
//
//  Created by Aleš Kocur on 05/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import "TFRowDescriptor.h"

#import "TFSectionDescriptor.h"
#import "TFTableDescriptor.h"

@interface TFRowDescriptor ()

@property (weak) id target;
@property (nonatomic) SEL selector;



@end

@implementation TFRowDescriptor

+ (instancetype)descriptorWithRowClass:(Class)rowClass data:(id)data {
    TFRowDescriptor *descriptor = [[TFRowDescriptor alloc] init];
    
    descriptor.rowClass = rowClass;
    descriptor.data = data;
    
    return descriptor;
}

+ (instancetype)descriptorWithRowClass:(Class)rowClass data:(id)data tag:(NSString *)tag {
    TFRowDescriptor *row = [TFRowDescriptor descriptorWithRowClass:rowClass data:data];
    row.tag = tag;
    
    return row;
}

- (void)setTarget:(id)target withSelector:(SEL)selector {
    self.selector = selector;
    self.target = target;
}

- (BOOL)canTriggerAction {
    return (self.selector != nil && self.target != nil) || self.actionBlock;
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

#pragma mark - Visibility

- (void)setHidden:(BOOL)hidden {
    [self setHidden:hidden withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)setHidden:(BOOL)hidden withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    
    if (_hidden == hidden) {
        return;
    }
    
    NSIndexPath *indexPathToDelete = nil;
    NSIndexPath *indexPathToInsert = nil;
    
    if (hidden) {
        indexPathToDelete = [self.section.tableDescriptor indexPathForVisibleRow:self];
    }
    
    _hidden = hidden;

    if (!hidden) {
        indexPathToInsert = [self.section.tableDescriptor indexPathForVisibleRow:self];
    }

    if (indexPathToInsert) {
        [self.section.tableDescriptor.tableView insertRowsAtIndexPaths:@[indexPathToInsert] withRowAnimation:rowAnimation];
    }
    if (indexPathToDelete) {
        [self.section.tableDescriptor.tableView deleteRowsAtIndexPaths:@[indexPathToDelete] withRowAnimation:rowAnimation];
    }
}

@end

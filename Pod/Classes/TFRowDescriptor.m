//
//  RowDescriptor.m
//  Restu
//
//  Created by Aleš Kocur on 05/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import "TFRowDescriptor.h"

@implementation TFRowAction

+ (instancetype)actionWithSender:(id)sender type:(NSInteger)type {
    TFRowAction *action = [[TFRowAction alloc] init];
    action.sender = sender;
    action.type = type;
    return action;
}

@end

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

- (void)triggerAction:(TFRowAction *)action {
    
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

@end

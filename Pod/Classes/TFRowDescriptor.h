//
//  RowDescriptor.h
//  Restu
//
//  Created by Aleš Kocur on 05/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFSectionDescriptor;

@interface TFRowAction : NSObject

@property (nonatomic, strong) id sender;
@property NSInteger type;

+ (instancetype)actionWithSender:(id)sender type:(NSInteger)type;

@end


@interface TFRowDescriptor : NSObject

@property (nonatomic) Class rowClass;
@property (nonatomic) id data;
@property (nonatomic) NSString *tag;
@property (nonatomic, weak) TFSectionDescriptor *section;
@property (nonatomic, copy) void (^actionBlock)(TFRowAction *action);

@property (nonatomic,getter=isHidden) BOOL hidden;

+ (instancetype)descriptorWithRowClass:(Class)rowClass data:(id)data;
+ (instancetype)descriptorWithRowClass:(Class)rowClass data:(id)data tag:(NSString *)tag;

- (void)setTarget:(id)target withSelector:(SEL)selector;
- (void)setActionBlock:(void(^)(TFRowAction *action))actionBlock;

/// Determine if action can be triggered
- (BOOL)canTriggerAction;
- (void)triggerAction:(TFRowAction *)action;

#pragma mark - Visibility

-(void)setHidden:(BOOL)hidden withRowAnimation:(UITableViewRowAnimation)rowAnimation;

@end

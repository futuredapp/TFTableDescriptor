//
//  TFAction.m
//  Pods
//
//  Created by Aleš Kocur on 07/05/15.
//
//

#import "TFAction.h"

@implementation TFAction

+ (instancetype)actionWithSender:(id)sender type:(NSInteger)type {
    TFAction *action = [[TFAction alloc] init];
    action.sender = sender;
    action.type = type;
    
    return action;
}

+ (instancetype)actionWithSender:(id)sender type:(NSInteger)type data:(id)data {
    TFAction *action = [[self class] actionWithSender:sender type:type];
    action.data = data;
    
    return action;
}

@end

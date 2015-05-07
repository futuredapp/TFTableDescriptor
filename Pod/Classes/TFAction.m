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

@end

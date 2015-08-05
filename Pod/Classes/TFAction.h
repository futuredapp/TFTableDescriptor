//
//  TFAction.h
//  Pods
//
//  Created by Aleš Kocur on 07/05/15.
//
//

#import <Foundation/Foundation.h>

@interface TFAction : NSObject

@property (nonatomic, strong) id sender;
@property NSInteger type;
@property (nonatomic, strong) id data;

+ (instancetype)actionWithSender:(id)sender type:(NSInteger)type;

+ (instancetype)actionWithSender:(id)sender type:(NSInteger)type data:(id)data;


@end

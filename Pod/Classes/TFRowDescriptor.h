//
//  RowDescriptor.h
//  Restu
//
//  Created by Aleš Kocur on 05/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFSectionDescriptor;

@interface TFRowDescriptor : NSObject

@property (nonatomic) Class rowClass;
@property (nonatomic) id data;
@property (nonatomic) NSString *tag;
@property (nonatomic, weak) TFSectionDescriptor *section;

+ (instancetype)descriptorWithRowClass:(Class)rowClass data:(id)data;
+ (instancetype)descriptorWithRowClass:(Class)rowClass data:(id)data tag:(NSString *)tag;

@end

//
//  RowDescriptor.m
//  Restu
//
//  Created by Aleš Kocur on 05/04/15.
//  Copyright (c) 2015 The Funtasty. All rights reserved.
//

#import "TFRowDescriptor.h"

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

@end

//
//  TFViewController.m
//  TFTableDescriptor
//
//  Created by Ales Kocur on 04/11/2015.
//  Copyright (c) 2014 Ales Kocur. All rights reserved.
//

#import "TFViewController.h"

#import <TFTableDescriptor/TFTableDescriptor.h>
#import "MyCustomCell.h"
#import "MyDynamicCustomCell.h"
#import "MyHeaderView.h"

typedef NS_ENUM(NSUInteger, TableSectionTag) {
    TableSectionTagStaticRows,
    TableSectionTagDynamicRows
};

static NSString * const kRowTagStaticTest = @"RowTagStaticTest";

@interface TFViewController ()<TFTableDescriptorProtocol>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TFTableDescriptor *tableDescriptor;

@end

@implementation TFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell which we are going to use (you should use these macros)
    REGISTER_CELL_FOR_TABLE(MyCustomCell, self.tableView);
    REGISTER_CELL_FOR_TABLE(MyDynamicCustomCell, self.tableView);
    REGISTER_HEADER_FOOTER_FOR_TABLE(MyHeaderView, self.tableView);
    
    // Create base descriptor with table
    TFTableDescriptor *table = [TFTableDescriptor descriptorWithTable:self.tableView];
    
    TFSectionDescriptor *section;
    TFRowDescriptor *row;
    
    // Describe table
    
    // Create section
    section = [TFSectionDescriptor descriptorWithTag:TableSectionTagStaticRows title:@"Section with static rows"];
    // Set class of header
    section.sectionClass = [MyHeaderView class];
    
    // Create row and add it to section
    row = [TFRowDescriptor descriptorWithRowClass:[MyCustomCell class] data:@"Static row 1"];
    [section addRow:row];
    
    // Create second row with tag for recognition if selected for example
    row = [TFRowDescriptor descriptorWithRowClass:[MyCustomCell class] data:@"Static row with tag" tag:kRowTagStaticTest];
    [section addRow:row];
    
    // Add section into table
    [table addSection:section];
    
    // Create another section
    section = [TFSectionDescriptor descriptorWithTag:TableSectionTagDynamicRows title:@"Section with dynamic rows"];
    section.sectionClass = [MyHeaderView class];
    
    // Create MyDynamicCustomCell cell
    row = [TFRowDescriptor descriptorWithRowClass:[MyDynamicCustomCell class] data:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis consectetur bibendum gravida. Aliquam vel augue non massa euismod pharetra. Vivamus euismod ullamcorper velit."];
    [section addRow:row];
    
    [table addSection:section];
    
    // Save reference for it
    self.tableDescriptor = table;
    
    // Set delegate if you want
    self.tableDescriptor.delegate = self;
    
}

#pragma mark - TFTableDescriptorProtocol

- (void)tableDescriptor:(TFTableDescriptor *)descriptor didSelectRow:(TFRowDescriptor *)rowDescriptor {
    
    UITableViewCell *cell = [self.tableDescriptor cellForRow:rowDescriptor];
    
    if (rowDescriptor.tag) {
        NSLog(@"Did select row with tag: %@ data: %@", rowDescriptor.tag, rowDescriptor.data);
        
        if ([rowDescriptor.tag isEqualToString:kRowTagStaticTest]) {
            // Do something with cell
            ((MyCustomCell *)cell).titleLabel.text = [NSString stringWithFormat:@"%@%@",((MyCustomCell *)cell).titleLabel.text, @"A"];
        }
    }
    
}

@end

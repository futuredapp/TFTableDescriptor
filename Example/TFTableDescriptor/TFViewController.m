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

#define LONG_TEXT @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis consectetur bibendum gravida. Aliquam vel augue non massa euismod pharetra. Vivamus euismod ullamcorper velit."
#define SHORT_TEXT @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis consectetur bibendum gravida."

typedef NS_ENUM(NSUInteger, TableSectionTag) {
    TableSectionTagStaticRows,
    TableSectionTagDynamicRows
};

static NSString * const kRowTagAddAtTop = @"RowTagAddAtTop";
static NSString * const kRowTagAddToBottom = @"RowTagAddToBottom";
static NSString * const kRowTagAddInFrontOfRow = @"RowTagAddInFrontOfRow";
static NSString * const kRowTagAddAfterRow = @"RowTagAddAfterRow";

static NSString * const kRowMyDynamicCell = @"RowMyDynamicCell";
static NSString * const kRowTagCellForRemove = @"RowTagCellForRemove";

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
    row = [TFRowDescriptor descriptorWithRowClass:[MyCustomCell class] data:@"Add row at top" tag:kRowTagAddAtTop];
    [section addRow:row];
    
    // Create second row with tag for recognition if selected for example
    row = [TFRowDescriptor descriptorWithRowClass:[MyCustomCell class] data:@"Add row at bottom" tag:kRowTagAddToBottom];
    [section addRow:row];
    
    row = [TFRowDescriptor descriptorWithRowClass:[MyCustomCell class] data:@"Add row in front of second row" tag:kRowTagAddInFrontOfRow];
    [section addRow:row];
    
    row = [TFRowDescriptor descriptorWithRowClass:[MyCustomCell class] data:@"Add row after first row" tag:kRowTagAddAfterRow];
    [section addRow:row];
    
    row = [TFRowDescriptor descriptorWithRowClass:[MyCustomCell class] data:@"Remove from top" tag:kRowTagCellForRemove];
    [section addRow:row];

    
    // Add section into table
    [table addSection:section];
    
    // Create another section
    section = [TFSectionDescriptor descriptorWithTag:TableSectionTagDynamicRows title:@"Section with dynamic rows"];
    section.sectionClass = [MyHeaderView class];
    
    // Create MyDynamicCustomCell cell
    row = [TFRowDescriptor descriptorWithRowClass:[MyDynamicCustomCell class] data:LONG_TEXT tag:kRowMyDynamicCell];
    [section addRow:row];
    
    
    [table addSection:section];
    
    // Save reference for it
    self.tableDescriptor = table;
    
    // Set delegate if you want
    self.tableDescriptor.delegate = self;
    
}

#pragma mark - TFTableDescriptorProtocol

- (void)tableDescriptor:(TFTableDescriptor *)descriptor didSelectRow:(TFRowDescriptor *)rowDescriptor {
    
//    UITableViewCell *cell = [self.tableDescriptor cellForRow:rowDescriptor];
    
    if (rowDescriptor.tag) {
        NSLog(@"Did select row with tag: %@ data: %@", rowDescriptor.tag, rowDescriptor.data);
        
        if ([rowDescriptor.tag isEqualToString:kRowTagAddAtTop]) {
            // Do something with cell
            //((MyCustomCell *)cell).titleLabel.text = [NSString stringWithFormat:@"%@%@",((MyCustomCell *)cell).titleLabel.text, @"A"];
            
            [self.tableDescriptor insertRow:[TFRowDescriptor descriptorWithRowClass:[MyDynamicCustomCell class] data:@"TOP"] atTopOfSection:[self.tableDescriptor sectionForTag:TableSectionTagDynamicRows]];
            
        } else if ([rowDescriptor.tag isEqualToString:kRowTagAddToBottom]) {
            
            [self.tableDescriptor insertRow:[TFRowDescriptor descriptorWithRowClass:[MyDynamicCustomCell class] data:@"BOTTOM"] atBottomOfSection:[self.tableDescriptor sectionForTag:TableSectionTagDynamicRows]];
        } else if ([rowDescriptor.tag isEqualToString:kRowTagAddInFrontOfRow]) {
            
            TFRowDescriptor *inFrontOfRow = [self.tableDescriptor rowForTag:kRowMyDynamicCell];
            
            if (inFrontOfRow) {
                [self.tableDescriptor insertRow:[TFRowDescriptor descriptorWithRowClass:[MyCustomCell class] data:@"IN FRONT OF CELL"] inFrontOfRow:inFrontOfRow rowAnimation:UITableViewRowAnimationLeft];
            } else {
                NSLog(@"kRowMyDynamicCell not found");
            }
            
        } else if ([rowDescriptor.tag isEqualToString:kRowTagAddAfterRow]) {
            
            TFRowDescriptor *afterRow = [self.tableDescriptor rowForTag:kRowMyDynamicCell];
            
            if (afterRow) {
                [self.tableDescriptor insertRow:[TFRowDescriptor descriptorWithRowClass:[MyCustomCell class] data:@"AFTER CELL"] afterRow:afterRow rowAnimation:UITableViewRowAnimationFade];
            } else {
                NSLog(@"kRowMyDynamicCell not found");
            }
            
        } else if ([rowDescriptor.tag isEqualToString:kRowTagCellForRemove]) {
            
            TFRowDescriptor *row = [[[self.tableDescriptor sectionForTag:TableSectionTagDynamicRows] allRows] firstObject];
            
            if (row && ![row.tag isEqualToString:kRowMyDynamicCell]) {
                [self.tableDescriptor removeRow:row rowAnimation:UITableViewRowAnimationRight];
            } else {
                NSLog(@"No rows to delete");
            }
            
            
        }
        
    }
    
}

// If you want handle header heights by yourself

//- (CGFloat)tableDescriptor:(TFTableDescriptor *)descriptor heightForSection:(TFSectionDescriptor *)sectionDescriptor {
//    if (sectionDescriptor.tag == TableSectionTagStaticRows) {
//        return 42.0;
//    } else if (sectionDescriptor.tag == TableSectionTagDynamicRows) {
//        return 46.0;
//    }
//    
//    return 0.0;
//}

@end

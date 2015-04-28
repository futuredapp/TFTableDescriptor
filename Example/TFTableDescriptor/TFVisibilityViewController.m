//
//  TFVisibilityViewController.m
//  TFTableDescriptor
//
//  Created by Jakub Knejzlik on 28/04/15.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//

#import "TFVisibilityViewController.h"

#import "tftableDescriptor.h"
#import "MyVisibilityCell.h"

@interface TFVisibilityViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TFTableDescriptor *tableDescriptor;
@end

@implementation TFVisibilityViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"Actions";
    
    REGISTER_CELL_FOR_TABLE(MyVisibilityCell, self.tableView);
    
    // Create base descriptor with table
    TFTableDescriptor *table = [TFTableDescriptor descriptorWithTable:self.tableView];
    
    // Describe table
    
    self.tableDescriptor = table;
    
    [self addSectionWithSomeRows];
    [self addSectionWithSomeRows];
}

- (void)addSectionWithSomeRows{
    TFSectionDescriptor *section = [TFSectionDescriptor descriptorWithTag:0 data:@"Section with buttons"];
    
    int l = arc4random()%3+2;
    for (int x = 0; x < l; x++) {
        TFRowDescriptor *row = [TFRowDescriptor descriptorWithRowClass:[MyVisibilityCell class] data:nil];
        [row setActionBlock:^(TFRowAction *action) {
            TFRowDescriptor *rowDescriptor = (TFRowDescriptor *)action.sender;
            rowDescriptor.hidden = YES;
        }];
        [section addRow:row];
    }
    
    [self.tableDescriptor addSection:section];
}
- (IBAction)showAllRows:(id)sender {
    for (TFRowDescriptor *row in [self.tableDescriptor allRows]) {
        row.hidden = NO;
    }
}

@end

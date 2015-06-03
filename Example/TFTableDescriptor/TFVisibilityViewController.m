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
    [self addSectionWithRows:arc4random()%3+2];
}
- (void)addSectionWithRows:(int)count{
    TFSectionDescriptor *section = [TFSectionDescriptor descriptorWithTag:0 data:@"Section with buttons"];
    
    int l = count;
    for (int x = 0; x < l; x++) {
        TFRowDescriptor *row = [TFRowDescriptor descriptorWithRowClass:[MyVisibilityCell class] data:nil];
        __weak TFRowDescriptor *weakrow = row;
        [row setActionBlock:^(TFAction *action) {
            [self.tableDescriptor beginUpdates];
//            TFRowDescriptor *rowDescriptor = [self.tableDescriptor rowAtIndexPath:[self.tableView indexpath]];
//            NSLog(@"%@",[self.tableDescriptor indexPathForRow:row]);
            [weakrow setHidden:YES withRowAnimation:UITableViewRowAnimationFade];
            [self.tableDescriptor endUpdates];
        }];
        [section addRow:row];
    }
    
    [self.tableDescriptor addSection:section];
}
- (IBAction)showAllRows:(id)sender {
    [self.tableDescriptor updateVisibilityWithBlock:^{
        TFSectionDescriptor *section = [[self.tableDescriptor allSections] firstObject];
        [section setHidden:!section.hidden withRowAnimation:UITableViewRowAnimationFade];
    }];
//    [self.tableDescriptor beginUpdates];
//    TFSectionDescriptor *section = [[self.tableDescriptor allSections] firstObject];
//    [section setHidden:!section.hidden withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableDescriptor endUpdates];
//    for (TFRowDescriptor *row in [self.tableDescriptor allRows]) {
//        row.hidden = NO;
//    }
//    [self.tableView reloadData];
}

@end

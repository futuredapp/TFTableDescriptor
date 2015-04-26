//
//  TFButtonsViewController.m
//  TFTableDescriptor
//
//  Created by Jakub Knejzlik on 25/04/15.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//

#import "TFActionsViewController.h"

#import <TFTableDescriptor/TFTableDescriptor.h>
#import "MyButtonCell.h"
#import "MyWideButtonCell.h"
#import "MyControlsCell.h"
#import "MySliderCell.h"

@interface TFActionsViewController () <TFTableDescriptorDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TFTableDescriptor *tableDescriptor;
@end

@implementation TFActionsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"Actions";
    
    REGISTER_CELL_FOR_TABLE(MyButtonCell, self.tableView);
    REGISTER_CELL_FOR_TABLE(MyWideButtonCell, self.tableView);
    REGISTER_CELL_FOR_TABLE(MyControlsCell, self.tableView);
    REGISTER_CELL_FOR_TABLE(MySliderCell, self.tableView);

    // Create base descriptor with table
    TFTableDescriptor *table = [TFTableDescriptor descriptorWithTable:self.tableView];
    
    TFSectionDescriptor *section;
    TFRowDescriptor *row;
    
    // Describe table
    section = [TFSectionDescriptor descriptorWithTag:0 data:@"Section with buttons"];

    
    // wide button
    
    row = [TFRowDescriptor descriptorWithRowClass:[MyWideButtonCell class] data:nil tag:nil];
    [row setActionBlock:^(TFRowAction *action) {
        [self showAlert:@"Button action triggered" withAction:action];
    }];
    
    [section addRow:row];
    
    
    // buttons
    
    row = [TFRowDescriptor descriptorWithRowClass:[MyButtonCell class] data:nil tag:nil];
    [row setActionBlock:^(TFRowAction *action) {
        
        if (action.actionType != MyButtonCellActionTypeTriggerButton2) {
            [self showAlert:@"This message was triggered by block" withAction:action];
        }
        
    }];
    
    [row setTarget:self withSelector:@selector(cellActionTrigger:)];
    
    [section addRow:row];
    
    
    // controls
    row = [TFRowDescriptor descriptorWithRowClass:[MyControlsCell class] data:nil];
    [row setActionBlock:^(TFRowAction *action) {
        if (action.actionType == MyControlsCellActionTypeSwitch) {
            [self showAlert:@"Switch action triggered" withAction:action];
        }else if (action.actionType == MyControlsCellActionTypeSegmend){
            [self showAlert:@"Segment action triggered" withAction:action];
        }
    }];
    
    [section addRow:row];
    
    
    // slider
    row = [TFRowDescriptor descriptorWithRowClass:[MySliderCell class] data:nil];
    [row setActionBlock:^(TFRowAction *action) {
        if ([action.sender isKindOfClass:[UISlider class]]) {
            UISlider *slider = (UISlider *)action.sender;
            self.tableView.alpha = slider.value;
            [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHue:slider.value saturation:1 brightness:1 alpha:1]}];
        }
    }];
    
    [section addRow:row];
    
    [table addSection:section];
    
    self.tableDescriptor = table;
}

- (void)cellActionTrigger:(TFRowAction *)action {
    if (action.actionType == MyButtonCellActionTypeTriggerButton2) {
        [self showAlert:@"This message was triggered by selector on button" withAction:action];
    }
}

-(void)showAlert:(NSString *)alert withAction:(TFRowAction *)action{
    NSString *suffix;
    if([action.sender isKindOfClass:[UIButton class]]){
        suffix = [NSString stringWithFormat:@"button: %@",[(UIButton *)action.sender titleForState:UIControlStateNormal]];
    }
    if([action.sender isKindOfClass:[UISwitch class]]){
        suffix = [NSString stringWithFormat:@"switch: %@",[(UISwitch *)action.sender isOn]?@"On":@"Off"];
    }
    if ([action.sender isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *segmentedControl = (UISegmentedControl *)action.sender;
        suffix = [NSString stringWithFormat:@"segment: %@",[segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex]];
    }
    [[[UIAlertView alloc] initWithTitle:@"Action info" message:[alert stringByAppendingFormat:@", %@",suffix] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
}

@end

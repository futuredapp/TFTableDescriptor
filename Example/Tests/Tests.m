//
//  TFTableDescriptorTests.m
//  TFTableDescriptorTests
//
//  Created by Ales Kocur on 04/11/2015.
//  Copyright (c) 2014 Ales Kocur. All rights reserved.
//

#import <TFTableDescriptor.h>
#import "MyCustomCell.h"

SPEC_BEGIN(TFTableDescriptorSpec)

describe(@"TFTableDescriptor", ^{

  context(@"properties states", ^{

      __block UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 200) style:UITableViewStylePlain];
      
      let(table, ^id{
          
          REGISTER_CELL_FOR_TABLE(MyCustomCell, tableView);
          
          TFTableDescriptor *table = [TFTableDescriptor descriptorWithTable:tableView];
          TFSectionDescriptor *section = [TFSectionDescriptor descriptorWithTag:1234 title:@"title"];
          [section addRow:[TFRowDescriptor descriptorWithRowClass:[MyCustomCell class] data:@"data" tag:@"rowtag"]];
          [table addSection:section];
          [tableView reloadData];
          
          return table;
      });
      
      
      it(@"exists", ^{
          [[table should] beNonNil];
      });

      it(@"have row with tag", ^{
          [[[table rowForTag:@"rowtag"] should] beNonNil];
      });
      
      specify(^{
          [[[table rowForTag:@"abcf1234"] should] beNil];
      });
      
      it(@"have section with tag", ^{
          [[[table sectionForTag:1234] should] beNonNil];
      });
      
      specify(^{
          [[[table sectionForTag:123333] should] beNil];
      });
      
      it(@"have one section", ^{
          [[theValue([table numberOfSections]) should] equal:theValue(1)];
      });
      
      it(@"have one row", ^{
          [[theValue([[table sectionForTag:1234] numberOfRows]) should] equal:theValue(1)];
      });
      
      it(@"can delete row", ^{
          [[theValue([[table sectionForTag:1234] numberOfRows]) should] equal:theValue(1)];
          [table removeRowWithTag:@"rowtag"];
          [[theValue([[table sectionForTag:1234] numberOfRows]) should] equal:theValue(0)];
      });
      
      it(@"can insert row", ^{
          [[theValue([[table sectionForTag:1234] numberOfRows]) should] equal:theValue(1)];
          [table insertRow:[TFRowDescriptor descriptorWithRowClass:[MyCustomCell class] data:@"insert" tag:@"insertedRow"] atBottomOfSection:[table sectionForTag:1234]];
          [[theValue([[table sectionForTag:1234] numberOfRows]) should] equal:theValue(2)];
      });
      
      it(@"can translate row into indexPath", ^{
          [[[table indexPathForRowTag:@"rowtag"] should] equal:[NSIndexPath indexPathForRow:0 inSection:0]];
      });
      
      it(@"can insert row in front of row", ^{
          [[theValue([[table sectionForTag:1234] numberOfRows]) should] equal:theValue(1)];
          
          [table insertRow:[TFRowDescriptor descriptorWithRowClass:[MyCustomCell class] data:@"insert" tag:@"insertedRow"] inFrontOfRow:[table rowForTag:@"rowtag"]];
          NSIndexPath *insertedRowIndexPath = [table indexPathForRowTag:@"insertedRow"];
          NSIndexPath *targetRowIndexPath = [table indexPathForRowTag:@"rowtag"];
          
          [[theValue(insertedRowIndexPath.row) should] equal:theValue(targetRowIndexPath.row - 1)];
          [[theValue([[table sectionForTag:1234] numberOfRows]) should] equal:theValue(2)];
          
      });
      
      it(@"can insert row after row", ^{
          [[theValue([[table sectionForTag:1234] numberOfRows]) should] equal:theValue(1)];
          
          [table insertRow:[TFRowDescriptor descriptorWithRowClass:[MyCustomCell class] data:@"insert" tag:@"insertedRow"] afterRow:[table rowForTag:@"rowtag"]];
          NSIndexPath *insertedRowIndexPath = [table indexPathForRowTag:@"insertedRow"];
          NSIndexPath *targetRowIndexPath = [table indexPathForRowTag:@"rowtag"];
          
          [[theValue(insertedRowIndexPath.row) should] equal:theValue(targetRowIndexPath.row + 1)];
          [[theValue([[table sectionForTag:1234] numberOfRows]) should] equal:theValue(2)];
          
      });
      
      
  });

  
});

SPEC_END

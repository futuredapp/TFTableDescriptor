# TFTableDescriptor

[![CI Status](https://travis-ci.org/thefuntasty/TFTableDescriptor.svg?branch=master)](https://travis-ci.org/thefuntasty/TFTableDescriptor)
[![Version](https://img.shields.io/cocoapods/v/TFTableDescriptor.svg?style=flat)](http://cocoapods.org/pods/TFTableDescriptor)
[![License](https://img.shields.io/cocoapods/l/TFTableDescriptor.svg?style=flat)](http://cocoapods.org/pods/TFTableDescriptor)
[![Platform](https://img.shields.io/cocoapods/p/TFTableDescriptor.svg?style=flat)](http://cocoapods.org/pods/TFTableDescriptor)

## Documentation
* [Creating cell](https://github.com/thefuntasty/TFTableDescriptor/wiki/Creating-cells)
* [Describing a table](https://github.com/thefuntasty/TFTableDescriptor/wiki/Describing-a-table)

## Quick usage

TFTableDescriptor allows you to describe how your table content should be assembled.

```objective-c
TFTableDescriptor *table = [TFTableDescriptor descriptorWithTable:self.tableView];
TFSectionDescriptor *section;
TFRowDescriptor *row;

section = [TFSectionDescriptor descriptorWithTag:TableSectionTagStaticRows title:@"Section with static rows"];

section.sectionClass = [MyHeaderView class];
row = [TFRowDescriptor descriptorWithRowClass:[MyCustomCell class] data:@"Static row with tag" tag:kRowTagStaticTest];
[section addRow:row];

[table addSection:section];

section = [TFSectionDescriptor descriptorWithTag:TableSectionTagDynamicRows title:@"Section with dynamic rows"];
section.sectionClass = [MyHeaderView class];

row = [TFRowDescriptor descriptorWithRowClass:[MyDynamicCustomCell class] data:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis consectetur bibendum gravida. Aliquam vel augue non massa euismod pharetra. Vivamus euismod ullamcorper velit."];
[section addRow:row];

[table addSection:section];

self.tableDescriptor = table
```
The result might look like this:

<img src="https://github.com/thefuntasty/TFTableDescriptor/blob/master/screenshot1.png" width=300px />

### Cells

In the first place, you need to create cells. TFTableDescriptor provides only base cells and they must be subclassed. Cell by *TFBasicDescriptedCell* and headers by *TFBasicDescriptedHeaderFooterView*. Take a look at the example if you want to create them with xib and don't know how.

```objective-c
#import "TFBasicDescriptedCell.h"

@interface MyCustomCell : TFBasicDescriptedCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end
```
You also need register them to UITableView with provided macros

```objective-c

REGISTER_CELL_FOR_TABLE(MyButtonCell, self.tableView);
REGISTER_HEADER_FOOTER_FOR_TABLE(MyHeaderView, self.tableView);

```

If you want them configure with data, you have to implement *TFTableDescriptorConfigurableCellProtocol*'s protocol method 

```objective-c
- (void)configureWithData:(id)data {
    
    // If we have suitable data for this cell
    if ([data isKindOfClass:[NSString class]]) {
        // configure cell
        self.titleLabel.text = data;
    }
    
}
```

If your cell height is static, you should implement **+(NSNumber *)height** method as well,

```objective-c
+ (NSNumber *)height {
    return @44.0;
}
```

otherwise the height is calculated by autolayout -> it supports dynamic height of cells. The only thing you need to do is set up your autolayout right. That means there should be contraints upside down and from left to right.

<img src="https://github.com/thefuntasty/TFTableDescriptor/blob/master/screenshot2.png" width=300px />

If you need support iOS7 and different screensizes, you should use TFExplicitLabel (UILabel subclass) anywhere you have more than 1 lines. This is important for the right autolayout calculation with different display sizes.

### Selecting cells

You can access selected cell's descriptor by *TFTableDescriptor* delegate method. If you want to access its cell, use tableDescriptor's cellForRow: method.

```objective-c
- (void)tableDescriptor:(TFTableDescriptor *)descriptor didSelectRow:(TFRowDescriptor *)rowDescriptor {
    UITableViewCell *cell = [self.tableDescriptor cellForRow:rowDescriptor];
}
```

### Inserting and removing cells

You can also insert or remove cell from table according to its tag or row descriptor.

```objective-c
[self.tableDescriptor insertRow:[TFRowDescriptor descriptorWithRowClass:[MyCustomCell class] data:@"IN FRONT OF CELL"] inFrontOfRow:inFrontOfRow rowAnimation:UITableViewRowAnimationLeft];

[self.tableDescriptor removeRow:row rowAnimation:UITableViewRowAnimationRight];
```

Animation type can be changed with rowAnimation parameter.

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## TODO

- cell appearance customization by Row descriptor
- ~~cell blocks and selectors~~
- ~~tests~~
- footer support

## Requirements
iOS 7 and higher

## Installation

TFTableDescriptor is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TFTableDescriptor"
```

## Author

The Funtasty <br>
[www.thefuntasty.com](www.thefuntasty.com)<br>
Ales Kocur, ales@thefuntasty.com

## License

TFTableDescriptor is available under the MIT license. See the LICENSE file for more info.

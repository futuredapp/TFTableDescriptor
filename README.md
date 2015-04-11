# TFTableDescriptor

[![CI Status](http://img.shields.io/travis/Ales Kocur/TFTableDescriptor.svg?style=flat)](https://travis-ci.org/Ales Kocur/TFTableDescriptor)
[![Version](https://img.shields.io/cocoapods/v/TFTableDescriptor.svg?style=flat)](http://cocoapods.org/pods/TFTableDescriptor)
[![License](https://img.shields.io/cocoapods/l/TFTableDescriptor.svg?style=flat)](http://cocoapods.org/pods/TFTableDescriptor)
[![Platform](https://img.shields.io/cocoapods/p/TFTableDescriptor.svg?style=flat)](http://cocoapods.org/pods/TFTableDescriptor)

## Usage

TFTableDescriptor allows you describe how your table content should be assembled.

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
Result might looks like this:

<img src="https://github.com/thefuntasty/TFTableDescriptor/blob/master/screenshot1.png" width=300px />

### Cells

In a first place you need create a cells. TFTableDescriptor provides only base cell and they must be a subclassed. Cell by *TFBasicDescriptedCell* and headers by *TFBasicDescriptedHeaderFooterView*. Take a look at the example if you want to create them with xib and don't know how.

```objective-c
#import "TFBasicDescriptedCell.h"

@interface MyCustomCell : TFBasicDescriptedCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end
```

and if you want them configure with data, you have to implement *TFTableDescriptorConfigurableCellProtocol*'s protocol method 

```objective-c
- (void)configureWithData:(id)data {
    
    // If we have suitable data for this cell
    if ([data isKindOfClass:[NSString class]]) {
        // configure cell
        self.titleLabel.text = data;
    }
    
}
```

If your cell height is static, you should implement **+(NSNumber *)height** method as well

```objective-c
+ (NSNumber *)height {
    return @44.0;
}
```

otherwise the height is calculated by autolayout -> it supports dynamic height of cells. Only thing you need to do is set up your autolayout right. That means there should be contraints upside down and from left to right.

<img src="https://github.com/thefuntasty/TFTableDescriptor/blob/master/screenshot2.png" width=300px />

If you need support iOS7 and different screensizes, you should use TFExplicitLabel (UILabel subclass) anywhere you have more lines than 1. This is important for right autolayout calculation with different display sizes.

### Selecting cells

You can access selected cell's descriptor by *TFTableDescriptor* delegate method. If you want access its cell, use tableDescriptor's cellForRow: method.

```objective-c
- (void)tableDescriptor:(TFTableDescriptor *)descriptor didSelectRow:(TFRowDescriptor *)rowDescriptor {
    UITableViewCell *cell = [self.tableDescriptor cellForRow:rowDescriptor];
}
```


To run the example project, clone the repo, and run `pod install` from the Example directory first.

## TODO

- cell appearance customization by Row descriptor
- default cells for forms
- cell delegates and selectors
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

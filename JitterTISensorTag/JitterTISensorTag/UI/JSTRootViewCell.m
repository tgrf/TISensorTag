//
//  JSTRootViewCell.m
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 01/02/15.
//  ***REMOVED***
//
#import "JSTRootViewCell.h"
#import "UIColor+JSTExtensions.h"
#import "View+MASAdditions.h"

@implementation JSTRootViewCell

const CGFloat JSTRootViewCellIconSize = 64;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor defaultJSTColor];

        _icon = [[UILabel alloc] initWithFrame:CGRectZero];
        _icon.font = [UIFont fontWithName:@"mce_st_icons" size:JSTRootViewCellIconSize];
        _icon.textColor = [UIColor darkJSTColor];
        _icon.textAlignment = NSTextAlignmentCenter;
        _icon.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_icon];

        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }

    return self;
}

- (void)updateConstraints {
    [_icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(0.05f*self.contentView.frame.size.width);
        make.baseline.equalTo(self.contentView.mas_bottom).with.offset(-0.05f*self.contentView.frame.size.width);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];

    [super updateConstraints];
}

@end

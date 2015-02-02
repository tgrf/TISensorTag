//
//  JSTWandView.m
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 23/01/15.
//  ***REMOVED***
//
#import "JSTWandView.h"
#import "View+MASAdditions.h"
#import "JSTDetailsHeaderView.h"
#import "UIColor+JSTExtensions.h"
#import "JSTDetailsFooterView.h"

@implementation JSTWandView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor defaultJSTColor];

        _headerView = [[JSTDetailsHeaderView alloc] initWithFrame:CGRectZero];
        _headerView.iconView.text = @"A";
        _headerView.titleLabel.text = @"Magic wand";
        _headerView.descriptionLabel.text = @"Feel like a wizard and use your magic wand.";
        [self addSubview:_headerView];

        _footerView = [[JSTDetailsFooterView alloc] initWithFrame:CGRectZero];
        [self addSubview:_footerView];

        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }

    return self;
}

- (void)updateConstraints {
    [_headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];

    [_footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
    }];

    [super updateConstraints];
}

@end

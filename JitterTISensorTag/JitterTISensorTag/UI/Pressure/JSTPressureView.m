//
//  JSTPressureView.m
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 01/02/15.
//  ***REMOVED***
//
#import "JSTPressureView.h"
#import "View+MASAdditions.h"
#import "JSTDetailsFooterView.h"
#import "JSTDetailsResultView.h"
#import "JSTDetailsHeaderView.h"
#import "UIColor+JSTExtensions.h"

@implementation JSTPressureView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor defaultJSTColor];

        _headerView = [[JSTDetailsHeaderView alloc] initWithFrame:CGRectZero];
        _headerView.iconView.text = @"T";
        _headerView.titleLabel.text = @"Magic throne";
        _headerView.descriptionLabel.text = @"Check if somebody sat down or not";
        [self addSubview:_headerView];

        _resultView = [[JSTDetailsResultView alloc] initWithFrame:CGRectZero];
        _resultView.resultLabel.text = @"Nobody here";
        [self addSubview:_resultView];

        _footerView = [[JSTDetailsFooterView alloc] initWithFrame:CGRectZero];
        [self addSubview:_footerView];

        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }

    return self;
}

- (void)updateConstraints {
    [super updateConstraints];

    [_headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];

    [_resultView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.footerView.mas_top);
        make.centerX.equalTo(self.mas_centerX);
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

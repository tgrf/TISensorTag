//
//  JSTBlowView.m
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 31/01/15.
//  ***REMOVED***
//

#import <Masonry/View+MASAdditions.h>
#import "JSTBlowView.h"
#import "UIColor+JSTExtensions.h"
#import "JSTDetailsHeaderView.h"
#import "JSTDetailsResultView.h"
#import "JSTDetailsFooterView.h"

@implementation JSTBlowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor defaultJSTColor];

        _headerView = [[JSTDetailsHeaderView alloc] initWithFrame:CGRectZero];
        _headerView.iconView.text = @"C";
        _headerView.titleLabel.text = @"Blow away";
        _headerView.descriptionLabel.text = @"Blow simultaneously to clean all mess!";
        [self addSubview:_headerView];

        _resultView = [[JSTDetailsResultView alloc] initWithFrame:CGRectZero];
        _resultView.resultLabel.text = @"0%";
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

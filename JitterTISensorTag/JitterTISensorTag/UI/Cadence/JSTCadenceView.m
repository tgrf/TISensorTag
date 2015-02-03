//
// Created by Blazej Marcinkiewicz on 20/01/15.
// ***REMOVED***
//

#import <Masonry/View+MASAdditions.h>
#import "JSTCadenceView.h"
#import "UIColor+JSTExtensions.h"
#import "JSTDetailsHeaderView.h"
#import "JSTDetailsFooterView.h"
#import "JSTDetailsResultView.h"

@implementation JSTCadenceView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor defaultJSTColor];

        _headerView = [[JSTDetailsHeaderView alloc] initWithFrame:CGRectZero];
        self.headerView.iconView.text = @"W";
        self.headerView.titleLabel.text = @"Cadence\nSensor";
        self.headerView.descriptionLabel.text = @"Start pedalling and try to keep the target cadence.";
        [self addSubview:self.headerView];

        [self.headerView setNeedsUpdateConstraints];

        _footerView = [[JSTDetailsFooterView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.footerView];

        _resultView = [[JSTDetailsResultView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.resultView];

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

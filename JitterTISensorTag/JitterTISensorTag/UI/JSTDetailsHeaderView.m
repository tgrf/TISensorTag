//
//  JSTDetailsHeaderView.m
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 02/02/15.
//  ***REMOVED***
//
#import <Masonry/View+MASAdditions.h>
#import "JSTDetailsHeaderView.h"
#import "UIColor+JSTExtensions.h"

@implementation JSTDetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _iconView = [[UILabel alloc] init];
        self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
        self.iconView.font = [UIFont fontWithName:@"mce_st_icons" size:100];
        self.iconView.textColor = [UIColor lightJSTColor];
        self.iconView.textAlignment = NSTextAlignmentCenter;
        self.iconView.text = @"";
        [self addSubview:self.iconView];

        _titleLabel = [[UILabel alloc] init];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.textColor = [UIColor lightJSTColor];
        self.titleLabel.font = [UIFont systemFontOfSize:32];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.text = @"";
        [self addSubview:self.titleLabel];

        _descriptionLabel = [[UILabel alloc] init];
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.descriptionLabel.textColor = [UIColor darkJSTColor];
        self.descriptionLabel.font = [UIFont systemFontOfSize:14];
        self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.text = @"";
        [self addSubview:self.descriptionLabel];

        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }

    return self;
}

- (void)updateConstraints {
    CGFloat width = UIScreen.mainScreen.bounds.size.width;

    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0.16f*width);
        make.left.equalTo(self.mas_left).with.offset(0.136f*width);
        make.right.equalTo(self.iconView.mas_left).with.offset(-5);
    }];

    [_iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.mas_right).with.offset(-0.136f*width);
        make.left.equalTo(self.titleLabel.mas_right).with.offset(5);
        make.width.equalTo(@(0.32f*width)).priorityHigh();
    }];

    [_descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).with.offset(0.1f*width);
        make.left.equalTo(self.mas_left).with.offset(0.136f*width);
        make.right.equalTo(self.mas_right).with.offset(-0.136f*width);
        make.bottom.equalTo(self.mas_bottom).with.offset(-0.06f*width);
    }];

    [super updateConstraints];
}

@end

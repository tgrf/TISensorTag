//
//  JSTDetailsFooterView.m
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 02/02/15.
//  ***REMOVED***
//
#import <Masonry/View+MASAdditions.h>
#import "JSTDetailsFooterView.h"
#import "UIColor+JSTExtensions.h"

@interface JSTDetailsFooterView ()
@property (nonatomic, strong, readonly) UILabel *connectionLabel;
@property (nonatomic, strong, readonly) UILabel *connectionIcon;
@end

@implementation JSTDetailsFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _connectionIcon = [[UILabel alloc] init];
        self.connectionIcon.translatesAutoresizingMaskIntoConstraints = NO;
        self.connectionIcon.font = [UIFont fontWithName:@"mce_st_icons" size:53];
        self.connectionIcon.textColor = [UIColor lightJSTColor];
        self.connectionIcon.textAlignment = NSTextAlignmentRight;
        self.connectionIcon.text = @"1";
        [self addSubview:self.connectionIcon];

        _connectionLabel = [[UILabel alloc] init];
        self.connectionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.connectionLabel.textColor = [UIColor lightJSTColor];
        self.connectionLabel.font = [UIFont systemFontOfSize:20];
        self.connectionLabel.textAlignment = NSTextAlignmentLeft;
        self.connectionLabel.numberOfLines = 1;
        self.connectionLabel.text = @"connected";
        [self addSubview:self.connectionLabel];
    }

    return self;
}

- (void)updateConstraints {
    CGFloat width = UIScreen.mainScreen.bounds.size.width;
    [_connectionIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.connectionLabel.mas_left);
        make.centerY.equalTo(self.mas_bottom).with.offset(-0.096f*width);
    }];
    [_connectionIcon setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

    [_connectionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.connectionIcon.mas_right);
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.connectionIcon.mas_centerY);
    }];
    [_connectionLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

@end

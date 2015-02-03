//
//  JSTDetailsResultView.m
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 02/02/15.
//  ***REMOVED***
//
#import <Masonry/View+MASAdditions.h>
#import "JSTDetailsResultView.h"
#import "UIColor+JSTExtensions.h"

@implementation JSTDetailsResultView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.resultLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.resultLabel.adjustsFontSizeToFitWidth = YES;
        self.resultLabel.textColor = [UIColor lightJSTColor];
        self.resultLabel.font = [UIFont systemFontOfSize:87];
        self.resultLabel.textAlignment = NSTextAlignmentCenter;
        self.resultLabel.numberOfLines = 3;
        self.resultLabel.text = @"";
        [self addSubview:_resultLabel];

        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }

    return self;
}

- (void)updateConstraints {
    CGFloat width = UIScreen.mainScreen.bounds.size.width;

    [_resultLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0.06f*width);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).with.offset(-0.06f*width);
    }];

    [super updateConstraints];
}


@end

//
//  JSTWandView.m
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 23/01/15.
//  ***REMOVED***
//
#import "JSTWandView.h"
#import "View+MASAdditions.h"

@implementation JSTWandView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _valuesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.valuesLabel.font = [UIFont systemFontOfSize:30];
        self.valuesLabel.textAlignment = NSTextAlignmentCenter;
        self.valuesLabel.numberOfLines = 0;
        [self addSubview:self.valuesLabel];

        [self updateConstraints];
    }

    return self;
}

- (void)updateConstraints {
    [_valuesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(64);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];

    [super updateConstraints];
}

@end

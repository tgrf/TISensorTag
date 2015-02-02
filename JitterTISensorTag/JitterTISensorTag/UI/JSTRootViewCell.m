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

@interface JSTRootViewCell ()
@property (nonatomic, strong, readonly) UIView *circleBackgroundView;
@end

@implementation JSTRootViewCell

const CGFloat JSTRootViewCellIconSize = 148;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor defaultJSTColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _circleBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _circleBackgroundView.backgroundColor = [UIColor lightJSTColor];
        [self.contentView addSubview:_circleBackgroundView];

        _icon = [[UILabel alloc] initWithFrame:CGRectZero];
        _icon.font = [UIFont fontWithName:@"mce_st_icons" size:JSTRootViewCellIconSize];
        _icon.textColor = [UIColor defaultJSTColor];
        _icon.textAlignment = NSTextAlignmentCenter;
        _icon.translatesAutoresizingMaskIntoConstraints = NO;
        _icon.layer.shouldRasterize = YES;
        [self.contentView addSubview:_icon];

        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }

    return self;
}

- (void)updateConstraints {
    [_icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(0.05f*self.contentView.frame.size.width);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-0.05f*self.contentView.frame.size.width);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];

    [_circleBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.icon.mas_centerX);
        make.centerY.equalTo(self.icon.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(0.25f*self.contentView.frame.size.width);
        make.right.equalTo(self.contentView.mas_right).with.offset(-0.25f*self.contentView.frame.size.width);
        make.height.equalTo(@(0.5f*self.contentView.frame.size.width));
    }];

    _circleBackgroundView.layer.cornerRadius = 0.25f * self.contentView.frame.size.width;

    [super updateConstraints];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];

    [UIView animateWithDuration:0.25 animations:^{
        self.circleBackgroundView.backgroundColor = (highlighted ? [UIColor darkJSTColor]  : [UIColor lightJSTColor]);
        self.icon.textColor = (highlighted ? [UIColor lightJSTColor] : [UIColor defaultJSTColor]);
    }];
}

@end

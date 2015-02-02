//
// Created by Blazej Marcinkiewicz on 20/01/15.
// ***REMOVED***
//

#import "JSTCadenceView.h"
#import "UIColor+JSTExtensions.h"
#import "JSTDetailsHeaderView.h"
#import "JSTDetailsFooterView.h"


@interface JSTCadenceView ()
@property(nonatomic, readwrite) UILabel *resultLabel;
@property(nonatomic, strong) JSTDetailsHeaderView *headerView;
@property(nonatomic, strong) JSTDetailsFooterView *footerView;
@end

@implementation JSTCadenceView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor defaultJSTColor];

        self.headerView = [[JSTDetailsHeaderView alloc] initWithFrame:CGRectZero];
        self.headerView.iconView.text = @"W";
        self.headerView.titleLabel.text = @"Cadence\nSensor";
        self.headerView.descriptionLabel.text = @"Start pedalling and try to keep the target cadence.";
        self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.headerView];

        [self.headerView setNeedsUpdateConstraints];

        self.footerView = [[JSTDetailsFooterView alloc] initWithFrame:CGRectZero];
        self.footerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.footerView];


        self.resultLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.resultLabel.font = [UIFont systemFontOfSize:30];
        self.resultLabel.textColor = [UIColor lightJSTColor];
        self.resultLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.resultLabel];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.headerView sizeToFit];
    self.headerView.frame = CGRectMake(0, 0, self.bounds.size.width, self.headerView.frame.size.height);

    [self.footerView sizeToFit];
    self.footerView.center = CGPointMake(self.bounds.size.width * 0.5f, self.bounds.size.height - self.footerView.frame.size.height * 0.5f);

    [self.resultLabel sizeToFit];
    self.resultLabel.center = CGPointMake(self.bounds.size.width * 0.5f, self.bounds.size.height * 0.5f);
}

@end

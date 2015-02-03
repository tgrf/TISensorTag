//
// Created by Blazej Marcinkiewicz on 01/02/15.
// ***REMOVED***
//

#import "JSTClickerView.h"
#import "UIColor+JSTExtensions.h"
#import "JSTDetailsHeaderView.h"
#import "JSTDetailsFooterView.h"


@interface JSTClickerView ()
@property(nonatomic, strong) UISlider *firstPlayerProgress;
@property(nonatomic, readwrite) UISlider *secondPlayerProgress;
@property(nonatomic, strong) UIButton *resetButton;
@property(nonatomic, strong) JSTDetailsHeaderView *headerView;
@property(nonatomic, strong) JSTDetailsFooterView *footerView;
@end

@implementation JSTClickerView {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor defaultJSTColor];
        
        self.headerView = [[JSTDetailsHeaderView alloc] initWithFrame:CGRectZero];
        self.headerView.iconView.text = @"G";
        self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
        self.headerView.titleLabel.text = @"Fast\nclicker";
        self.headerView.descriptionLabel.text = @"Click left and right buttons alternately as fast as you can.";
        [self addSubview:self.headerView];

        self.firstPlayerProgress = [[UISlider alloc] init];
        self.firstPlayerProgress.userInteractionEnabled = NO;
        self.firstPlayerProgress.minimumValue = 0;
        self.firstPlayerProgress.maximumValue = 100;
        self.firstPlayerProgress.tintColor = [UIColor darkJSTColor];
        [self addSubview:self.firstPlayerProgress];
        
        self.secondPlayerProgress = [[UISlider alloc] init];
        self.secondPlayerProgress.userInteractionEnabled = NO;
        self.secondPlayerProgress.minimumValue = 0;
        self.secondPlayerProgress.maximumValue = 100;
        self.secondPlayerProgress.tintColor = [UIColor lightJSTColor];
        [self addSubview:self.secondPlayerProgress];

        self.resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.resetButton setTitle:@"Reset" forState:UIControlStateNormal];
        [self.resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:self.resetButton];

        self.footerView = [[JSTDetailsFooterView alloc] initWithFrame:CGRectZero];
        self.footerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.footerView];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.firstPlayerProgress sizeToFit];
    [self.secondPlayerProgress sizeToFit];
    [self.resetButton sizeToFit];
    [self.headerView sizeToFit];
    [self.footerView sizeToFit];

    CGFloat spacing = 20;
    CGFloat margin = 20;

    [self.headerView sizeToFit];
    self.headerView.frame = CGRectMake(0, 0, self.bounds.size.width, self.headerView.frame.size.height);

    [self.footerView sizeToFit];
    self.footerView.center = CGPointMake(self.bounds.size.width * 0.5f, self.bounds.size.height - self.footerView.frame.size.height * 0.5f);

    self.secondPlayerProgress.frame = CGRectMake(margin, (self.bounds.size.height - self.secondPlayerProgress.frame.size.height) * 0.5f,
            self.bounds.size.width - 2 * margin, self.secondPlayerProgress.frame.size.height);

    self.firstPlayerProgress.frame = CGRectMake(margin, CGRectGetMinY(self.secondPlayerProgress.frame) - spacing - self.firstPlayerProgress.frame.size.height,
            self.bounds.size.width - 2 * margin, self.firstPlayerProgress.frame.size.height);

    self.resetButton.center = CGPointMake(self.bounds.size.width * 0.5f, CGRectGetMaxY(self.secondPlayerProgress.frame) + spacing + self.resetButton.frame.size.height);
}


@end

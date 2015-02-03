//
// Created by Blazej Marcinkiewicz on 25/01/15.
// ***REMOVED***
//

#import "JSTSafeView.h"
#import "UIColor+JSTExtensions.h"
#import "JSTDetailsHeaderView.h"
#import "JSTDetailsFooterView.h"


@interface JSTSafeView ()
@property(nonatomic, strong) UILabel *resultLabel;
@property(nonatomic, strong) JSTDetailsHeaderView *headerView;
@property(nonatomic, strong) JSTDetailsFooterView *footerView;
@property(nonatomic, strong) UIButton *startButton;
@property(nonatomic, strong) NSMutableArray *dots;
@end

@implementation JSTSafeView {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor defaultJSTColor];

        self.resultLabel = [[UILabel alloc] init];
        self.resultLabel.font = [UIFont fontWithName:@"fontawesome" size:100];
        self.resultLabel.text = @"\uf023";
        self.resultLabel.textAlignment = NSTextAlignmentCenter;
        self.resultLabel.textColor = [UIColor darkJSTColor];
        [self addSubview:self.resultLabel];
        
        self.headerView = [[JSTDetailsHeaderView alloc] initWithFrame:CGRectZero];
        self.headerView.iconView.text = @"S";
        self.headerView.titleLabel.text = @"Safe";
        self.headerView.descriptionLabel.text = @"Turn the knob to 0 and press start button. Then turn it left and right to open the safe.";
        self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.headerView];

        [self.headerView setNeedsUpdateConstraints];
        
        self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.startButton setTitleColor:[UIColor lightJSTColor] forState:UIControlStateNormal];
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        self.startButton.titleLabel.font = [UIFont systemFontOfSize:40];
        [self addSubview:self.startButton];

        self.footerView = [[JSTDetailsFooterView alloc] initWithFrame:CGRectZero];
        self.footerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.footerView];
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

    [self.startButton sizeToFit];
    self.startButton.center = CGPointMake(self.bounds.size.width * 0.5f, CGRectGetMaxY(self.resultLabel.frame) + 40);

    int dotSize = 10;
    float spacing = (self.bounds.size.width) / (self.dots.count + 1);
    float currentX = spacing;
    for (UIView *view in self.dots) {
        view.frame = CGRectMake(currentX - dotSize * 0.5f, CGRectGetMaxY(self.startButton.frame), dotSize, dotSize);
        view.layer.cornerRadius = dotSize * 0.5f;
        currentX += spacing;
    }
}

- (void)setNumberOfValues:(int)valuesCount {
    NSMutableArray *dots = [NSMutableArray array];
    for (int i = 0; i < valuesCount; ++i) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor darkJSTColor];
        [self addSubview:view];
        [dots addObject:view];
    }
    
    self.dots = dots;
}

- (void)setNumberOfCorrectValues:(int)correctValuesCount {
    [UIView animateWithDuration:0.3f animations:^{
        int index = 0;
        for (UIView *dot in self.dots) {
            if (index < correctValuesCount) {
                dot.alpha = 0.f;
            } else {
                dot.alpha = 1.f;
            }
            ++index;
        }
    }];
}

@end

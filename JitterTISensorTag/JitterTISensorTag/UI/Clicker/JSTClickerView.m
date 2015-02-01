//
// Created by Blazej Marcinkiewicz on 01/02/15.
// ***REMOVED***
//

#import "JSTClickerView.h"


@interface JSTClickerView ()
@property(nonatomic, strong) UISlider *firstPlayerProgress;
@property(nonatomic, readwrite) UISlider *secondPlayerProgress;
@property(nonatomic, strong) UIButton *resetButton;
@end

@implementation JSTClickerView {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        self.firstPlayerProgress = [[UISlider alloc] init];
        self.firstPlayerProgress.userInteractionEnabled = NO;
        self.firstPlayerProgress.minimumValue = 0;
        self.firstPlayerProgress.maximumValue = 100;
        self.firstPlayerProgress.tintColor = [UIColor redColor];
        [self addSubview:self.firstPlayerProgress];
        
        self.secondPlayerProgress = [[UISlider alloc] init];
        self.secondPlayerProgress.userInteractionEnabled = NO;
        self.secondPlayerProgress.minimumValue = 0;
        self.secondPlayerProgress.maximumValue = 100;
        [self addSubview:self.secondPlayerProgress];
        
        self.resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.resetButton setTitle:@"Reset" forState:UIControlStateNormal];
        [self.resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:self.resetButton];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];


    [self.firstPlayerProgress sizeToFit];
    [self.secondPlayerProgress sizeToFit];
    [self.resetButton sizeToFit];

    CGFloat spacing = 20;
    CGFloat margin = 20;

    self.secondPlayerProgress.frame = CGRectMake(margin, (self.bounds.size.height - self.secondPlayerProgress.frame.size.height) * 0.5f,
            self.bounds.size.width - 2 * margin, self.secondPlayerProgress.frame.size.height);

    self.firstPlayerProgress.frame = CGRectMake(margin, CGRectGetMinY(self.secondPlayerProgress.frame) - spacing - self.firstPlayerProgress.frame.size.height,
            self.bounds.size.width - 2 * margin, self.firstPlayerProgress.frame.size.height);

    self.resetButton.center = CGPointMake(self.bounds.size.width * 0.5f, CGRectGetMaxY(self.secondPlayerProgress.frame) + spacing + self.resetButton.frame.size.height);
}


@end

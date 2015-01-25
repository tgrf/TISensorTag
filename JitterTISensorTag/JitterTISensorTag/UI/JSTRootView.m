//
// Created by Blazej Marcinkiewicz on 20/01/15.
// ***REMOVED***
//

#import "JSTRootView.h"


@interface JSTRootView ()
@property(nonatomic, readwrite) UIButton *cadenceButton;
@end

@implementation JSTRootView {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        self.cadenceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cadenceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.cadenceButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.cadenceButton setTitle:@"Cadence" forState:UIControlStateNormal];
        [self addSubview:self.cadenceButton];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.cadenceButton sizeToFit];
    self.cadenceButton.center = CGPointMake(self.bounds.size.width * 0.5f, self.bounds.size.height * 0.5f);
}


@end

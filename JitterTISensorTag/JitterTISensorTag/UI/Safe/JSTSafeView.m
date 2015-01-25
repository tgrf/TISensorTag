//
// Created by Blazej Marcinkiewicz on 25/01/15.
// ***REMOVED***
//

#import "JSTSafeView.h"


@interface JSTSafeView ()
@property(nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, readwrite) UILabel *rotationLabel;
@end

@implementation JSTSafeView {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        self.resultLabel = [[UILabel alloc] init];
        self.resultLabel.font = [UIFont systemFontOfSize:30];
        self.resultLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.resultLabel];

        self.rotationLabel = [[UILabel alloc] init];
        self.rotationLabel.font = [UIFont systemFontOfSize:30];
        self.rotationLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.rotationLabel];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.resultLabel sizeToFit];
    self.resultLabel.center = CGPointMake(self.bounds.size.width * 0.5f, self.bounds.size.height * 0.5f);

    [self.rotationLabel sizeToFit];
    self.rotationLabel.center = CGPointMake(self.bounds.size.width * 0.5f, CGRectGetMinY(self.resultLabel.frame) - self.resultLabel.frame.size.height);
}
@end

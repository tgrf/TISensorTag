//
// Created by Blazej Marcinkiewicz on 25/01/15.
// ***REMOVED***
//

#import "JSTMorseView.h"


@interface JSTMorseView ()
@property(nonatomic, strong) UILabel *resultLabel;
@end

@implementation JSTMorseView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        self.resultLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.resultLabel.font = [UIFont systemFontOfSize:30];
        self.resultLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.resultLabel];


    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.resultLabel sizeToFit];
    self.resultLabel.center = CGPointMake(self.bounds.size.width * 0.5f, self.bounds.size.height * 0.5f);
}
@end

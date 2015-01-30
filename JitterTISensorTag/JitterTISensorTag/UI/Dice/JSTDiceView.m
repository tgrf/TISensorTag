//
// Created by Blazej Marcinkiewicz on 30/01/15.
// ***REMOVED***
//

#import "JSTDiceView.h"


@interface JSTDiceView ()
@property(nonatomic, readwrite) UILabel *resultLabel;
@end

@implementation JSTDiceView {

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

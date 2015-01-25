//
// Created by Blazej Marcinkiewicz on 20/01/15.
// ***REMOVED***
//

#import "JSTCadenceView.h"


@interface JSTCadenceView ()
@property(nonatomic, readwrite) UILabel *resultLabel;
@end

@implementation JSTCadenceView {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        self.resultLabel = [[UILabel alloc] init];
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

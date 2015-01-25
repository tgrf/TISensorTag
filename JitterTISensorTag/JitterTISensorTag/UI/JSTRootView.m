//
// Created by Blazej Marcinkiewicz on 20/01/15.
// ***REMOVED***
//

#import "JSTRootView.h"
#import "View+MASAdditions.h"

@implementation JSTRootView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _gamesTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_gamesTableView];

        [self updateConstraints];
    }

    return self;
}

- (void)updateConstraints {
    [_gamesTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

@end

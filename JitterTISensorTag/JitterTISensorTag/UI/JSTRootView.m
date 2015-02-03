//
// Created by Blazej Marcinkiewicz on 20/01/15.
// Copyright (c) 2015 mceconf.com. All rights reserved.
//

#import "JSTRootView.h"
#import "View+MASAdditions.h"
#import "UIColor+JSTExtensions.h"

@implementation JSTRootView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor defaultJSTColor];
    }

    return self;
}

@end

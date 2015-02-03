//
// Created by Blazej Marcinkiewicz on 02/02/15.
// Copyright (c) 2015 mceconf.com. All rights reserved.
//

#import "JSTDeviceListView.h"
#import "UIColor+JSTExtensions.h"


@interface JSTDeviceListView ()
@property(nonatomic, readwrite) UITableView *tableView;
@end

@implementation JSTDeviceListView {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor defaultJSTColor];

        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor defaultJSTColor];
        self.tableView.separatorColor = [UIColor darkJSTColor];
        [self addSubview:self.tableView];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.tableView.frame = self.bounds;
}


@end

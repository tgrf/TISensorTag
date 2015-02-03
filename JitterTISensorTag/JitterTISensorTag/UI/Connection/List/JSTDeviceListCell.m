//
// Created by Blazej Marcinkiewicz on 02/02/15.
// Copyright (c) 2015 mceconf.com. All rights reserved.
//

#import "JSTDeviceListCell.h"
#import "UIColor+JSTExtensions.h"


@implementation JSTDeviceListCell {

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor defaultJSTColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tintColor = [UIColor darkJSTColor];
    }

    return self;
}

@end

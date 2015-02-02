//
// Created by Blazej Marcinkiewicz on 02/02/15.
// ***REMOVED***
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
    }

    return self;
}

@end

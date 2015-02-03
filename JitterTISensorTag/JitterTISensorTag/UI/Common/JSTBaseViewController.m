//
// Created by Blazej Marcinkiewicz on 02/02/15.
// ***REMOVED***
//

#import "JSTBaseViewController.h"
#import "JSTSensorTag.h"


@implementation JSTBaseViewController {

}
- (void)setSensors:(NSArray *)sensors {
    self.sensorTag = [sensors firstObject];
}

@end

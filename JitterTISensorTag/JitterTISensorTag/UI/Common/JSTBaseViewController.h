//
// Created by Blazej Marcinkiewicz on 02/02/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>

@class JSTSensorTag;


@interface JSTBaseViewController : UIViewController
@property (nonatomic, strong) JSTSensorTag *sensorTag;
- (void)setSensors:(NSArray *)sensors;
@end

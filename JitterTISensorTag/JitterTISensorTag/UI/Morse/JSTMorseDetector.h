//
// Created by Blazej Marcinkiewicz on 25/01/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>


@interface JSTMorseDetector : NSObject

- (void)updateWithKeyPress:(BOOL)isPressed;

- (NSString *)text;
@end

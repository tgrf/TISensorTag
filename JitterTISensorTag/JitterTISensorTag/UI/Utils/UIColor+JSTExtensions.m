//
//  UIColor+JSTExtensions.m
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 01/02/15.
//  Copyright (c) 2015 Polidea Sp. z o.o. All rights reserved.
//
#import "UIColor+JSTExtensions.h"

@implementation UIColor (JSTExtensions)

+ (UIColor *)lightJSTColor {
    return [UIColor whiteColor];
}

+ (UIColor *)defaultJSTColor {
    return [UIColor colorWithRed:1.0f green:0.266f blue:0.266f alpha:1.0f];
}

+ (UIColor *)darkJSTColor {
    return [UIColor colorWithRed:0.625f green:0.0f blue:0.0f alpha:1.0f];
}

@end

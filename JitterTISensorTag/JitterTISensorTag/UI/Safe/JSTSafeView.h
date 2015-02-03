//
// Created by Blazej Marcinkiewicz on 25/01/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>

@class JSTDetailsHeaderView;
@class JSTDetailsFooterView;


@interface JSTSafeView : UIView
@property(nonatomic, readonly) UILabel *resultLabel;
@property(nonatomic, readonly) UIButton *startButton;

- (void)setNumberOfValues:(int)valuesCount;
- (void)setNumberOfCorrectValues:(int)correctValuesCount;
@end

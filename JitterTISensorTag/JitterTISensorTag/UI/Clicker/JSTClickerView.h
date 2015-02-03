//
// Created by Blazej Marcinkiewicz on 01/02/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>

@class JSTDetailsHeaderView;
@class JSTDetailsFooterView;


@interface JSTClickerView : UIView

@property(nonatomic, readonly) UISlider *firstPlayerProgress;

@property(nonatomic, readonly) UISlider *secondPlayerProgress;

@property(nonatomic, readonly) UIButton *resetButton;

@end

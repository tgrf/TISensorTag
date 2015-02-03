//
//  JSTHandshakeView.h
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 25/01/15.
//  ***REMOVED***
//
#import <Foundation/Foundation.h>

@class JSTDetailsFooterView;
@class JSTDetailsResultView;
@class JSTDetailsHeaderView;

@interface JSTHandshakeView : UIView
@property (nonatomic, strong, readonly) JSTDetailsHeaderView *headerView;
@property (nonatomic, strong, readonly) JSTDetailsResultView *resultView;
@property (nonatomic, strong, readonly) JSTDetailsFooterView *footerView;
@end

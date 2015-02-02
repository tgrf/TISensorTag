//
//  JSTWandView.h
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 23/01/15.
//  ***REMOVED***
//
#import <Foundation/Foundation.h>

@class JSTDetailsHeaderView;
@class JSTDetailsFooterView;

@interface JSTWandView : UIView
@property (nonatomic, strong, readonly) UILabel *valuesLabel;
@property (nonatomic, strong, readonly) JSTDetailsHeaderView *headerView;
@property (nonatomic, strong, readonly) JSTDetailsFooterView *footerView;
@end

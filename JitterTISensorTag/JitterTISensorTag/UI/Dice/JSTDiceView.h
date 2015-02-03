//
// Created by Blazej Marcinkiewicz on 30/01/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>

@class JSTDetailsFooterView;
@class JSTDetailsResultView;
@class JSTDetailsHeaderView;


@interface JSTDiceView : UIView
@property (nonatomic, strong, readonly) JSTDetailsHeaderView *headerView;
@property (nonatomic, strong, readonly) JSTDetailsResultView *resultView;
@property (nonatomic, strong, readonly) JSTDetailsFooterView *footerView;
@end

//
// Created by Blazej Marcinkiewicz on 20/01/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>

@class JSTDetailsHeaderView;
@class JSTDetailsFooterView;
@class JSTDetailsResultView;


@interface JSTCadenceView : UIView
@property (nonatomic, strong, readonly) JSTDetailsHeaderView *headerView;
@property (nonatomic, strong, readonly) JSTDetailsResultView *resultView;
@property (nonatomic, strong, readonly) JSTDetailsFooterView *footerView;
@end

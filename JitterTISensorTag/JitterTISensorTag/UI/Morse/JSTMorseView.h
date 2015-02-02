//
// Created by Blazej Marcinkiewicz on 25/01/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>


@interface JSTMorseView : UIView
@property(nonatomic, readonly) UILabel *currentSignLabel;
@property(nonatomic, readonly) UILabel *textLabel;

- (void)setSymbolMapping:(NSDictionary *)mapping;

- (void)setActiveSymbol:(NSString *)symbol;
@end

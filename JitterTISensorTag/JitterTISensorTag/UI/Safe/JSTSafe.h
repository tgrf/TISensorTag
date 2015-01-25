//
// Created by Blazej Marcinkiewicz on 25/01/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>


@interface JSTSafe : NSObject

@property (nonatomic) int range;

@property(nonatomic, readonly) NSArray *values;

- (instancetype)initWithCombinationValue:(NSArray *)safeCombination;

- (void)updateWithRead:(float)value;

- (int)currentSafeValue;

- (BOOL)isCombinationCorrect;
@end

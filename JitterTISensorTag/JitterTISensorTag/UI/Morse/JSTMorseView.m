//
// Created by Blazej Marcinkiewicz on 25/01/15.
// ***REMOVED***
//

#import <sys/ucred.h>
#import "JSTMorseView.h"
#import "UIColor+JSTExtensions.h"


@interface JSTMorseView ()
@property(nonatomic, strong) UILabel *iconView;
@property(nonatomic, strong) UILabel *currentSignLabel;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) UILabel *descriptionLabel;
@property(nonatomic, strong) NSDictionary *symbols;
@property(nonatomic, strong) NSMutableArray *symbolLabels;
@property(nonatomic, strong) NSMutableDictionary *labelMapping;
@end

@implementation JSTMorseView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor defaultJSTColor];

        self.iconView = [[UILabel alloc] init];
        self.iconView.font = [UIFont fontWithName:@"mce_st_icons" size:100];
        self.iconView.textColor = [UIColor lightJSTColor];
        self.iconView.textAlignment = NSTextAlignmentCenter;
        self.iconView.text = @"M";
        [self addSubview:self.iconView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor lightJSTColor];
        self.titleLabel.font = [UIFont systemFontOfSize:32];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.text = @"Morse\nTweet";
        [self addSubview:self.titleLabel];
        
        self.descriptionLabel = [[UILabel alloc] init];
        self.descriptionLabel.textColor = [UIColor darkJSTColor];
        self.descriptionLabel.font = [UIFont systemFontOfSize:14];
        self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.text = @"Press left button on Sensor Tag to signal, right to remove last sign, both to post the Tweet.";
        [self addSubview:self.descriptionLabel];

        self.currentSignLabel = [[UILabel alloc] init];
        self.currentSignLabel.textColor = [UIColor lightJSTColor];
        self.currentSignLabel.font = [UIFont systemFontOfSize:24];
        self.currentSignLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.currentSignLabel];

        self.textLabel = [[UILabel alloc] init];
        self.textLabel.textColor = [UIColor lightJSTColor];
        self.textLabel.font = [UIFont systemFontOfSize:24];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.numberOfLines = 0;
        [self addSubview:self.textLabel];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    float margin = 0.15f * self.bounds.size.width;
    float topMargin = 0.05f * self.bounds.size.height;

    float spacing = 10;

    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(margin, topMargin, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);

    [self.iconView sizeToFit];
    self.iconView.center = CGPointMake(self.bounds.size.width - margin - self.iconView.frame.size.width * 0.5f, self.titleLabel.center.y);

    self.descriptionLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.iconView.frame), self.bounds.size.width - 2 * margin, 0);
    [self.descriptionLabel sizeToFit];
    self.descriptionLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.iconView.frame), self.bounds.size.width - 2 * margin, self.descriptionLabel.frame.size.height);

    self.textLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.descriptionLabel.frame), self.bounds.size.width - 2 * margin, 0);
    [self.textLabel sizeToFit];
    self.textLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.descriptionLabel.frame) + spacing, self.bounds.size.width - 2 * margin, self.textLabel.frame.size.height);

    [self.currentSignLabel sizeToFit];
    self.currentSignLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.textLabel.frame) + spacing, self.bounds.size.width - 2 * margin, self.currentSignLabel.frame.size.height);

    float columnSpacing = 20;
    float numberOfColumns = 3;
    float columnWidth = (self.bounds.size.width - (numberOfColumns + 1) * columnSpacing) / numberOfColumns;

    float currentX = columnSpacing;
    float currentY = self.bounds.size.height - topMargin - 160;
    for (int i = 0; i < self.symbolLabels.count; ++i) {
        UILabel *label = self.symbolLabels[(NSUInteger) i];
        [label sizeToFit];
        label.frame = CGRectMake(currentX, currentY, columnWidth, label.frame.size.height);
        label.font = [UIFont fontWithName:@"CourierNewPSMT" size:14];
        currentX += columnWidth + columnSpacing;
        if (i % (int)numberOfColumns == (numberOfColumns - 1)) {
            currentX = columnSpacing;
            currentY += label.frame.size.height;
        }
    }
}

- (void)setSymbolMapping:(NSDictionary *)mapping {
    self.symbols = mapping;

    [self.symbolLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];

    self.labelMapping = [NSMutableDictionary dictionary];

    self.symbolLabels = [NSMutableArray array];

    for (NSString *value in [[mapping allValues] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:nil ascending:YES]]]) {
        NSString *key = [[mapping allKeysForObject:value] firstObject];
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor lightJSTColor];
        self.labelMapping[key] = label;
        label.text = [NSString stringWithFormat:@"%@ - %@", value, key];
        [self addSubview:label];
        [self.symbolLabels addObject:label];
    }
    [self setNeedsLayout];
}

- (void)setActiveSymbol:(NSString *)symbol {
    for (NSString *key in [self.labelMapping allKeys]) {
        UILabel *label = self.labelMapping[key];
        if (![key hasPrefix:symbol] && symbol.length > 0) {
            [UIView animateWithDuration:0.1 delay:0 options:0 animations:^{
                label.alpha = 0.f;
            } completion:nil];
        } else {
            [UIView animateWithDuration:0.1 delay:0 options:0 animations:^{
                label.alpha = 1.f;
            } completion:nil];
        }
    }
}

@end

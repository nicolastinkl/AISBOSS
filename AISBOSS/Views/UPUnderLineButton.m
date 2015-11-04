//
//  UPUnderLineButton.m
//  UPPayPluginEx
//
//  Created by liwang on 13-5-23.
//
//

#import "UPUnderLineButton.h"
#import "UP_NSString+Size.h"


@interface UPUnderLineButton()
{
    UILabel     *_label;
    NSString    *_title;
    UIColor     *_normalColor;
    UIColor     *_highLightColor;
    UIFont      *_font;
}


@property (nonatomic, strong) UIFont *font;

- (void)addSubViews;

- (void)colorChange:(UIButton *)btn;

- (void)colorBack:(UIButton *)btn;

- (void)touchUpInside:(UIButton *)btn;


@end





@implementation UPUnderLineButton

- (UPUnderLineButton *)initWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font normalColor:(UIColor *)normalColor highlightColor:(UIColor *)highlightColor action:(void(^)(void))action
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _title = (title == nil) ? nil : [title copy];
        _font = [font copy];
        _normalColor = [normalColor copy];
        _highLightColor = [highlightColor copy];
        
        
        
        [self addSubViews];
        
    }
    return self;
}




- (UPUnderLineButton *)initWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _title = (title == nil) ? nil : [NSString stringWithString:title];
        _font = [font copy];
        
        [self addSubViews];
        
    }
    return self;
}


#pragma mark- Member Functions



- (void)addSubViews
{
    CGFloat x = 0;
    CGFloat y = 0;
    
    CGSize labelSize = [_title newSizeWithFont:_font forWidth:CGRectGetWidth(self.frame) lineBreakMode:NSLineBreakByCharWrapping];

    CGRect frame = CGRectMake(x, y, labelSize.width, labelSize.height);
    _label = [[UILabel alloc] initWithFrame:frame];
    [_label setFont:_font];
    [_label setText:_title];
    _label.backgroundColor = [UIColor clearColor];
    [_label setTextColor:_normalColor];
    [self addSubview:_label];

    
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = YES;
    btn.frame = CGRectMake(x, y, labelSize.width, labelSize.height);
    [btn addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(colorChange:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(colorBack:) forControlEvents:UIControlEventTouchDragOutside];
    [self addSubview:btn];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelSize.width, labelSize.height);
}

- (void)colorChange:(UIButton *)btn
{
    [_label setTextColor:_highLightColor];
}
- (void)colorBack:(UIButton *)btn
{
    [_label setTextColor:_normalColor];
}
- (void)touchUpInside:(UIButton *)btn
{
    [self colorBack:btn];
    if ([self.mTarget respondsToSelector:self.mSelector]) {
        [self.mTarget performSelector:self.mSelector withObject:nil];
    }
}


- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = [normalColor copy];
    [_label setTextColor:_normalColor];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

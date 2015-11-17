//
//  AISellerCell.m
//  AITrans
//
//  Created by 王坜 on 15/7/22.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AISellerCell.h"
#import "AISellingProgressBar.h"
#import "AIViews.h"
#import "UP_NSString+Size.h"
#import "AITools.h"
#import "AIScrollLabel.h"
#import "UIImageView+WebCache.h"
#import "AIOrderPreModel.h"
#import "AITools.h"
#define kMargin5    5

#define kMargin10    10

#define kRadius   8


#define kSellerIconHeight   55
#define kStampHeight        40

#define kSmallImageSize     15

#define kBigImageSize       20

#define kSmallFontSize      10

#define kBigFontSize        16

#define kWhiteValue         0.8

#define kBarHeight          44

#define kButtonWidth        40



@interface AISellerCell ()
{
    UIView *_boardView;
    UIView *_iconContainer;
    UIView *_shadowView;
    UIView *_colorBackgroundView;
    UIImageView *_sellerIcon;
    UIImageView *_borderCornerView;
    UIImageView *_shadowImageView;
    
    CAGradientLayer *_shadowLayer;
    
    UPLabel *_sellerName;
    
    UPLabel *_messageNum;
    
    UPLabel *_price;
    
    UPLabel *_timestamp;
    
    UPLabel *_location;
    
    UIButton *_actionButton;
    
    AISellingProgressBar *_progressBar;
    
    // goods
    UIImageView *_goodsIndicator;
    UPLabel *_goodsClass;
    UPLabel *_goodsName;
    
    // images
    UIView *_imagesView;
    
    //
    UIVisualEffectView *_blurView;
    
    UIView *_backgroundView;
    
    UIImageView *_lineView;
    
    UIImageView *_dotView;
    
    SellerCellColorType _curColorType;
    
    AIScrollLabel *_scrollLabel;
    
    CGRect _defaultLayerBounds;
    
    UIWebView *_telWebView;
}

@property (nonatomic, strong) NSMutableArray *sellerImages;

@end


@implementation AISellerCell
@synthesize sellerIcon = _sellerIcon;
@synthesize sellerName = _sellerName;
@synthesize messageNum = _messageNum;
@synthesize price = _price;
@synthesize timestamp = _timestamp;
@synthesize location = _location;
@synthesize actionButton = _actionButton;
@synthesize progressBar = _progressBar;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)expandHeight
{
    return (kStampHeight + kSellerIconHeight) * 2;
}


+ (CGFloat)unexpandHeight
{
    return (kStampHeight + kSellerIconHeight);
}


#pragma mark - Override
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        _defaultLayerBounds = CGRectZero;
        
        [self makeBackgroundView];
        [self makeSellerIcon];
        [self makeSellerName];
        [self makeMessageNum];
        [self makePrice];
        [self makeGoodsInfoView];
        [self makeLineAndDot];
        [self makeProgressBar];
        [self makeActionButton];
        [self makeTimestamp];
        [self makeLocation];
        [self addBottomShadowView];
        
        
        _telWebView =[[UIWebView alloc] init];
        [self.contentView addSubview:_telWebView];
        
    }
    
    return self;
}

- (void)stop
{
    [_scrollLabel stopScroll];
}

#pragma mark - 设置线条


- (void)resizeLineAndDot
{
    CGFloat width = CGRectGetWidth(_boardView.frame) - kMargin10 -kButtonWidth - 3;
    if (_progressBar.hidden) {
        [AITools resetWidth:width forView:_lineView];
        [AITools resetOriginalX:width forView:_dotView];
    }
    else
    {
        [AITools resetWidth:width-kMargin10 forView:_lineView];
        _dotView.hidden = YES;
    }
    
}

- (void)makeLineAndDot
{
    _lineView = [[UIImageView alloc] initWithImage:nil];
    _lineView.frame = CGRectMake(0, CGRectGetHeight(_iconContainer.frame), CGRectGetWidth(_boardView.frame), 1);
    [_boardView addSubview:_lineView];
    [_lineView setImage:[UIImage imageNamed:@"Seller_Line_Nor"]];
    //
    _dotView = [[UIImageView alloc] initWithImage:nil];
    _dotView.frame = CGRectMake(CGRectGetWidth(_lineView.frame), CGRectGetHeight(_iconContainer.frame)-1, 3, 3);
    [_boardView addSubview:_dotView];
    
    [_dotView setImage:[UIImage imageNamed:@"Seller_Dot_Nor"]];
    
}

#pragma mark - 设置背景色

- (void)resizeBackgroundView
{
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    [AITools resetWidth:width forView:_backgroundView];
}

- (void)setBackgroundColorType:(SellerCellColorType)colorType
{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithImage:nil];
        _backgroundView.frame = _boardView.bounds;
        _backgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        [_boardView insertSubview:_backgroundView atIndex:0];
    }
    
    _curColorType = colorType;
    [self setLineWithColorType:colorType];
    
    switch (colorType) {
        case SellerCellColorTypeNormal:
        {
            _backgroundView.backgroundColor = [UIColor whiteColor];
            _backgroundView.alpha = 0.3;
        }
            break;
        case SellerCellColorTypeGreen:
        {
            _backgroundView.backgroundColor = [AITools colorWithR:0x58 g:0xc3 b:0x02];
            _backgroundView.alpha = 0.5;
        }
            break;
        case SellerCellColorTypeBrown:
        {
            _backgroundView.backgroundColor = [AITools colorWithR:0xff g:0x78 b:0x00];
            _backgroundView.alpha = 0.5;
        }
            break;
            
        default:
            break;
    }
}


- (void)setLineWithColorType:(SellerCellColorType)colorType
{
    if (_progressBar.hidden) {
        [_lineView setHidden:NO];
        [_dotView setHidden:NO];
    }
    else
    {
        [_dotView setHidden:YES];
    }
    
    switch (colorType) {
        case SellerCellColorTypeNormal:
        {
            [_lineView setImage:[UIImage imageNamed:@"Seller_Line_Nor"]];
            [_dotView setImage:[UIImage imageNamed:@"Seller_Dot_Nor"]];
        }
            break;
        case SellerCellColorTypeGreen:
        {
            [_lineView setImage:[UIImage imageNamed:@"Seller_Line_Green"]];
            [_dotView setImage:[UIImage imageNamed:@"Seller_Dot_Green"]];
        }
            break;
        case SellerCellColorTypeBrown:
        {
            [_lineView setImage:[UIImage imageNamed:@"Seller_Line_Brown"]];
            [_dotView setImage:[UIImage imageNamed:@"Seller_Dot_Brown"]];
        }
            break;
            
        default:
            break;
    }
}

- (void)setProgressBarModel:(AIProgressModel *)model
{
    [_progressBar setHidden:model == nil];
    if (model.percentage <= 0){
        [_progressBar setHidden:YES];
        return;
    }
    
    if (!model) {
        return;
    }
    
    [_progressBar setProgressModel:model];
    [self setLineWithColorType:_curColorType];
    
}

#pragma mark - 设置图片

- (void)resizeImages
{
    CGSize size = [_sellerName.text newSizeWithFont:[UIFont boldSystemFontOfSize:16] forWidth:CGRectGetWidth(_boardView.frame) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat xoffset = CGRectGetMinX(_sellerName.frame) + size.width + kMargin10;
    for (UIView *view in self.sellerImages) {
        [AITools resetOriginalX:(CGRectGetMinX(view.frame)+xoffset) forView:view];
    }
}

- (void)setImages:(NSArray *)images
{
    if (images && images.count > 0) {
        self.sellerImages = [NSMutableArray array];
        
        CGFloat width = 20;
        CGFloat x = 0;
        CGFloat y = (kSellerIconHeight/2 - width)/2 + 3;
        
        for (NSString *imageName in images) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            imageView.frame = CGRectMake(x, y, width, width);
            [_boardView addSubview:imageView];
            
            x += width + kMargin10;
            [self.sellerImages addObject:imageView];
        }
    }
    else
    {
        for (UIView *view in _sellerImages) {
            [view removeFromSuperview];
        }
    }
}

- (void)setMessageNumber:(NSString *)number
{
    if (number && number.length > 0) {
        _messageNum.text = number;
        [_messageNum setHidden:NO];
    }
    else
    {
        [_messageNum setHidden:YES];
    }
}


#pragma mark - 设置按钮类型

- (void)buttonAction:(UIButton *)button
{
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.userPhone?:@"空号"]];
    [_telWebView loadRequest:[NSURLRequest requestWithURL:telURL]];

}

- (void)addTargetForButtonType:(SellerButtonType)buttonType
{
    _actionButton.tag = buttonType;
    [_actionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setButtonType:(SellerButtonType)buttonType
{
    switch (buttonType) {

        case SellerButtonTypePhone:
        {
            [_actionButton setImage:[UIImage imageNamed:@"Btn_Nor_Phone"] forState:UIControlStateNormal];
            [_actionButton setImage:[UIImage imageNamed:@"Btn_Hig_Phone"] forState:UIControlStateHighlighted];
            [self addTargetForButtonType:SellerButtonTypePhone];
        }
            break;
        case SellerButtonTypeOpposite:
        {
            [_actionButton setImage:[UIImage imageNamed:@"Btn_Nor_Opposite"] forState:UIControlStateNormal];
            [_actionButton setImage:[UIImage imageNamed:@"Btn_Hig_Opposite"] forState:UIControlStateHighlighted];
            [self addTargetForButtonType:SellerButtonTypeOpposite];
        }
            break;
            
        case SellerButtonTypeRecord:
        {
            [_actionButton setImage:[UIImage imageNamed:@"Btn_Nor_Locate"] forState:UIControlStateNormal];
            [_actionButton setImage:[UIImage imageNamed:@"Btn_Hig_Locate"] forState:UIControlStateHighlighted];
            [self addTargetForButtonType:SellerButtonTypeLocate];
        }
            break;
        
        case SellerButtonTypeCapture:
        {
            [_actionButton setImage:[UIImage imageNamed:@"Btn_Nor_Capture"] forState:UIControlStateNormal];
            [_actionButton setImage:[UIImage imageNamed:@"Btn_Hig_Capture"] forState:UIControlStateHighlighted];
            [self addTargetForButtonType:SellerButtonTypeCapture];
        }
            break;
        case SellerButtonTypeLocate:
        case SellerButtonTypeNone:
        {
            [_actionButton setImage:[UIImage imageNamed:@"Btn_Nor_Phone"] forState:UIControlStateNormal];
            [_actionButton setImage:[UIImage imageNamed:@"Btn_Hig_Phone"] forState:UIControlStateHighlighted];
            [self addTargetForButtonType:SellerButtonTypePhone];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 设置布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self resizeSubViews];
}

- (void)resizeSubViews
{
    [self resizeBorderView];
    [self resizeBackgroundView];
    [self resizePrice];
    [self resizeProgressBar];
    [self resizeShadow];
    [self resizeButton];
    [self resizeLineAndDot];
    [self resizeImages];
    [self resizeGoodsInfo];
}


- (void)makeAnimations
{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.duration = 1.0;
    animation.fromValue = @[@(self.bounds.origin.x),@(self.bounds.origin.y-100),@(self.bounds.size.width),@(self.bounds.size.height)];
    animation.toValue = @[@(self.bounds.origin.x),@(self.bounds.origin.y),@(self.bounds.size.width),@(self.bounds.size.height)];
    animation.repeatCount = 1;
    animation.autoreverses = NO;
    [self.layer addAnimation:animation forKey:@"bounds"];
}


- (void)resizeButton
{
    CGFloat x = CGRectGetWidth(self.frame) - kButtonWidth;
    [AITools resetOriginalX:x forView:_actionButton];
}

- (void)resizeProgressBar
{
    CGFloat x = CGRectGetWidth(self.frame) - kButtonWidth - kMargin10 - CGRectGetWidth(_progressBar.frame);
    [AITools resetOriginalX:x forView:_progressBar];
}

- (void)resizeBorderView
{
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    
    [AITools resetWidth:width forView:_boardView];
    [AITools resetWidth:width forView:_borderCornerView];
    [AITools resetWidth:width forView:_colorBackgroundView];
    [AITools resetWidth:width forView:_blurView];

    [_boardView bringSubviewToFront:_borderCornerView];
}

- (void)resizePrice
{
    CGFloat width = CGRectGetWidth(self.contentView.frame) - kMargin10;
    [AITools resetWidth:width forView:_price];
}

- (void)resizeShadow
{
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    [AITools resetWidth:width forView:_shadowView];
    
    CGRect frame = _shadowImageView.frame;
    frame.size.width = width;
    _shadowImageView.frame = frame;
    
}

#pragma mark - Method


- (void)addBottomShadowView
{
    CGFloat height = [AISellerCell unexpandHeight];

    UIImage *image = [UIImage imageNamed:@"seller_shadow"];
    _shadowImageView = [[UIImageView alloc] initWithImage:image];
    _shadowImageView.frame = CGRectMake(0, height-image.size.height, CGRectGetWidth(self.frame), image.size.height);
    
    [self.contentView addSubview:_shadowImageView];
}





- (void)makeBackgroundView
{
    CGFloat borderHeight = (kStampHeight + kSellerIconHeight + 20);
    _boardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), borderHeight)];
    _boardView.backgroundColor = [UIColor clearColor];
    _boardView.clipsToBounds = YES;
    
    [self.contentView addSubview:_boardView];
    
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    _blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    _blurView.frame = _boardView.bounds;
//    [self.contentView insertSubview:_blurView atIndex:0];
    
    
    UIView *view = [[UIView alloc] init];
    self.backgroundView = view;
    self.backgroundColor = [UIColor clearColor];
    
    // add round border
    UIImage *image = [UIImage imageNamed:@"SellerBorder"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2, image.size.width/2) resizingMode:UIImageResizingModeStretch];
    _borderCornerView = [[UIImageView alloc] initWithImage:image];
    _borderCornerView.frame = _boardView.bounds;
    [_boardView addSubview:_borderCornerView];
    
}

#pragma mark - 头像
- (void)makeSellerIcon
{
    CGFloat width = 50;////sqrt(2*50*50);
    _iconContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width*3/4, 50)];
    _iconContainer.clipsToBounds = YES;
    [_boardView addSubview:_iconContainer];
    
    
    _sellerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    _sellerIcon.image = [UIImage imageNamed:@"testHolder1"];
//    _sellerIcon.layer.cornerRadius = width/2;
    _sellerIcon.center = CGPointMake(width/2, 25);
    _sellerIcon.layer.masksToBounds = YES;
    _sellerIcon.contentMode = UIViewContentModeScaleAspectFill;
    [_boardView addSubview:_sellerIcon];
}

#pragma mark - 姓名
- (void)makeSellerName
{
    _sellerName = [AIViews normalLabelWithFrame:CGRectMake(CGRectGetMaxX(_iconContainer.frame)+kMargin10 * 2, 3, 200, CGRectGetHeight(_iconContainer.frame)/2) text:@"Amy Copper" fontSize:16 color:[UIColor whiteColor]];
    _sellerName.font = [AITools myriadSemiboldSemiCnWithSize:50/2.5];
    [_boardView addSubview:_sellerName];
    
}

#pragma mark - 未读消息
- (void)makeMessageNum
{
    _messageNum = [AIViews normalLabelWithFrame:CGRectMake(0, 0, 16, 16) text:nil fontSize:10 color:[UIColor whiteColor]];
    _messageNum.center = CGPointMake(CGRectGetMaxX(_iconContainer.frame), CGRectGetHeight(_iconContainer.frame)/2);
    _messageNum.textAlignment = NSTextAlignmentCenter;
    _messageNum.layer.cornerRadius = 8;
    _messageNum.clipsToBounds = YES;
    _messageNum.backgroundColor = [UIColor redColor];
    [_boardView addSubview:_messageNum];
#warning hidden unread message number.
    [_messageNum setHidden:YES];
}

#pragma mark - 价格
- (void)makePrice
{
    _price = [AIViews normalLabelWithFrame:CGRectMake(0, kMargin5, CGRectGetWidth(self.frame) - kMargin10, CGRectGetHeight(_iconContainer.frame)/2) text:@"$188" fontSize:22 color:[UIColor whiteColor]];
    _price.font = [AITools myriadBlackWithSize:66/2.5];
    _price.textAlignment = NSTextAlignmentRight;
    [_boardView addSubview:_price];
}


#pragma mark - 商品信息

- (void)resizeGoodsInfo
{
    CGSize classSize = [_goodsClass.text sizeWithFontSize:kSmallFontSize forWidth:CGRectGetWidth(_boardView.frame)];
    
    [AITools resetOriginalX:(CGRectGetMinX(_goodsClass.frame) + classSize.width) forView:_goodsName];
}


- (void)setServiceCategory:(AIOrderPreModel *)model
{
    if (model.service_category.category_icon) {
        [_goodsIndicator sd_setImageWithURL:[NSURL URLWithString:model.service_category.category_icon] placeholderImage:[UIImage imageNamed:@"Placehold"]];
    }
    else
    {
        _goodsIndicator.image = nil;
    }
    
    
    NSString *name = model.service_category.category_name ?: @"";
    
    NSString *service = model.service.service_name ?: @"";
    
    CGRect nameFrame = _goodsClass.frame;
    CGRect serviceFrame = _goodsName.frame;
    
    name = [NSString stringWithFormat:@"%@ - ", name];
    CGSize nameSize = [name sizeWithFontSize:kSmallFontSize forWidth:CGRectGetWidth(_boardView.frame)];
    nameFrame.size.width = nameSize.width;
    _goodsClass.frame = nameFrame;
    _goodsClass.text = name;
    
    //
    CGSize serviceSize = [service sizeWithFontSize:kSmallFontSize+2 forWidth:CGRectGetWidth(_boardView.frame)];
    serviceFrame.origin.x = CGRectGetMaxX(_goodsClass.frame);
    serviceFrame.size.width = serviceSize.width + 300;
    _goodsName.frame = serviceFrame;
    _goodsName.text = service;
    
}

- (void)makeGoodsInfoView
{
    CGFloat containerHeight = CGRectGetHeight(_iconContainer.frame) / 2;
    CGFloat x = CGRectGetMaxX(_iconContainer.frame) + kMargin10*2;
    CGFloat yoffset = 1.5;
    CGFloat width = CGRectGetWidth(_boardView.frame);
    // indicator
    UIImage *indicator = [UIImage imageNamed:@"Placehold"];
    _goodsIndicator = [[UIImageView alloc] initWithImage:indicator];
    _goodsIndicator.frame = CGRectMake(x, containerHeight + (containerHeight-kSmallImageSize)/2 - yoffset, kSmallImageSize, kSmallImageSize);
    [_boardView addSubview:_goodsIndicator];
    x += kSmallImageSize +kMargin5;
    
    // class
    NSString *class = @"Fitness Plan -";
    CGSize classSize = [class sizeWithFontSize:kSmallFontSize forWidth:width];
    CGFloat y = containerHeight - yoffset;
    CGRect classFrame = CGRectMake(x, y, classSize.width, containerHeight);
    _goodsClass = [AIViews normalLabelWithFrame:classFrame text:class fontSize:kSmallFontSize color:[UIColor colorWithWhite:1 alpha:1]];
    [_boardView addSubview:_goodsClass];
    x += classSize.width;
    
    // name
    NSString *name = @"Fitness Plan Making";
    CGSize nameSize = [name sizeWithFont:[UIFont boldSystemFontOfSize:kSmallFontSize] forWidth:width];
    
    CGRect nameFrame = CGRectMake(x, y, nameSize.width, containerHeight);
    _goodsName = [AIViews normalLabelWithFrame:nameFrame text:name fontSize:kSmallFontSize color:[UIColor whiteColor]];
    _goodsName.font = [AITools myriadBoldWithSize:33/2.5];
    //[UIFont boldSystemFontOfSize:kSmallFontSize];
    [_boardView addSubview:_goodsName];
    
}


#pragma mark - 时间
- (void)makeTimestamp
{
    CGFloat y = CGRectGetMaxY(_iconContainer.frame) + kMargin5/2;
    UIImage *image = [UIImage imageNamed:@"Seller_Location"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(kMargin10, y + (kStampHeight/2 - kSmallImageSize)/2, kSmallImageSize, kSmallImageSize);
    [_boardView addSubview:imageView];
    
    
    CGRect frame = CGRectMake(CGRectGetMaxX(imageView.frame)+kMargin5, y, 200, kStampHeight/2);
    _timestamp = [AIViews normalLabelWithFrame:frame text:@"14:00 Aug 2nd" fontSize:kSmallFontSize color:[UIColor colorWithWhite:kWhiteValue alpha:1]];
    [_boardView addSubview:_timestamp];
    _timestamp.font = [AITools myriadCondWithSize:33/2.5];
}

#pragma mark - 地点
- (void)makeLocation
{
    CGFloat y = kSellerIconHeight + kStampHeight/2 - kMargin5/2;
    UIImage *image = [UIImage imageNamed:@"Seller_Time"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(kMargin10, y, kSmallImageSize, kSmallImageSize);
    [_boardView addSubview:imageView];
    
    
    CGRect frame = CGRectMake(CGRectGetMaxX(imageView.frame)+kMargin5, y, 200, kSmallImageSize);
    _location = [AIViews normalLabelWithFrame:frame text:@"Fifth Avenue" fontSize:kSmallFontSize color:[UIColor colorWithWhite:kWhiteValue alpha:1]];
    [_boardView addSubview:_location];
    _location.font = [AITools myriadCondWithSize:33/2.5];
}

#pragma mark - 按钮
- (void)makeActionButton
{
    CGFloat y = CGRectGetHeight(_iconContainer.frame) - 3;
    CGFloat width = CGRectGetWidth(_boardView.frame);
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionButton.frame = CGRectMake(width-kButtonWidth, y, kButtonWidth, 24);
    [self setButtonType:SellerButtonTypePhone];
    [_boardView addSubview:_actionButton];
}

#pragma mark - 进度条
- (void)makeProgressBar
{
    CGFloat y = CGRectGetHeight(_iconContainer.frame);
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 2.1;
    CGRect frame = CGRectMake(0, y, width, 18);
    _progressBar = [[AISellingProgressBar alloc] initWithFrame:frame];
    [_boardView addSubview:_progressBar];
    [_progressBar setHidden:YES];
     
}

@end

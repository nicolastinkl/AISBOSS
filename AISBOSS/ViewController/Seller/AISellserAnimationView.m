//
//  AISellserAnimationView.m
//  AITrans
//
//  Created by 王坜 on 15/9/23.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AISellserAnimationView.h"
#import "AISellerViewController.h"


#define kCellHeight   95

@implementation AISellserAnimationView


// 截取整个view
+ (UIImage*)imageFromView:(UIView*)view
{
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


// 截取指定区域

+ (UIImage *)imageFromView:(UIView *)view inRect:(CGRect)rect
{
    
    CGSize s = rect.size;
    CGPoint pt = rect.origin;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    
    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-(int)pt.x, -(int)pt.y));
    [view.layer renderInContext:context];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
  
    UIGraphicsEndImageContext();
  	
    return screenImage; 

}




+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (void)animationDelay:(CGFloat)delay completion:(void(^)(void))completion
{
    dispatch_time_t time_t = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * delay);
    dispatch_after(time_t, dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
        
    });
}


+ (UIView *)logoViewWithFrame:(CGRect)frame
{
    
    UIImage *logo = [UIImage imageNamed:@"top_logo_default"];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:logo];
    logoView.frame = frame;
    
    return logoView;
}

+ (UIView *)bottomViewWithFrame:(CGRect)frame
{
    
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    UIView *bottomView = [[UIView alloc] initWithFrame:frame];
    
    
    // add shadow
    UIImage *shadowImage = [UIImage imageNamed:@"Seller_BarShadow"];
    UIImageView *shadow = [[UIImageView alloc] initWithImage:shadowImage];
    shadow.frame = CGRectMake(0, -shadowImage.size.height, width, shadowImage.size.height);
    [bottomView addSubview:shadow];
    
    // add bar
    UIImageView *barView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"serller_bar"]];
    barView.frame = CGRectMake(0, 0, width, height);
    [bottomView addSubview:barView];
    
    
    return bottomView;
}


+ (UIColor *)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b
{
    CGFloat sr = r/0xFF;
    CGFloat sg = g/0xFF;
    CGFloat sb = b/0xFF;
    UIColor *color = [UIColor colorWithRed:sr green:sg blue:sb alpha:1];
    return color;
}


+ (void)startAnimationOnSellerViewController:(AISellerViewController *)sellerViewController
{
    // Scroll TableView to Top
    UITableView *sellerTableView = sellerViewController.tableView;
    [sellerTableView setContentOffset:CGPointZero animated:NO];
    
    NSArray *cells = sellerTableView.visibleCells;
    
    

    // make Background
    UIView *background = [[UIView alloc] initWithFrame:sellerViewController.view.bounds];
    background.backgroundColor = [self colorWithR:30 g:27 b:56];
    [sellerViewController.view addSubview:background];

    // Cell Animations
    __block CGFloat duration = 0.25;
    CGFloat width = CGRectGetWidth(sellerTableView.frame);
    CGFloat height = 95;
    CGFloat x = 15;
    CGFloat y = 15 + (cells.count - 1) * height;
    CGFloat yOffset = 60;
    
    __weak UIView *weakBackground = background;
    
    NSArray *delays = @[@(0.65),@(0.6),@(0.55),@(0.5),@(0.45),@(0.4),@(0.35),@(0.3),@(0.2),@(0.1)];
    __block NSInteger count = delays.count - 1;
    
    for ( NSInteger i = cells.count - 1; i >= 0; i--) {

        CGRect imageFrame = CGRectMake(0, y, width, height);
        __block CGRect cellFrame = CGRectMake(x, y - yOffset, width, height);
        UIImage *image = [self imageFromView:sellerTableView inRect:imageFrame];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = cellFrame;
        imageView.alpha = 0;
        [background addSubview:imageView];
        
        NSNumber *delayNumber = delays[count];
        
        [self animationDelay:0 completion:^{
            
            [UIView animateWithDuration:delayNumber.floatValue  animations:^{
                cellFrame.origin.y = y;
                imageView.frame = cellFrame;
                imageView.alpha = 1;
            } completion:^(BOOL finished) {
                if (i == 0) {
                    [weakBackground removeFromSuperview];
                }
            }];
            
        }];
        
        count --;
        y -= height;
        yOffset += 40;
    }
    
    // Bottom Animation
    UIView *bottomView = [self bottomViewWithFrame:CGRectMake(0, CGRectGetHeight(background.frame), CGRectGetWidth(background.frame), 50)];
    [background addSubview:bottomView];
    
    [self animationDelay:0 completion:^{
        [UIView animateWithDuration:duration animations:^{
            bottomView.frame = CGRectMake(0, CGRectGetHeight(background.frame) - 50, CGRectGetWidth(background.frame), 50);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    
    // Logo Animation
    CGPoint logoCenter = sellerViewController.logoButton.center;
    
    UIView *logoView = [self logoViewWithFrame:CGRectMake(0, 0, 80, 80)];
    [bottomView addSubview:logoView];
    
    logoView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    logoView.center = CGPointMake(logoCenter.x, logoCenter.y - CGRectGetHeight(sellerViewController.view.frame) / 2 + 100);
    
    
    [self animationDelay:0 completion:^{
        [UIView animateWithDuration:duration animations:^{
            logoView.center = logoCenter;
            logoView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            if (cells.count == 0) {
                [weakBackground removeFromSuperview];
            }
        }];
    }];
    
    


}

@end

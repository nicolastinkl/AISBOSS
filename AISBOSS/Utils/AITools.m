//
//  AITools.m
//  AITrans
//
//  Created by 王坜 on 15/7/18.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AITools.h"


@implementation AITools

+ (MPMoviePlayerController *)playMovieNamed:(NSString *)name type:(NSString *)type onView:(UIView *)view
{
    //视频文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    //视频URL
    NSURL *url = [NSURL fileURLWithPath:path];
    //视频播放对象
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    player.controlStyle = MPMovieControlStyleNone;
    [player.view setFrame:view.bounds];
    player.shouldAutoplay = YES;
    player.scalingMode = MPMovieScalingModeAspectFill;
    [view addSubview:player.view];
    player.view.alpha = 0;
    player.view.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        player.view.alpha = 0.8;
    } completion:^(BOOL finished) {
        [player play];
    }];
    
    
    return player;
}

+ (void)performBlock:(void(^)(void))block delay:(CGFloat)delay
{
    
}


+ (UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if (!hex) return nil;
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return nil;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  nil;
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


#pragma mark - 重置View的宽度

+ (void)resetWidth:(CGFloat)width forView:(UIView *)view
{
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}

#pragma mark - 重置View的X
+ (void)resetOriginalX:(CGFloat)x forView:(UIView *)view
{
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}


+ (UIColor *)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b
{
    CGFloat sr = r/0xFF;
    CGFloat sg = g/0xFF;
    CGFloat sb = b/0xFF;
    UIColor *color = [UIColor colorWithRed:sr green:sg blue:sb alpha:1];
    return color;
}


#pragma mark - Image From View

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

#pragma mark - Animation Delay
+ (void)animationDelay:(CGFloat)delay completion:(void(^)(void))completion
{
    dispatch_time_t time_t = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * delay);
    dispatch_after(time_t, dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
        
    });
}


#pragma mark - 读取json文件返回string
+ (NSString *)readJsonWithFileName:(NSString *)fileName fileType:(NSString *)fileType
{
    NSString *fileString = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSData *data = [fileManager contentsAtPath:path];
        if (data) {
            fileString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    
    // 去除空格和换行符
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *finalStr = [fileString stringByTrimmingCharactersInSet:whitespace];
    finalStr = [finalStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    finalStr = [finalStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    finalStr = [finalStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return finalStr;
}

#pragma mark - 把图片变为灰度图
+ (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}


#pragma mark - New Fonts

+ (UIFont *) myriadRegularWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"MyriadPro-Regular" size:size];
}

+ (UIFont *) myriadBoldWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"MyriadPro-Bold" size:size];
}

+ (UIFont *) myriadLightSemiCondensedWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"MyriadPro-LightSemiCn" size:size];
}

+ (UIFont *) myriadLightSemiExtendedWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"MyriadPro-LightSemiExt" size:size];
}

+ (UIFont *) myriadSemiCondensedWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"MyriadPro-SemiCn" size:size];
}

#pragma mark - Most Color


@end

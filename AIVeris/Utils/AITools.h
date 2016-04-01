//
//  AITools.h
//  AITrans
//
//  Created by 王坜 on 15/7/18.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define Color_HighWhite        [AITools colorWithR:0xFF g:0xFF b:0xFF]

#define Color_MiddleWhite      [AITools colorWithR:0xa1 g:0xa4 b:0xba]

#define Color_LowWhite         [AITools colorWithR:0x96 g:0x93 b:0xb0]



@interface AITools : NSObject

/*说明：播放bundle里的视频文件
 *
 */
+ (MPMoviePlayerController *)playMovieNamed:(NSString *)name type:(NSString *)type onView:(UIView *)view;

+ (AVAudioPlayer *)playAccAudio:(NSURL*) filename;

+ (void)performBlock:(void(^)(void))block delay:(CGFloat)delay;

+ (UIColor*)colorWithHexString:(NSString*)hex;

// CGRect

+ (void)resetWidth:(CGFloat)width forView:(UIView *)view;

+ (void)resetOriginalX:(CGFloat)x forView:(UIView *)view;

+ (UIColor *)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a;

+ (UIColor *)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b;

+ (UIImage*)imageFromView:(UIView*)view;

+ (UIImage *)imageFromView:(UIView *)view inRect:(CGRect)rect;

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

+ (void)animationDelay:(CGFloat)delay completion:(void(^)(void))completion;


//


+ (NSString *)readJsonWithFileName:(NSString *)fileName fileType:(NSString *)fileType;

// UIImage
+ (UIImage *) convertImageToGrayScale: (UIImage *) image;

// Fonts

+ (UIFont *) myriadRegularWithSize:(CGFloat)size;

+ (UIFont *) myriadBoldWithSize:(CGFloat)size;

+ (UIFont *) myriadLightSemiCondensedWithSize:(CGFloat)size;

+ (UIFont *) myriadLightSemiExtendedWithSize:(CGFloat)size;

+ (UIFont *) myriadSemiCondensedWithSize:(CGFloat)size;

+ (CGFloat)displaySizeFrom1080DesignSize:(CGFloat)size;
//1242像素转为point单位
+ (CGFloat)displaySizeFrom1242DesignSize:(CGFloat)size;

+ (UIFont *) myriadCondWithSize:(CGFloat)size;
+ (UIFont *) myriadBlackWithSize:(CGFloat)size;
+ (UIFont *) myriadLightWithSize:(CGFloat)size;
+ (UIFont *) myriadSemiboldSemiCnWithSize:(CGFloat)size;

+ (CGSize)imageDisplaySizeFrom1080DesignSize:(CGSize)size;

+ (NSString *)formatDateFromSeconds:(NSString *)seconds;

@end




#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


@end





@interface UIScrollView(UITouch)

@end

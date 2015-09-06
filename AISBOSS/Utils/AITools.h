//
//  AITools.h
//  AITrans
//
//  Created by 王坜 on 15/7/18.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AITools : NSObject

/*说明：播放bundle里的视频文件
 *
 */
+ (MPMoviePlayerController *)playMovieNamed:(NSString *)name type:(NSString *)type onView:(UIView *)view;


+ (void)performBlock:(void(^)(void))block delay:(CGFloat)delay;

+ (UIColor*)colorWithHexString:(NSString*)hex;

@end

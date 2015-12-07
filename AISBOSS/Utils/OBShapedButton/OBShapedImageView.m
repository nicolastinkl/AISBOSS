//
//  OBShapedImageView.m
//  AIVeris
//
//  Created by admin on 12/7/15.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

#import "OBShapedImageView.h"
#import "UIImage+ColorAtPixel.h"

#define kAlphaVisibleThreshold (0.1f)

@interface OBShapedImageView ()

@end

@implementation OBShapedImageView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    

    BOOL result = [self isAlphaVisibleAtPoint:point forImage:self.image];
    return result;
}

- (BOOL)isAlphaVisibleAtPoint:(CGPoint)point forImage:(UIImage *)image
{
    // Correct point to take into account that the image does not have to be the same size
    // as the button. See https://github.com/ole/OBShapedButton/issues/1
    CGSize iSize = image.size;
    CGSize bSize = self.bounds.size;
    point.x *= (bSize.width != 0) ? (iSize.width / bSize.width) : 1;
    point.y *= (bSize.height != 0) ? (iSize.height / bSize.height) : 1;
    
    UIColor *pixelColor = [image colorAtPixel:point];
    CGFloat alpha = 0.0;
    
    if ([pixelColor respondsToSelector:@selector(getRed:green:blue:alpha:)])
    {
        // available from iOS 5.0
        [pixelColor getRed:NULL green:NULL blue:NULL alpha:&alpha];
    }
    else
    {
        // for iOS < 5.0
        // In iOS 6.1 this code is not working in release mode, it works only in debug
        // CGColorGetAlpha always return 0.
        CGColorRef cgPixelColor = [pixelColor CGColor];
        alpha = CGColorGetAlpha(cgPixelColor);
    }
    return !alpha >= kAlphaVisibleThreshold;
}

@end

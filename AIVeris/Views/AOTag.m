//
//  AOTag.m
//  AOTagDemo
//
//  Created by Loïc GRIFFIE on 16/09/13.
//  Copyright (c) 2013 Appsido. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AOTag.h"

#define tagFontSize         13.0f
#define tagFontType         @"Helvetica-Light"
#define tagMargin           5.0f
#define tagMarginFrame      10.0f
#define tagHeight           20.0f
#define tagCornerRadius     10.0f
#define tagCloseButton      7.0f

@interface AOTagList ()

@property (nonatomic, strong) NSNumber *tFontSize;
@property (nonatomic, strong) NSString *tFontName;

@end

@implementation AOTagList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        
        self.tags = [NSMutableArray array];
        
        self.tFontSize = [NSNumber numberWithFloat:tagFontSize];
        self.tFontName = tagFontType;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    int n = 0;
    float x = 40.0f;
    float y = 0.0f;
    
    for (id v in [self subviews])
        if ([v isKindOfClass:[AOTag class]])
            [v removeFromSuperview];
    
    for (AOTag *tag in self.tags)
    {
        if (x + [tag getTagSize].width + tagMarginFrame > self.frame.size.width) { n = 0; x = 40.0; y += [tag getTagSize].height + tagMarginFrame; }
        else x += (n ? tagMarginFrame : 0.0f);
        
        [tag setFrame:CGRectMake(x, y, [tag getTagSize].width, [tag getTagSize].height)];
        [self addSubview:tag];
        
        x += [tag getTagSize].width;
        
        n++;
    }
    
    CGRect r = [self frame];
    r.size.height = y + tagHeight;
    [self setFrame:r];
}

- (void)setTagFont:(NSString *)name withSize:(CGFloat)size
{
    [self setTFontSize:[NSNumber numberWithFloat:size]];
    [self setTFontName:name];
}

- (AOTag *)generateTagWithLabel:(NSString *)tTitle withImage:(NSString *)tImage
{
    AOTag *tag = [[AOTag alloc] initWithFrame:CGRectZero];
    
    [tag setTFontName:self.tFontName];
    [tag setTFontSize:self.tFontSize];
    
    [tag setDelegateTag:self.delegateTag];
    //[tag setTImage:[UIImage imageNamed:tImage]];
    [tag setTTitle:tTitle];
    
    [self.tags addObject:tag];
    
    return tag;
}

- (void)addTag:(NSString *)tTitle
{
    [self generateTagWithLabel:(tTitle ? tTitle : @"") withImage:(@"")];
    
    [self setNeedsDisplay];
}

- (void)addTag:(NSString *)tTitle withImage:(NSString *)tImage
{
    [self generateTagWithLabel:(tTitle ? tTitle : @"") withImage:(tImage ? tImage : @"")];
    
    [self setNeedsDisplay];
}

- (void)addTag:(NSString *)tTitle withImageURL:(NSURL *)imageURL andImagePlaceholder:(NSString *)tPlaceholderImage
{
    AOTag *tag = [self generateTagWithLabel:(tTitle ? tTitle : @"") withImage:(tPlaceholderImage ? tPlaceholderImage : @"")];
    [tag setTURL:imageURL];
    
    [self setNeedsDisplay];
}

- (void)addTag:(NSString *)tTitle
     withImage:(NSString *)tImage
withLabelColor:(UIColor *)labelColor
withBackgroundColor:(UIColor *)backgroundColor
withCloseButtonColor:(UIColor *)closeColor
{
    AOTag *tag = [self generateTagWithLabel:(tTitle ? tTitle : @"") withImage:(tImage ? tImage : @"")];
    
    if (labelColor) [tag setTLabelColor:labelColor];
    if (backgroundColor) [tag setTBackgroundColor:backgroundColor];
    if (closeColor) [tag setTCloseButtonColor:closeColor];
    
    [self setNeedsDisplay];
}

- (void)addTag:(NSString *)tTitle
withImagePlaceholder:(NSString *)tPlaceholderImage
  withImageURL:(NSURL *)imageURL
withLabelColor:(UIColor *)labelColor
withBackgroundColor:(UIColor *)backgroundColor
withCloseButtonColor:(UIColor *)closeColor
{
    AOTag *tag = [self generateTagWithLabel:(tTitle ? tTitle : @"") withImage:(tPlaceholderImage ? tPlaceholderImage : @"")];
    
    [tag setTURL:imageURL];
    
    if (labelColor) [tag setTLabelColor:labelColor];
    if (backgroundColor) [tag setTBackgroundColor:backgroundColor];
    if (closeColor) [tag setTCloseButtonColor:closeColor];
    
    [self setNeedsDisplay];
}

- (void)addTags:(NSArray *)tags
{
    for (NSDictionary *tag in tags)
        [self addTag:[tag objectForKey:@"title"] withImage:[tag objectForKey:@"image"]];
}

- (void)removeTag:(AOTag *)tag
{
    [self.tags removeObject:tag];
    
    [self setNeedsDisplay];
}

- (void)removeAllTag
{
    for (id t in [NSArray arrayWithArray:[self tags]])
        [self removeTag:t];
}

@end

@implementation AOTag

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.tBackgroundColor = [UIColor colorWithRed:37/255 green:30/255 blue:55/255 alpha:0.7];
        self.tLabelColor = [UIColor whiteColor];
        self.tCloseButtonColor = [UIColor colorWithRed:0.710 green:0.867 blue:0.953 alpha:1.000];
        
        self.tFontSize = [NSNumber numberWithFloat:tagFontSize];
        self.tFontName = tagFontType;
        
        self.tURL = nil;
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        
        [[self layer] setCornerRadius:tagCornerRadius];
        [[self layer] setMasksToBounds:YES];
        
    }
    return self;
}

- (CGSize)getTagSize
{
    CGSize tSize = ([self.tTitle respondsToSelector:@selector(sizeWithAttributes:)] ? [self.tTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:self.tFontName size:[self.tFontSize floatValue]]}] : [self.tTitle sizeWithFont:[UIFont fontWithName:self.tFontName size:[self.tFontSize floatValue]]]);
    
    return CGSizeMake(tagHeight + tagMargin + tSize.width  + tagCloseButton, tagHeight);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //#251E37
    
    self.layer.backgroundColor = [self.tBackgroundColor CGColor];
    
//    self.tImageURL = [[EGOImageView alloc] initWithPlaceholderImage:self.tImage delegate:self];
//    [self.tImageURL setBackgroundColor:[UIColor purpleColor]];
//    [self.tImageURL setFrame:CGRectMake(0.0f, 0.0f, [self getTagSize].height, [self getTagSize].height)];
//    if (self.tURL) [self.tImageURL setImageURL:[self tURL]];
//    [self addSubview:self.tImageURL];
    
   if ([self.tTitle respondsToSelector:@selector(drawAtPoint:withAttributes:)])
    {
        
        [self.tTitle drawInRect:CGRectMake(tagHeight - 10 , ([self getTagSize].height / 2.0f) - ([self getTagSize].height / 3.0f)-2, [self getTagSize].width, [self getTagSize].height)
                 withAttributes:@{NSFontAttributeName:[UIFont fontWithName:self.tFontName size:[self.tFontSize floatValue]], NSForegroundColorAttributeName:self.tLabelColor}];
    }else{
        [self.tLabelColor set];
        [self.tTitle drawInRect:CGRectMake(tagHeight - 10  , ([self getTagSize].height / 2.0f) - ([self getTagSize].height / 2.0f), [self getTagSize].width, [self getTagSize].height)
                       withFont:[UIFont fontWithName:self.tFontName size:[self.tFontSize floatValue]] lineBreakMode:NSLineBreakByWordWrapping];
    }

    
    AOTagCloseButton *close = [[AOTagCloseButton alloc] initWithFrame:CGRectMake([self getTagSize].width - tagHeight, 0.0, tagHeight, tagHeight)
                                                            withColor:[UIColor whiteColor]];
    [self addSubview:close];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagSelected:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:recognizer];
    
    if (self.delegateTag && [self.delegateTag respondsToSelector:@selector(tagDidAddTag:)])
        [self.delegateTag performSelector:@selector(tagDidAddTag:) withObject:self];
}

- (void)tagSelected:(id)sender
{
    if (self.delegateTag && [self.delegateTag respondsToSelector:@selector(tagDidSelectTag:)])
        [self.delegateTag performSelector:@selector(tagDidSelectTag:) withObject:self];
}

- (void)tagClose:(id)sender
{
    if (self.delegateTag && [self.delegateTag respondsToSelector:@selector(tagDidRemoveTag:)])
        [self.delegateTag performSelector:@selector(tagDidRemoveTag:) withObject:self];
    
    [(AOTagList *)[self superview] removeTag:self];
}

#pragma mark - EGOImageView Delegate methods

//- (void)imageViewLoadedImage:(EGOImageView *)imageView
//{
//    if (self.delegateTag && [self.delegateTag respondsToSelector:@selector(tagDistantImageDidLoad:)])
//        [self.delegateTag performSelector:@selector(tagDistantImageDidLoad:) withObject:self];
//}
//
//- (void)imageViewFailedToLoadImage:(EGOImageView *)imageView error:(NSError*)error
//{
//    if (self.delegateTag && [self.delegateTag respondsToSelector:@selector(tagDistantImageDidFailLoad:withError:)])
//        [self.delegateTag performSelector:@selector(tagDistantImageDidFailLoad:withError:) withObject:self withObject:error];
//}

@end

@implementation AOTagCloseButton

- (id)initWithFrame:(CGRect)frame withColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        
        [self setCColor:color];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(rect.size.width - tagCloseButton + 1.0, (rect.size.height - tagCloseButton) / 2.0)];
    [bezierPath addLineToPoint:CGPointMake(rect.size.width - (tagCloseButton * 2.0) + 1.0, ((rect.size.height - tagCloseButton) / 2.0) + tagCloseButton)];
    [self.cColor setStroke];
    bezierPath.lineWidth = 2.0;
    [bezierPath stroke];
    
    UIBezierPath *bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint:CGPointMake(rect.size.width - tagCloseButton + 1.0, ((rect.size.height - tagCloseButton) / 2.0) + tagCloseButton)];
    [bezier2Path addLineToPoint:CGPointMake(rect.size.width - (tagCloseButton * 2.0) + 1.0, (rect.size.height - tagCloseButton) / 2.0)];
    [self.cColor setStroke];
    bezier2Path.lineWidth = 2.0;
    [bezier2Path stroke];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagClose:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:recognizer];
}

- (void)tagClose:(id)sender
{
    if ([[self superview] respondsToSelector:@selector(tagClose:)])
        [[self superview] performSelector:@selector(tagClose:) withObject:self];
}

@end
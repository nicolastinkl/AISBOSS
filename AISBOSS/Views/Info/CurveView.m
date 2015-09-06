//
//  CavasLineView.m
//  DataStructure
//
//  Created by 王坜 on 15/7/8.
//  Copyright (c) 2015年 Wang Li. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "CurveView.h"

#import "AIViews.h"



#define kLogoMaxWidth 150


#define kLineRate   20

#define kCurveRate   0.2




@interface CurveView ()
{
    CAShapeLayer *_curShapeLayer;
}

@property (nonatomic, strong) NSArray *displayPoints;



@end

@implementation CurveView

- (id)initWithFrame:(CGRect)frame points:(NSArray *)points
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //[self makeBackgroundImages];
        
        [self parseModels:points];
    }
    
    return self;
}



#pragma mark - 外部方法

- (void)startEdit
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBubbleShouldShowDeleteButtonNotification object:nil];
}

- (void)endEdit
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBubbleShouldHideDeleteButtonNotification object:nil];
}

- (void)undoDeleteWithModel:(CurveModel *)model
{
    CAShapeLayer *lineLayer = [self addCurveLineWithModel:model];
    BubbleView *bubble = [self animateCicleAlongPathWithModel:model];
    bubble.linkedLineLayer = lineLayer;
    
    [self.bubbleCompareModels setObject:bubble forKeyedSubscript:model.displayTitle];
}

- (void)undoAddWithTitle:(NSString *)title{
    // find bubble and delete it
    BubbleView *bubble = [self.bubbleCompareModels objectForKey:title];
    if (!bubble) {
        return;
    }
    
    [bubble shouldDisppear];
    [self.bubbleCompareModels removeObjectForKey:title];
}

- (void)undoAddWithModel:(CurveModel *)model
{
    // find bubble and delete it
    BubbleView *bubble = [self.bubbleCompareModels objectForKey:model.displayTitle];
    if (!bubble) {
        return;
    }
    
    [bubble shouldDisppear];
    [self.bubbleCompareModels removeObjectForKey:model.displayTitle];
}

- (void)addBubbleWithModel:(CurveModel *)model
{
    [self makeControlPointsForModel:model];
    CAShapeLayer *lineLayer = [self addCurveLineWithModel:model];
    BubbleView *bubble = [self animateCicleAlongPathWithModel:model];
    bubble.linkedLineLayer = lineLayer;
    
    [self.bubbleCompareModels setObject:bubble forKeyedSubscript:model.displayTitle];
}


#pragma mark - 内部方法

- (void)makeBackgroundImages
{
    UIImage *bgImage = [UIImage imageNamed:@"scanbg"];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [bgImageView setImage:bgImage];
    [self addSubview:bgImageView];
    
    UIImage *logo = [UIImage imageNamed:@"scan_logo"];
    CGFloat height = kLogoMaxWidth * logo.size.height / logo.size.width;
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - kLogoMaxWidth) / 2, (CGRectGetHeight(self.frame) - height) / 2, kLogoMaxWidth, height)];
    [logoView setImage:logo];
    [self addSubview:logoView];
    
    
}

//This draws a quadratic bezier curved line right across the screen
- ( void ) drawACurvedLine {
    //Create a bitmap graphics context, you will later get a UIImage from this
    UIGraphicsBeginImageContext(CGSizeMake(320,460));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //
    
    CGPoint startPoint = CGPointMake(160, 420);
    CGPoint endPoint = CGPointMake(160, 120);
    CGPoint control1 = CGPointMake(120, 320);
    CGPoint control2 = CGPointMake(120, 220);
    
    //Set variables in the context for drawing
    CGContextSetLineWidth(ctx, 1.5);
    CGContextMoveToPoint(ctx, startPoint.x, startPoint.y);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    CGContextAddCurveToPoint(ctx,
                             control1.x,
                             control1.y,
                             control2.x,
                             control2.y,
                             endPoint.x,
                             endPoint.y);
    //Draw the line
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //Get a UIImage from the current bitmap context we created at the start and then end the image context
    UIImage *curve = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //With the image, we need a UIImageView
    UIImageView *curveView = [[UIImageView alloc] initWithImage:curve];
    //Set the frame of the view - which is used to position it when we add it to our current UIView
    curveView.frame = CGRectMake(1, 1, 320, 460);
    curveView.backgroundColor = [UIColor clearColor];
    //[self addSubview:curveView];
}



#pragma mark - 圆形视图

- (BubbleView *) animateCicleAlongPathWithModel:(CurveModel *)model {

    //add start point
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(model.startX, model.startY, 5, 5)];
    pointView.backgroundColor = model.displayColor;
    pointView.layer.cornerRadius = 2.5;
    pointView.center = CGPointMake(model.startX, model.startY);
    [self addSubview:pointView];
    
    // add Bubble
    CGRect bubbleFrame = CGRectMake(model.startX, model.startY, model.displayWidth, model.displayWidth);
    BubbleView *bubble = [[BubbleView alloc] initWithFrame:bubbleFrame model:model];
    bubble.linkedPointView = pointView;
    bubble.delegate = self;
    [self addSubview:bubble];
    
    return bubble;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//


- (void)parseModels:(NSArray *)models
{
    
    self.displayModels = [NSMutableArray arrayWithArray:models];
    
    if (self.displayModels == nil || self.displayModels.count == 0) {
        return;
    }
    
    self.bubbleCompareModels = [NSMutableDictionary dictionary];

    
    for (CurveModel *model in self.displayModels) {
        [self makeControlPointsForModel:model];
        CAShapeLayer *lineLayer = [self addCurveLineWithModel:model];
        BubbleView *bubble = [self animateCicleAlongPathWithModel:model];
        bubble.linkedLineLayer = lineLayer;
        
        [self.bubbleCompareModels setObject:bubble forKeyedSubscript:model.displayTitle];
    }
}


#pragma mark - 设置 ControlPoint

- (void)makeControlPointsForModel:(CurveModel *)model
{
    CGFloat distance = [self distanceFromPoint:CGPointMake(model.startX, model.startY) toPoint:CGPointMake(model.endX, model.endY)];
    CGFloat offset = distance / 3;
    CGFloat curveOffset = kCurveRate * distance;
    CGFloat distanceX = model.endX - model.startX;
    CGFloat offsetX = distanceX / 3;
    CGFloat distanceY = model.endY - model.startY;
    CGFloat offsetY = distanceY / 3;
    
    //
    CGFloat b1 = sqrt((offset*offset) - (offsetX*offsetX));
    CGFloat b2 = sqrt((4*offset*offset) - (4*offsetX*offsetX));
    
    // 接近一条水平线,方向从左到右
    if (fabs(model.startY - model.endY) <= kLineRate && model.endX > model.startX) {
        model.control1X = model.startX + offsetX;
        model.control1Y = model.startY - curveOffset;
        model.control2X = model.startX + offsetX*2;
        model.control2Y = model.startY - curveOffset;
    }
    
    // 接近一条水平线，从右到左
    else if (fabs(model.startY - model.endY) <= kLineRate && model.endX < model.startX)
    {
        model.control1X = model.startX + offsetX;
        model.control1Y = model.startY + curveOffset;
        model.control2X = model.startX + offsetX*2;
        model.control2Y = model.startY + curveOffset;
    }
    // 接近一条垂直线，从上到下
    else if (fabs(model.startX - model.endX) <= kLineRate && model.endY > model.startY)
    {
        model.control1X = model.startX + curveOffset;
        model.control1Y = model.startY + offsetY;
        model.control2X = model.startX + curveOffset;
        model.control2Y = model.startY + offsetY*2;
    }
    // 接近一条垂直线，从下到上
    else if (fabs(model.startX - model.endX) <= kLineRate && model.endY < model.startY)
    {
        model.control1X = model.startX - curveOffset;
        model.control1Y = model.startY + offsetY;
        model.control2X = model.startX - curveOffset;
        model.control2Y = model.startY + offsetY*2;
    }
    // 从左到右斜上
    else if (model.startY > model.endY && model.startX < model.endX)
    {
        
        
        model.control1X = model.startX + offsetX;
        model.control1Y = model.startY - b1 - curveOffset;
        model.control2X = model.startX + offsetX*2;
        model.control2Y = model.startY - b2 - curveOffset;
    }
    // 从左到右斜下
    else if (model.startY < model.endY && model.startX < model.endX)
    {
        model.control1X = model.startX + offsetX;
        model.control1Y = model.startY + b1 - curveOffset;
        model.control2X = model.startX + offsetX*2;
        model.control2Y = model.startY + b2 - curveOffset;
    }
    // 从右到左斜上
    else if (model.startX > model.endX && model.startY > model.endY)
    {
        model.control1X = model.startX + offsetX;
        model.control1Y = model.startY - b1 + curveOffset;
        model.control2X = model.startX + offsetX*2;
        model.control2Y = model.startY - b2 + curveOffset;
    }
    // 从右到左斜下
    else if (model.startX > model.endX && model.startY < model.endY)
    {
        model.control1X = model.startX + offsetX;
        model.control1Y = model.startY + b1 + curveOffset;
        model.control2X = model.startX + offsetX*2;
        model.control2Y = model.startY + b2 + curveOffset;
    }
    
}



-(float)distanceFromPoint:(CGPoint)start toPoint:(CGPoint)end{
    CGFloat distance;
    CGFloat xDist = (end.x - start.x);
    CGFloat yDist = (end.y - start.y);
    distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}



- (CAShapeLayer *)addCurveLineWithModel:(CurveModel *)model
{
    CGPoint startPoint = CGPointMake(model.startX, model.startY);
    CGPoint endPoint = CGPointMake(model.endX, model.endY);
    CGPoint control1 = CGPointMake(model.control1X, model.control1Y);
    CGPoint control2 = CGPointMake(model.control2X, model.control2Y);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addCurveToPoint:endPoint controlPoint1:control1 controlPoint2:control2];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = model.strokeColor.CGColor;
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = model.strokeWidth;
    pathLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:pathLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = model.animationDuration;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    return pathLayer;
}



//曲线动画
-(void)drawCurveFrom:(CGPoint)startPoint
                  to:(CGPoint)endPoint
       controlPoint1:(CGPoint)controlPoint1
       controlPoint2:(CGPoint)controlPoint2
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [[UIColor redColor] CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 1.0f;
    pathLayer.lineJoin = kCALineJoinBevel;
    [self.layer addSublayer:pathLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0f;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    //pathAnimation.repeatCount = 1000;
    [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

#pragma mark - BubbleDelegate

- (void)bubbleViewDidDeleteBubble:(CurveModel *)bubbleModel
{
    [self.bubbleCompareModels removeObjectForKey:bubbleModel.displayTitle];
    if ([self.delegate respondsToSelector:@selector(curveViewDidDeleteBubble:)]) {
        [self.delegate curveViewDidDeleteBubble:bubbleModel];
    }
}


@end

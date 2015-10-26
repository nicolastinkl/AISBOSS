//
//  AIBubblesView.m
//  AIVeris
//
//  Created by 王坜 on 15/10/21.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIBubblesView.h"
#import "AIBuyerBubbleModel.h"
#import "AIBubble.h"
#import <math.h>


#define kBubbleMargin 8

@interface AIBubblesView ()
{
    UIView *_testView;
}

@property (nonatomic,strong) UIDynamicAnimator *animator;

@property (nonatomic, strong) NSMutableDictionary *hierarchyDic;

@property (nonatomic, strong) NSMutableArray *bubbleModels;

@property (nonatomic, strong) NSMutableArray *bubbles;

@end



@implementation AIBubblesView


- (id) initWithFrame:(CGRect)frame models:(NSArray *)models
{
    self = [super initWithFrame:frame];
    if (self) {
        _bubbleModels = [models mutableCopy];
        [self parseBubbleDatas];
        [self makeBubbles];
        //[self makeCycleLayer];
    }
    
    return self;
}

#pragma mark - 构造基础数据

- (void) parseBubbleDatas
{
    self.hierarchyDic = [[NSMutableDictionary alloc] init];
    self.bubbleModels = [[NSMutableArray alloc] initWithArray:@[@"1", @"2", @"3", @"4", @"2", @"3", @"4", @"2", @"3", @"4"]];
    self.bubbles = [[NSMutableArray alloc] init];
}

#pragma mark - 画圆

- (void)drawCycleWithPath:(CGPathRef )path
{
    
    //创建CGContextRef
    UIGraphicsBeginImageContext(_testView.bounds.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //将CGMutablePathRef添加到当前Context内
    CGContextAddPath(gc, path);
    [[UIColor clearColor] setFill];
    [[UIColor blueColor] setStroke];
    CGContextSetLineWidth(gc, 2);
    //执行绘画
    CGContextDrawPath(gc, kCGPathFillStroke);
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [_testView addSubview:imgView];


}


#pragma mark - 查找给定path上的点

- (void)makeCycleLayer
{
    if (_testView) {
        return;
    }
    _testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    _testView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    
    [self addSubview:_testView];
    /**创建圆形的贝塞尔曲线*/
    
    UIBezierPath *shapePath=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 200)];
    //shapePath=[UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:100 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    /**创建带形状的图层*/
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.frame=CGRectMake(0, 0, 100, 100);
    shapeLayer.position=self.center;
    shapeLayer.borderWidth = 1;
    shapeLayer.borderColor = [UIColor redColor].CGColor;
    /**注意:图层之间与贝塞尔曲线之间通过path进行关联*/
    shapeLayer.path=shapePath.CGPath;
    NSLog(@"%@",shapePath.CGPath);
    
    shapeLayer.fillColor=[UIColor blackColor].CGColor;
    //[_testView.layer addSublayer:shapeLayer];
    
    CGPoint point=CGPointMake(100, 50);
    CGPoint outPoint=CGPointMake(1, 1);
    if (CGPathContainsPoint(shapePath.CGPath, NULL, point, NO))
    {
        NSLog(@"point in path!");
    }
    if (!CGPathContainsPoint(shapePath.CGPath, NULL, outPoint, NO))
    {
        NSLog(@"outPoint out path!");
    }
    
    
    
    NSMutableArray *thePoints = [[NSMutableArray alloc] init];
   
    CGPathApply(shapePath.CGPath, (__bridge void * _Nullable)(thePoints), MyCGPathApplierFunc);
    
    NSLog(@"points %@", thePoints);
    //[self testGravityAndCollision4];
    
    [self drawCycleWithPath:shapePath.CGPath];
    
}
void MyCGPathApplierFunc (void *info, const CGPathElement *element) {
    NSMutableArray *thePoints = (__bridge NSMutableArray *)info;
    
    CGPoint *points = element->points;
    [thePoints addObject:[NSValue valueWithCGPoint:points[0]]];
 
}


#pragma mark - 判断给定点是否在制定区域里
- (void)test
{
    CGMutablePathRef pathRef=CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, 4, 4);
    CGPathAddLineToPoint(pathRef, NULL, 4, 14);
    CGPathAddLineToPoint(pathRef, NULL, 14, 14);
    CGPathAddLineToPoint(pathRef, NULL, 14, 4);
    CGPathAddLineToPoint(pathRef, NULL, 4, 4);
    CGPathCloseSubpath(pathRef);
    CGPoint point=CGPointMake(5, 5);
    CGPoint outPoint=CGPointMake(1, 1);
    if (CGPathContainsPoint(pathRef, NULL, point, NO))
    {
        NSLog(@"point in path!");
    }
    if (!CGPathContainsPoint(pathRef, NULL, outPoint, NO))
    {
        NSLog(@"outPoint out path!");
    }
}

//////////////////////
/**
 *  用圆作为边界
 */

-(UIDynamicAnimator *)animator
{
    if (_animator==nil) {
    //创建物理仿真器（ReferenceView:参照视图，设置仿真范围）
    self.animator=[[UIDynamicAnimator alloc]initWithReferenceView:_testView];
    }
    return _animator;
}


- (void)testGravityAndCollision4
{
    // 1.重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
    [gravity addItem:_testView];
    
    // 2.碰撞检测行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] init];
    [collision addItem:_testView];
    
    // 添加一个椭圆为碰撞边界
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 50) radius:20 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [collision addBoundaryWithIdentifier:@"circle" forPath:path];
    
    // 3.开始仿真
    //[self.animator addBehavior:gravity];
    [self.animator addBehavior:collision];
}


#pragma mark - 构造中心区域取随机点

- (CGPoint) randomPointWithCenterCycleR:(CGFloat)r
{
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    
    CGFloat randomR = arc4random() % (NSInteger)r ;    // 随机半径
    CGFloat angle = (arc4random() % 360) * M_PI / 180; // 随机角度
    
    CGFloat x = center.x + randomR * cos(angle);
    CGFloat y = center.y + randomR * sin(angle);
    
    return CGPointMake(x, y);
}


#pragma mark - 根据已知气泡的圆心，设置新气泡的圆心


- (CGPoint) calculateCenterWithPoint
{
    return CGPointZero;
}


#pragma mark - 计算两点距离

-(CGFloat)distanceFromPointA:(CGPoint)pointA toPointB:(CGPoint)pointB
{
    CGFloat distance = 0;
    CGFloat xDist = (pointB.x - pointA.x);
    CGFloat yDist = (pointB.y - pointA.y);
    distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}


#pragma mark - 获取圆周上所有点

- (NSArray *)allPointsOnCycleWithR:(CGFloat)r center:(CGPoint)center
{
    
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    CGFloat anchorOffset = M_PI / 45;
    CGFloat anchort = 0;
    
    while (anchort < 2 * M_PI) {
        CGFloat x = center.x + r * cos(anchort);
        CGFloat y = center.y + r * sin(anchort);
        
        NSValue *value = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [points addObject:value];
        
        anchort += anchorOffset;
    }
    
    return points;
    
}

#pragma mark - 检查气泡是否超出边界

- (BOOL)didBubbleOutOfRangeWithCenter:(CGPoint)center radius:(CGFloat)radius
{
    BOOL isOut = NO;
    
    if (center.x - radius < 0) {
        return YES;
    }
    
    if (center.x + radius > CGRectGetWidth(self.frame)) {
        return YES;
    }
    
    if (center.y - radius < 0) {
        return YES;
    }
    
    if (center.y + radius > CGRectGetHeight(self.frame)) {
        return YES;
    }
    
    
    return isOut;
}


#pragma mark - 检查是否与其他的气泡重合

- (BOOL)didReclosingToOtherBubbleAtPoint:(CGPoint)point radius:(CGFloat)radius
{
    BOOL isReclosing = NO;
    
    for (AIBubble *bubble in self.bubbles) {

        CGFloat distance = [self distanceFromPointA:point toPointB:bubble.center];
        
        if (distance < (bubble.radius + radius + kBubbleMargin)) {
            isReclosing = YES;
            break;
        }
    }
    
    return isReclosing;
}

#pragma mark - 寻找气泡合适的位置

- (CGPoint)searchCenterForBubble:(AIBubble *)bubble withCenterBubble:(AIBubble *)centerBubble
{

    CGPoint center = CGPointZero;
    
    // 计算圆心之间的合适距离
    CGFloat radius = bubble.radius + centerBubble.radius + kBubbleMargin;
    
    // 获取中心点合适距离圆圈上的所有点
    NSArray *points = [self allPointsOnCycleWithR:radius center:centerBubble.center];
    
    // 构造随机遍历数组
    NSMutableArray *muPoints = [[NSMutableArray alloc] initWithArray:points];
    
    NSMutableArray *rightPoints = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < points.count; i++) {
        
        NSInteger index = arc4random() % [muPoints count];
        NSValue *value = [muPoints objectAtIndex:index];
        
        CGPoint point = value.CGPointValue;
        
        if (![self didReclosingToOtherBubbleAtPoint:point radius:bubble.radius]) {

            if (![self didBubbleOutOfRangeWithCenter:point radius:bubble.radius]) {
                
                NSValue *rightValue = [NSValue valueWithCGPoint:point];
                [rightPoints addObject:rightValue];
            }
            
        }
        
        [muPoints removeObjectAtIndex:index];

    }
    
    
    center = [self nearestPointInPoints:rightPoints];
    
    
    return center;
}


#pragma mark - 从所有点中寻找距离圆心最近的点

- (CGPoint)nearestPointInPoints:(NSArray *)points
{
    CGPoint nearestPoint = CGPointZero;
    
    if (points.count == 0) {
        return nearestPoint;
    }
    
    
    CGFloat minDistance = CGFLOAT_MAX;
    AIBubble *firstBubble = self.bubbles.firstObject;
    
    CGPoint center = firstBubble.center;
    
    for (NSInteger i = 0; i < points.count; i++) {
        
        NSValue *value = [points objectAtIndex:i];
        CGPoint point = value.CGPointValue;
        CGFloat distance = [self distanceFromPointA:point toPointB:center];
        
        if (distance < minDistance) {
            nearestPoint = point;
            minDistance = distance;
        }
  
    }
    
    return nearestPoint;
}


#pragma mark - 构造气泡

- (void) makeBubbles
{
    for (NSInteger i = 0; i < _bubbleModels.count; i++) {
        
        // AIBuyerBubbleModel *model = [_bubbleModels objectAtIndex:i];

        // 构造bubble
        
        AIBubble *bubble = [[AIBubble alloc] initWithCenter:CGPointZero model:nil];
        
        // 计算bubble的center
        
        CGPoint center = CGPointZero;
        
        
        NSMutableArray *rightPoints = [[NSMutableArray alloc] init];
        
        BOOL shouldAddBubble = NO;
        
        if (i == 0) {
            // 第一个圆在中心区域随机取一点
            shouldAddBubble = YES;
            center = [self randomPointWithCenterCycleR:[AIBubble smaBubbleRadius]];
            NSValue *rightValue = [NSValue valueWithCGPoint:center];
            [rightPoints addObject:rightValue];
        }
        else
        {
            //
            
            
            
            for (AIBubble *centerBubble in self.bubbles) {
               center = [self searchCenterForBubble:bubble withCenterBubble:centerBubble];
                
                if (!CGPointEqualToPoint(center, CGPointZero)) {
                    shouldAddBubble = YES;
                    NSValue *rightValue = [NSValue valueWithCGPoint:center];
                    [rightPoints addObject:rightValue];
                }
            }
            
        }
        
        if (shouldAddBubble) {
            center = [self nearestPointInPoints:rightPoints];
            bubble.center = center;
            [self.bubbles addObject:bubble];
            [self addSubview:bubble];
        }
    }
  
}


@end

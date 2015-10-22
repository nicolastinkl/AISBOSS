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
//#import <math.h>

@interface AIBubblesView ()
{
    UIView *_testView;
}

@property(nonatomic,strong)UIDynamicAnimator *animator;

@end



@implementation AIBubblesView


- (id) initWithFrame:(CGRect)frame models:(NSArray *)models
{
    self = [super initWithFrame:frame];
    if (self) {
        _bubbleModels = [models copy];
        
        [self makeBubbles];
        //[self makeCycleLayer];
    }
    
    return self;
}



- (void) parseBubbleDatas
{
    
}

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
    CGPoint randomPoint = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    
    return randomPoint;
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


#pragma mark - 构造气泡

- (void) makeBubbles
{
    AIBubble *centerBubble = nil;
    BOOL shouldBeCenter = NO;
    _bubbleModels = @[@"1", @"2", @"3", @"4"];
    
    NSInteger count = 0;
    
    for (NSInteger i = 0; i < _bubbleModels.count; i++) {
        
        //AIBuyerBubbleModel *model = [_bubbleModels objectAtIndex:i];
        
        // 计算bubble的center
        
        CGPoint center = CGPointZero;
        if (i == 0) {
            center = [self randomPointWithCenterCycleR:1];
            shouldBeCenter = YES;
            count ++;
        }
        else
        {
            //
          
            
            
            
        }
        
        // 构造bubble
        AIBubble *bubble = [[AIBubble alloc] initWithCenter:center model:nil];
        
        // 记住中心圆
        if (shouldBeCenter) {
            centerBubble = bubble;
        }
        
        [self addSubview:bubble];
    }
    
    
    
    
    
    
    
}


@end

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
#import "Veris-Swift.h"


#define big         @"big"
#define middle      @"middle"
#define small       @"small"
#define kBubbleMargin 8

@interface AIBubblesView ()
{
    UIView *_testView;
}

@property (nonatomic,strong) UIDynamicAnimator *animator;

@property (nonatomic, strong) NSMutableDictionary *hierarchyDic;

@property (nonatomic, strong) NSMutableArray *bubbleModels;

@property (nonatomic, strong) NSMutableArray *bubbles;

@property (nonatomic, strong) NSMutableDictionary *cacheBubble;

@property (nonatomic, copy) BubbleBlock selfBlock;


@end



@implementation AIBubblesView


- (id) initWithFrame:(CGRect)frame models:(NSMutableArray *)models
{
    self = [super initWithFrame:frame];
    if (self) {
        _bubbleModels = [models mutableCopy];
        [self parserBubbleColors];
        [self parseBubbleDatas];
        [self makeBubbles];
        
    }
    
    return self;
}

- (void) addGestureBubbleAction:(BubbleBlock) block{
    self.selfBlock = block;
}

#pragma mark - 构造基础数据

- (void)parserBubbleColors
{
    
    NSArray *deepColor = @[@"aa6e28",@"ad2063",@"7e3d60",@"438091",@"936d4c",@"574d71" , @"5f257d",@"162c18",@"6b4a1d",@"4a5679",@"1b1a3a",@"ca9e82",@"6a8e5c",@"",@"",@"",@""];
    NSArray *undertoneColor = @[@"cdaf13",@"cf4e5a",@"c3746a", @"6c929f",@"ae9277" ,@"696a9a", @"9c417c", @"32542c", @"aa822a" ,@"7e6479",@"81476a",@"5198ac", @"93a44b",@"",@"",@"",@""];
    NSArray *borderColor = @[@"fee34a",@"ef6d83", @"f88d8e", @"6db8d5",@"f8b989", @"8986c2",@"cd53e1", @"528319", @"e6ad44", @"8986c2" ,@"c474ac" ,@"9bd6f2" ,@"93bd78", @"f88d8e",@"",@"",@"",@""];
    
    
    for (int i = 0; i < _bubbleModels.count; i++) {
        AIBuyerBubbleModel *model = [_bubbleModels objectAtIndex:i];
        model.deepColor = [deepColor objectAtIndex:i];
        model.undertoneColor = [undertoneColor objectAtIndex:i];
        model.borderColor = [borderColor objectAtIndex:i];
    }
}


- (void) parseBubbleDatas
{
    self.hierarchyDic = [[NSMutableDictionary alloc] init];
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
    
    CGFloat anchorOffset = M_PI / 45; // 角度4°
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


#pragma mark - 放置推荐小气泡

- (CGPoint)inserTinyBubbleForBubble:(AIBubble *)bubble withPoints:(NSArray *)points
{
    CGPoint center = CGPointZero;
    
    CGPoint tcenter = CGPointZero;
    
    // 计算圆心之间的合适距离
    CGFloat radius = [AIBubble tinyBubbleRadius] + bubble.radius + kBubbleMargin - 6;
    
    // 遍历中心圆的圆心,依次寻找tiny气泡的位置
    for (NSValue *value in points) {
        CGPoint point = value.CGPointValue;
        
        // 获取中心点合适距离圆圈上的所有点
        NSArray *tpoints = [self allPointsOnCycleWithR:radius center:point];
        
        // 构造随机遍历数组
        NSMutableArray *muPoints = [[NSMutableArray alloc] initWithArray:tpoints];
        
        for (NSInteger i = 0; i < tpoints.count; i++) {
            
            NSInteger index = arc4random() % [muPoints count];
            NSValue *tvalue = [muPoints objectAtIndex:index];
            
            CGPoint tpoint = tvalue.CGPointValue;
            
            if (![self didReclosingToOtherBubbleAtPoint:tpoint radius:[AIBubble tinyBubbleRadius]]) {
                
                if (![self didBubbleOutOfRangeWithCenter:tpoint radius:[AIBubble tinyBubbleRadius]]) {
                    center = point;
                    tcenter = tpoint;
                    break;
                }
                
            }
            
            [muPoints removeObjectAtIndex:index];
            
        }
        
        
        if (!CGPointEqualToPoint(tcenter, CGPointZero)) {
            NSLog(@"Tiny Center : %@", [NSValue valueWithCGPoint:tcenter]);
            // 添加 tiny 气泡
            AIBuyerBubbleModel *model = [[AIBuyerBubbleModel alloc] init];
            model.bubbleSize = [AIBubble tinyBubbleRadius];
            AIBubble *tinyBubble = [[AIBubble alloc] initWithCenter:tcenter model:bubble.bubbleModel type:typeToSignIcon Index:self.bubbles.count];
            [self.bubbles addObject:tinyBubble];
            [self addSubview:tinyBubble];
            bubble.center = center;
            [self rotateTinyBubble:tinyBubble forBubble:bubble];
            
            break;
        }

    }
    
    
    return center;

}

#pragma mark - 旋转小气泡

- (void)rotateTinyBubble:(AIBubble *)tinyBubble forBubble:(AIBubble *)bubble
{
    
    CGFloat dist = tinyBubble.radius + bubble.radius + kBubbleMargin;
    
    CGFloat xo = bubble.center.x - tinyBubble.center.x;
    
    CGFloat yo = bubble.center.y - tinyBubble.center.y;
    
    CGFloat angle = 0;

    
    //
    if (xo > 0 && yo > 0) { // 1
        angle = 2*M_PI - asin(xo / dist) ;
    }
    else if (xo < 0 && yo > 0) { // 2
        angle = - asin(xo / dist) ;
    }
    else if (xo > 0 && yo < 0) { // 3
        angle = asin(xo / dist) - M_PI;
    }
    else if (xo <0 && yo < 0) { // 4
        angle = asin(xo / dist) + M_PI ;
    }
    else if (xo == 0 && yo > 0) { // up
        angle = 0;
    }
    else if (yo == 0 && yo < 0) { // down
        angle = M_PI;
    }
    
    CGAffineTransform transform = tinyBubble.transform;
//    tinyBubble.transform = CGAffineTransformRotate(transform,angle);
    tinyBubble.rotateBubleImageView.transform = CGAffineTransformRotate(transform,angle);

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
    
    // 选择距离中心圆最近的点
    
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


#pragma mark - 寻找占比最高的方案

- (void)makeMoreCompact
{
    
}


#pragma mark - 构造气泡

- (void)sortBubbleModels
{
    
    NSMutableArray *sortModles = [[NSMutableArray alloc] init];
    
    NSInteger bigCount = 0;
    
    for (AIBuyerBubbleModel *model in _bubbleModels) {
        if (model.service_list.count >= 6){
            bigCount ++;
            [sortModles insertObject:model atIndex:0];
        }else if (model.service_list.count >= 3 && model.service_list.count <= 5){
            [sortModles insertObject:model atIndex:bigCount];
        }else {
            [sortModles addObject:model];
        }
    }
    
    _bubbleModels = [NSMutableArray arrayWithArray:sortModles];

}

- (void) makeBubbles
{
    // 构造+气泡
    if (_bubbleModels.count == 0) {
        return;
    }
    
    [self sortBubbleModels];
    
    
    self.cacheBubble = [[NSMutableDictionary alloc ] init];
    [self.cacheBubble setValue:@1 forKey:big];
    [self.cacheBubble setValue:@(4) forKey:middle];
    [self.cacheBubble setValue:@(self.bubbleModels.count-5) forKey:small];
    
    // Add AddButton
    /**
     typeToNormal = 0,
     typeToSignIcon = 1,//
     typeToAdd = 2//
     */
    {
        AIBuyerBubbleModel* modelAdd = [[AIBuyerBubbleModel alloc] init];
        modelAdd.bubbleType = 2;
        [self.bubbleModels addObject:modelAdd];
    }
    
    //这里处理随机乱序
    /*NSUInteger count = _bubbleModels.count;
    
    // 循环将倒数第n张牌中的随机一张放到整个扑克的最后
    for(int n=count;n>=0;n--){
        int rand = (int)(random()/(float)RAND_MAX*n);
        NSNumber *pokeMoveToEnd = [_bubbleModels objectAtIndex:rand];
        [_bubbleModels removeObjectAtIndex:rand];
        [_bubbleModels addObject:pokeMoveToEnd];
    }*/
    
    __block int indexView = 0;
    __weak typeof(self) weakSelf = self;
    [_bubbleModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AIBuyerBubbleModel *model  = obj;
        NSUInteger i = idx;
        
        // 构造bubble
        /*
        NSNumber * numberBig = [weakSelf.cacheBubble valueForKey:big];
        NSNumber * numberMiddle = [weakSelf.cacheBubble valueForKey:middle];
        NSNumber * numberSmall= [weakSelf.cacheBubble valueForKey:small];
        if (numberBig.intValue > 0) {
            model.bubbleSize = [AIBubble bigBubbleRadius];
            [weakSelf.cacheBubble setValue:@0 forKey:big];
        }else  if (numberMiddle.intValue > 0) {
            model.bubbleSize = [AIBubble midBubbleRadius];
            int newValue = numberMiddle.intValue - 1;
            [weakSelf.cacheBubble setValue:@(newValue) forKey:middle];
        }else if (numberSmall.intValue > 0) {
            model.bubbleSize = [AIBubble smaBubbleRadius];
            int newValue = numberSmall.intValue - 1;
            [weakSelf.cacheBubble setValue:@(newValue) forKey:small];
        }else{
            model.bubbleSize = [AIBubble smaBubbleRadius];
        }*/
        
        if (model.service_list.count >= 6){
            model.bubbleSize = [AIBubble bigBubbleRadius];
        }else if (model.service_list.count >= 3 && model.service_list.count <= 5){
            model.bubbleSize = [AIBubble midBubbleRadius];
        }else {
            model.bubbleSize = [AIBubble smaBubbleRadius];
        }
        
        AIBubble *bubble;
        
        if (model.service_id > 0) {
           
            
        }
        
        if (model.bubbleType == 2) {
            bubble = [[AIBubble alloc] initWithCenter:CGPointZero model:model type:typeToAdd Index:indexView];
        
        }else if (model.bubbleType == 1) {
            bubble = [[AIBubble alloc] initWithCenter:CGPointZero model:model type:typeToSignIcon Index:indexView];
            
        }else{
            bubble = [[AIBubble alloc] initWithCenter:CGPointZero model:model type:typeToNormal Index:indexView];
        }
        
        indexView += 1;
        // 计算bubble的center
        
        CGPoint center = CGPointZero;        
        
        NSMutableArray *rightPoints = [[NSMutableArray alloc] init];
        
        BOOL shouldAddBubble = NO;
        
        if (i == 0) {
            // 第一个圆在中心区域随机取一点
            shouldAddBubble = YES;
            center = [weakSelf randomPointWithCenterCycleR:[AIBubble smaBubbleRadius]];
            //bubble = [[AIBubble alloc] initWithCenter:CGPointZero model:[[AIBuyerBubbleModel alloc] init]];
            NSValue *rightValue = [NSValue valueWithCGPoint:center];
            [rightPoints addObject:rightValue];
        }
        else
        {
            
            for (AIBubble *centerBubble in weakSelf.bubbles) {
                
                if (centerBubble.radius == [AIBubble tinyBubbleRadius]) {
                    continue;
                }
                
               center = [weakSelf searchCenterForBubble:bubble withCenterBubble:centerBubble];
                
                if (!CGPointEqualToPoint(center, CGPointZero)) {
                    shouldAddBubble = YES;
                    NSValue *rightValue = [NSValue valueWithCGPoint:center];
                    [rightPoints addObject:rightValue];
                }
            }
            
        }
        
        if (shouldAddBubble) {
            
            if (bubble.hadRecommend) {
                center = [weakSelf inserTinyBubbleForBubble:bubble withPoints:rightPoints];
                if (CGPointEqualToPoint(center, CGPointZero)) {
                    // 没找到合适点放tiny，重新寻找
                }
            }
            else
            {
                center = [weakSelf nearestPointInPoints:rightPoints];
            }
 
            bubble.center = center;
            [weakSelf.bubbles addObject:bubble];
            
        }
    }];
 
}

- (void)targetCurrentProposalAction:(UITapGestureRecognizer *)gestureRecogner{
    AIBubble *bubble = (AIBubble*)gestureRecogner.view;
    AIBuyerBubbleModel * buModel =  bubble.bubbleModel;     
    // 处理界面过渡
    if (buModel != nil) {
        self.selfBlock(buModel,bubble);
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];

    int indexView = 0;
    for (AIBubble *bubble in self.bubbles) {
        bubble.index = indexView;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetCurrentProposalAction:)];
        [bubble addGestureRecognizer:tap];
        bubble.userInteractionEnabled = YES;
        
        UIView *newView = [[UIView alloc] init];
        newView.frame = bubble.frame;
        newView.backgroundColor = [UIColor clearColor];
        newView.center = bubble.center;
        [newView addSubview:bubble];
        [self addSubview:newView];
        bubble.center = CGPointMake(newView.width/2, newView.width/2);
        
        
        /** 这里处理随机Pop动画*/
        float force = 0.4f;
        float duration = 1.0f;
        float repeatCount = 1.0f;
        float delay = 0.1;
        CAKeyframeAnimation* animation = [[CAKeyframeAnimation alloc] init];
        animation.keyPath = @"transform.scale";
        animation.values = @[@0, @(0.2*force), @(-0.2*force), @(0.2*force),@(0)];
        animation.keyTimes = @[@0, @(0.2), @(0.4), @(0.6), @(0.8), @1];
        animation.timingFunction = [[CAMediaTimingFunction alloc]  initWithControlPoints:0.5 :(1.1+force/3):1 :1];
        animation.duration = duration;
        animation.additive = true;
        animation.repeatCount = repeatCount;
        animation.beginTime = CACurrentMediaTime() + delay;
        [newView.layer addAnimation:animation forKey:@"pop"];
        indexView += 1;
    }

}

@end

//
//  AIParamedicView.m
//  AIVeris
//
//  Created by 王坜 on 15/11/24.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIParamedicView.h"
#import "AIServiceCoverage.h"
#import "AIDetailText.h"


#import "AITools.h"
#import "AIViews.h"
#import "UP_NSString+Size.h"

@interface AIParamedicView ()
{
    CGFloat _sideMargin;
}

@end


@implementation AIParamedicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self makeProperties];
        [self makeSubViews];
    }
    
    return self;
}


- (void)makeProperties
{
    _sideMargin = [AITools displaySizeFrom1080DesignSize:35];
}


- (void)makeSubViews
{
    CGFloat y = [AITools displaySizeFrom1080DesignSize:32];
    CGFloat width = CGRectGetWidth(self.frame) - _sideMargin * 2;
    //
    CGRect textFrame = CGRectMake(_sideMargin, y, width, 0);
    NSString *title = @"Session include:";
    NSString *detail = @"Session includeSession includeSession includeSession includeSession includeSession includeSession includeSession includeSession includeSession includeSession includeSession include";
    AIDetailText *detailText = [[AIDetailText alloc] initWithFrame:textFrame titile:title detail:detail];
    [self addSubview:detailText];
    
    //
    y += CGRectGetHeight(detailText.frame) + [AITools displaySizeFrom1080DesignSize:34];
    [self addLineViewAtY:y];
    //
    y += [AITools displaySizeFrom1080DesignSize:70];
    
    CGRect coverageFrame = CGRectMake(_sideMargin, y, width, 0);
    AIParamedicCoverageModel *model = [[AIParamedicCoverageModel alloc] init];
    model.title = @"Service Coverage";
    model.labels = @[@"Medichine Pickup", @"Queuing", @"Calling For Taxi", @"Check-in", @"Paramedic", @"Test Result Pickup"];
    AIServiceCoverage *corverage = [[AIServiceCoverage alloc] initWithFrame:coverageFrame model:model];
    [self addSubview:corverage];
    
    //
    //
    y += [AITools displaySizeFrom1080DesignSize:60] + CGRectGetHeight(corverage.frame);
    
    CGFloat imageHeight = [AITools displaySizeFrom1080DesignSize:97];
    UIImage *image = [UIImage imageNamed:@"Wave_BG"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, y, CGRectGetWidth(self.frame), imageHeight);
    [self addSubview:imageView];
    //
    UPLabel *amLabel = [AIViews normalLabelWithFrame:CGRectMake(0, y, CGRectGetWidth(self.frame), imageHeight) text:@"€ 100 / session" fontSize:[AITools displaySizeFrom1080DesignSize:63] color:[AITools colorWithR:0xf7 g:0x9a b:0x00]];
    amLabel.textAlignment = NSTextAlignmentCenter;
    amLabel.font = [AITools myriadSemiboldSemiCnWithSize:[AITools displaySizeFrom1080DesignSize:63]];
    
    [self addSubview:amLabel];
    
    
    //
    y += [AITools displaySizeFrom1080DesignSize:14] + imageHeight;
    [self addLineViewAtY:y];
    y += 1;
    // reset frame
    CGRect myFrame = self.frame;
    myFrame.size.height = y;
    self.frame = myFrame;

}

- (void)addLineViewAtY:(CGFloat)y
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.frame), 1)];
    line.backgroundColor = [AITools colorWithR:0xa1 g:0xa4 b:0xba a:0.4];
    
    [self addSubview:line];
}

@end

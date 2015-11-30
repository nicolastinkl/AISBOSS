//
//  AIMusicTherapyView.m
//  AIVeris
//
//  Created by 王坜 on 15/11/24.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIMusicTherapyView.h"
#import "AICommentCell.h"
#import "AIDetailText.h"
#import "AIHorizontalBarChart.h"
#import "AIServiceTypes.h"
#import "AIStarRate.h"
#import "AITools.h"
#import "AIViews.h"
#import "UP_NSString+Size.h"

@interface AIMusicTherapyView ()
{
    CGFloat _sideMargin;
}

@end


@implementation AIMusicTherapyView


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

- (void)addLineViewAtX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, 0.5)];
    line.backgroundColor = [AITools colorWithR:0xa1 g:0xa4 b:0xba a:0.4];
    
    [self addSubview:line];
}


- (void)addLineViewAtY:(CGFloat)y
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.frame), 0.5)];
    line.backgroundColor = [AITools colorWithR:0xa1 g:0xa4 b:0xba a:0.4];
    
    [self addSubview:line];
}


- (NSAttributedString *)attrAmountWithAmount:(NSString *)amount
{
    // find range
    
    NSRange anchorRange = [amount rangeOfString:@"/"];
    
    if (anchorRange.location == NSNotFound) {
        return nil;
    }
    
    NSRange headRange = NSMakeRange(0, anchorRange.location - 1);
    
    NSRange tailRange = NSMakeRange(anchorRange.location, amount.length - anchorRange.location);
    
    UIFont *headFont = [AITools myriadSemiboldSemiCnWithSize:[AITools displaySizeFrom1080DesignSize:63]];
    UIFont *tailFont = [AITools myriadLightSemiCondensedWithSize:[AITools displaySizeFrom1080DesignSize:42]];
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:amount];
    [attriString addAttribute:NSFontAttributeName value:headFont range:headRange];
    [attriString addAttribute:NSFontAttributeName value:tailFont range:tailRange];
    
    
    return attriString;
}

- (void)makeSubViews
{
    CGFloat y = [AITools displaySizeFrom1080DesignSize:32];
    CGFloat width = CGRectGetWidth(self.frame) - _sideMargin * 2;
    //
    CGRect textFrame = CGRectMake(_sideMargin, y, width, 0);
    NSString *title = @"Session include:";
    NSString *detail = @"These hourly sessions include bonding and communicating with your baby, guided imagery and visualization for birth and well being, therapeutic healing with the voice exercises and mandala drawing. Tailored sessions are provided to choose.";
    AIDetailText *detailText = [[AIDetailText alloc] initWithFrame:textFrame titile:title detail:detail];
    [self addSubview:detailText];
    
    //
    y += CGRectGetHeight(detailText.frame) + [AITools displaySizeFrom1080DesignSize:34];
    [self addLineViewAtY:y];
    //
    y += [AITools displaySizeFrom1080DesignSize:39];
    
    CGRect frame = CGRectMake(_sideMargin, y, width, 0);
    AIMusicServiceTypesModel *serviceTypesModel = [[AIMusicServiceTypesModel alloc] init];
    serviceTypesModel.title = @"Service Type";
    serviceTypesModel.types = @[@"Individual Presental Music Session", @"Group Session By Trimester", @"Private Home/Hospital Session"];
    
    AIServiceTypes *serviceTypes = [[AIServiceTypes alloc] initWithFrame:frame model:serviceTypesModel];
    [self addSubview:serviceTypes];
    
    //
    y += [AITools displaySizeFrom1080DesignSize:60] + CGRectGetHeight(serviceTypes.frame);
    
    CGFloat imageHeight = [AITools displaySizeFrom1080DesignSize:97];
    UIImage *image = [UIImage imageNamed:@"Wave_BG"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, y, CGRectGetWidth(self.frame), imageHeight);
    [self addSubview:imageView];
    //
    UPLabel *amLabel = [AIViews normalLabelWithFrame:CGRectMake(0, y, CGRectGetWidth(self.frame), imageHeight) text:@"€ 100 / session" fontSize:[AITools displaySizeFrom1080DesignSize:63] color:[AITools colorWithR:0xf7 g:0x9a b:0x00]];
    
    amLabel.attributedText = [self attrAmountWithAmount:@"€ 100 / session"];
    amLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:amLabel];
    
    
    //
    y += [AITools displaySizeFrom1080DesignSize:14] + imageHeight;
    [self addLineViewAtY:y];
    
    //
    y += [AITools displaySizeFrom1080DesignSize:37];
    CGFloat fontSize = [AITools displaySizeFrom1080DesignSize:42];
    CGRect evaluationRect = CGRectMake(_sideMargin, y, width, fontSize);
    UPLabel *evaluationLabel = [AIViews normalLabelWithFrame:evaluationRect text:@"Service content evaluation" fontSize:fontSize color:[UIColor whiteColor]];
    evaluationLabel.font = [AITools myriadSemiCondensedWithSize:fontSize];
    [self addSubview:evaluationLabel];
    
    //
    CGFloat moreFontSize = [AITools displaySizeFrom1080DesignSize:31];
    UPLabel *moreLabel = [AIViews normalLabelWithFrame:evaluationRect text:@"178 More Reviews >" fontSize:moreFontSize color:[AITools colorWithR:0x61 g:0xb0 b:0xfa]];
    moreLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:moreLabel];
    
    //
    y += fontSize + [AITools displaySizeFrom1080DesignSize:28];
    CGFloat starSize = [AITools displaySizeFrom1080DesignSize:39];
    
    CGRect starFrame = CGRectMake(_sideMargin, y, 100, starSize);
    AIStarRate *starRate = [[AIStarRate alloc] initWithFrame:starFrame rate:4.5];
    [self addSubview:starRate];
    
    //
    NSString *reviewStr = @"180 reviews";
    CGFloat reFontSize = [AITools displaySizeFrom1080DesignSize:42];
    CGFloat reviewX = CGRectGetMaxX(starRate.frame) + [AITools displaySizeFrom1080DesignSize:40];
    CGSize reviewSize = [reviewStr sizeWithFont:[AITools myriadSemiCondensedWithSize:reFontSize] forWidth:width];
    
    CGRect reviewFrame = CGRectMake(reviewX, y, reviewSize.width, reviewSize.height);
    UPLabel *reviewLabel = [AIViews normalLabelWithFrame:reviewFrame text:reviewStr fontSize:[AITools displaySizeFrom1080DesignSize:reFontSize] color:Color_LowWhite];
    reviewLabel.font = [AITools myriadSemiCondensedWithSize:reFontSize];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:reviewStr];
    
    NSRange range = NSMakeRange(4, 7);
    
    [attr addAttribute:NSFontAttributeName value:[AITools myriadLightSemiCondensedWithSize:fontSize] range:range];
    reviewLabel.attributedText = attr;
    
    
    
    [self addSubview:reviewLabel];
    
    //
    UIImage *zanImage = [UIImage imageNamed:@"Zan"];
    CGRect zanFrame = CGRectMake(CGRectGetMaxX(reviewLabel.frame)+[AITools displaySizeFrom1080DesignSize:31], y, [AITools displaySizeFrom1080DesignSize:42], [AITools displaySizeFrom1080DesignSize:42]);
    UIImageView *zanView = [[UIImageView alloc] initWithImage:zanImage];
    zanView.frame = zanFrame;
    
    [self addSubview:zanView];
    
    //
    
    UPLabel *perLabel = [AIViews normalLabelWithFrame:CGRectMake(CGRectGetMaxX(zanFrame) + 5, y, width, [AITools displaySizeFrom1080DesignSize:42]) text:@"95%" fontSize:[AITools displaySizeFrom1080DesignSize:reFontSize] color:Color_LowWhite];
    perLabel.font = [AITools myriadSemiCondensedWithSize:reFontSize];
    [self addSubview:perLabel];
    
    //
    y += starSize + [AITools displaySizeFrom1080DesignSize:50];
    NSArray *models = [self fakeCharts];
    
    for (AIMusicChartModel *model in models) {
        CGFloat height = [AITools displaySizeFrom1080DesignSize:34];
        CGRect frame = CGRectMake(_sideMargin, y, width, height);
        AIHorizontalBarChart *chart = [[AIHorizontalBarChart alloc] initWithFrame:frame model:model];
        [self addSubview:chart];
        
        y += height + [AITools displaySizeFrom1080DesignSize:23];
    }
    
    //
    
    y += [AITools displaySizeFrom1080DesignSize:50] - [AITools displaySizeFrom1080DesignSize:23];
    
    
    //
    
    NSString *ctitle = @"Helpful Reviews";
    UIFont *cfont = [AITools myriadSemiCondensedWithSize:fontSize];
    CGSize csize = [ctitle sizeWithFont:cfont forWidth:width];
    
    UIImage *cimage = [UIImage imageNamed:@"Comment_Title_BG"];
    cimage = [cimage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    UIImageView *cimageView = [[UIImageView alloc] initWithImage:cimage];
    CGFloat cimageViewHeight = [AITools displaySizeFrom1080DesignSize:73];
    cimageView.frame = CGRectMake(_sideMargin, y, 30 + csize.width, cimageViewHeight);
    
    [self addSubview:cimageView];
    
    
    //
    UPLabel *commentLabel = [AIViews normalLabelWithFrame:CGRectMake(0, 0, cimageView.frame.size.width, [AITools displaySizeFrom1080DesignSize:73]) text:ctitle fontSize:fontSize color:[UIColor whiteColor]];
    commentLabel.font = cfont;
    commentLabel.textAlignment = NSTextAlignmentCenter;
    [cimageView addSubview:commentLabel];
    
    //
    y += [AITools displaySizeFrom1080DesignSize:73];
    
    [self addLineViewAtY:y];
    
    y += 1 + [AITools displaySizeFrom1080DesignSize:22];
    //
    NSArray *comments = [self fakeComments];
    NSMutableArray *mIcons = [[NSMutableArray alloc] initWithArray:@[[UIImage imageNamed:@"MusicHead1"], [UIImage imageNamed:@"MusicHead2"]]];
    
    for (int i = 0; i < comments.count; i++) {
        
        
        AIMusicCommentsModel *comment = [comments objectAtIndex:i];
        CGRect frame = CGRectMake(_sideMargin, y, width, 0);
        
        AICommentCell *cell = [[AICommentCell alloc] initWithFrame:frame model:comment];
        [self addSubview:cell];
        
        y += CGRectGetHeight(cell.frame) + [AITools displaySizeFrom1080DesignSize:22];
        
        if (i == comments.count - 1) {
            [self addLineViewAtY:y];
        }
        else
        {
            [self addLineViewAtX:_sideMargin y:y width:CGRectGetWidth(self.frame) - _sideMargin*2];
        }
        
        y +=  [AITools displaySizeFrom1080DesignSize:22];
        
        //Fake Image
        cell.defaultIcon.image = [mIcons firstObject];
        [mIcons removeObjectAtIndex:0];
        
    }
    
    
    y -= [AITools displaySizeFrom1080DesignSize:22] -0.5;
    // reset frame
    CGRect myFrame = self.frame;
    myFrame.size.height = y;
    self.frame = myFrame;
    
}


- (NSArray *)fakeCharts
{
    NSMutableArray *fakeCharts = [[NSMutableArray alloc] init];
    
    AIMusicChartModel *model = [[AIMusicChartModel alloc] init];
    model.title = @"excellent";
    model.percentage = 0.9;
    model.number = @"171";
    [fakeCharts addObject:model];

    model = [[AIMusicChartModel alloc] init];
    model.title = @"good";
    model.percentage = 0.1;
    model.number = @"8";
    [fakeCharts addObject:model];
    
    model = [[AIMusicChartModel alloc] init];
    model.title = @"average";
    model.percentage = 0.03;
    model.number = @"1";
    [fakeCharts addObject:model];
    
    model = [[AIMusicChartModel alloc] init];
    model.title = @"poor";
    model.percentage = 0;
    model.number = @"0";
    [fakeCharts addObject:model];
    
    model = [[AIMusicChartModel alloc] init];
    model.title = @"terrible";
    model.percentage = 0;
    model.number = @"0";
    [fakeCharts addObject:model];
    
    
    
    return fakeCharts;
}

- (NSArray *)fakeComments
{
    NSMutableArray *fakeComments = [[NSMutableArray alloc] init];
    
    AIMusicCommentsModel *model = [[AIMusicCommentsModel alloc] init];
    model.headIcon = nil;//@"http://b.hiphotos.baidu.com/baike/c0%3Dbaike72%2C5%2C5%2C72%2C24/sign=b8640aff662762d09433acedc185639f/8d5494eef01f3a293c7d60129c25bc315d607cb0.jpg";
    model.name = @"Jenna";
    model.rate = 4.5;
    model.time = @"Sep 28th, 2015";
    model.comment = @"Thank you, Grace Yang. You were such an important figure in my transition. You helped me immensely to keep my heart and mind open, at a time when I was quite unsure and afraid. Thank you very much ...";
    [fakeComments addObject:model];
    
    model = [[AIMusicCommentsModel alloc] init];
    model.headIcon = nil;//@"http://b.hiphotos.baidu.com/baike/c0%3Dbaike72%2C5%2C5%2C72%2C24/sign=b8640aff662762d09433acedc185639f/8d5494eef01f3a293c7d60129c25bc315d607cb0.jpg";
    model.name = @"Haya";
    model.rate = 4.5;
    model.time = @"Sep 28th, 2015";
    model.comment = @"Grace Yang enabled an amazing sense of calm, love, beauty and joy to our experience. I am not sure if it was her energy, or the music, or the wonderful aromatic oils she had brought. But it all blended so naturally...";
    [fakeComments addObject:model];
    
    
    return fakeComments;
}

@end

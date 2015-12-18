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
#import "Veris-Swift.h"

@interface AIMusicTherapyView () <AIServiceTypesDelegate>
{
    CGFloat _sideMargin;
}

@property (nonatomic, strong) AIProposalServiceDetailModel *detailModel;
@property (nonatomic, strong) JSONModel *submitData;

@end

@implementation AIMusicTherapyView

- (id)initWithFrame:(CGRect)frame model:(AIProposalServiceDetailModel *)model
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.detailModel = model;
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
    AIDetailText *detailText = [[AIDetailText alloc] initWithFrame:textFrame titile:self.detailModel.service_intro_title detail:self.detailModel.service_intro_content];
    [self addSubview:detailText];
    
    //
    y += CGRectGetHeight(detailText.frame) + [AITools displaySizeFrom1080DesignSize:34];
    [self addLineViewAtY:y];
    //
    y += [AITools displaySizeFrom1080DesignSize:39];
    
    CGRect frame = CGRectMake(_sideMargin, y, width, 0);
    
    
    AIServiceTypes *serviceTypes = [self addServiceTypes:frame];
    
    if (serviceTypes) {
        y += [AITools displaySizeFrom1080DesignSize:60] + CGRectGetHeight(serviceTypes.frame);
    }
    
    CGFloat imageHeight = [AITools displaySizeFrom1080DesignSize:97];
    UIImage *image = [UIImage imageNamed:@"Wave_BG"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, y, CGRectGetWidth(self.frame), imageHeight);
    [self addSubview:imageView];
    //
    UPLabel *amLabel = [AIViews normalLabelWithFrame:CGRectMake(0, y, CGRectGetWidth(self.frame), imageHeight) text:_detailModel.service_price.original fontSize:[AITools displaySizeFrom1080DesignSize:63] color:[AITools colorWithR:0xf7 g:0x9a b:0x00]];
    NSString *price = [NSString stringWithFormat:@"%@ %f", _detailModel.service_price.unit, _detailModel.service_price.price];
    amLabel.attributedText = [self attrAmountWithAmount: price];
    amLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:amLabel];
    
    
    //
    y += [AITools displaySizeFrom1080DesignSize:14] + imageHeight;
    [self addLineViewAtY:y];
    
    //
    y += [AITools displaySizeFrom1080DesignSize:37];
    CGFloat fontSize = [AITools displaySizeFrom1080DesignSize:42];
    CGRect evaluationRect = CGRectMake(_sideMargin, y, width, fontSize);
    UPLabel *evaluationLabel = [AIViews normalLabelWithFrame:evaluationRect text:[@"AIMusicTherapyView.service" localized] fontSize:fontSize color:[UIColor whiteColor]];
    evaluationLabel.font = [AITools myriadSemiCondensedWithSize:fontSize];
    [self addSubview:evaluationLabel];
    
    //
    CGFloat moreFontSize = [AITools displaySizeFrom1080DesignSize:31];
    NSString *moreString = [NSString stringWithFormat:[@"AIMusicTherapyView.moreReviews" localized], _detailModel.service_rating.reviews - 2];
    UPLabel *moreLabel = [AIViews normalLabelWithFrame:evaluationRect text:moreString fontSize:moreFontSize color:[AITools colorWithR:0x61 g:0xb0 b:0xfa]];
    moreLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:moreLabel];
    
    //
    y += fontSize + [AITools displaySizeFrom1080DesignSize:28];
    CGFloat starSize = [AITools displaySizeFrom1080DesignSize:39];
    
    CGRect starFrame = CGRectMake(_sideMargin, y, 100, starSize);
    AIStarRate *starRate = [[AIStarRate alloc] initWithFrame:starFrame rate:9];
    [self addSubview:starRate];
    
    //
    NSString *reviewStr = [NSString stringWithFormat:[@"AIMusicTherapyView.reviews" localized], _detailModel.service_rating.reviews];
    CGFloat reFontSize = [AITools displaySizeFrom1080DesignSize:42];
    CGFloat reviewX = CGRectGetMaxX(starRate.frame) + [AITools displaySizeFrom1080DesignSize:40];
    CGSize reviewSize = [reviewStr sizeWithFont:[AITools myriadSemiCondensedWithSize:reFontSize] forWidth:width];
    
    CGRect reviewFrame = CGRectMake(reviewX, y, reviewSize.width, reviewSize.height);
    UPLabel *reviewLabel = [AIViews normalLabelWithFrame:reviewFrame text:reviewStr fontSize:[AITools displaySizeFrom1080DesignSize:reFontSize] color:Color_LowWhite];
    reviewLabel.font = [AITools myriadSemiCondensedWithSize:reFontSize];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:reviewStr];
    
    NSRange range = NSMakeRange(4, reviewStr.length - 4);
    
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
    
    NSArray *models = _detailModel.service_rating.rating_level_list;
    AIProposalServiceDetailRatingItemModel *exmodel = models.firstObject;
    CGFloat percentage = (CGFloat)exmodel.number / (CGFloat)_detailModel.service_rating.reviews * 100;
    NSString *rateP = [NSString stringWithFormat:@"%.0f%@", percentage, @"%"];
    UPLabel *perLabel = [AIViews normalLabelWithFrame:CGRectMake(CGRectGetMaxX(zanFrame) + 5, y, width, [AITools displaySizeFrom1080DesignSize:42]) text:rateP fontSize:[AITools displaySizeFrom1080DesignSize:reFontSize] color:Color_LowWhite];
    perLabel.font = [AITools myriadSemiCondensedWithSize:reFontSize];
    [self addSubview:perLabel];
    
    //
    y += starSize + [AITools displaySizeFrom1080DesignSize:50];
    
    
    for (AIProposalServiceDetailRatingItemModel *model in models) {
        CGFloat height = [AITools displaySizeFrom1080DesignSize:34];
        CGRect frame = CGRectMake(_sideMargin, y, width, height);
        CGFloat rate = (CGFloat)model.number / (CGFloat)_detailModel.service_rating.reviews;
        AIHorizontalBarChart *chart = [[AIHorizontalBarChart alloc] initWithFrame:frame name:model.name number:model.number rate:rate];
        [self addSubview:chart];
        
        y += height + [AITools displaySizeFrom1080DesignSize:23];
    }
    
    //
    
    y += [AITools displaySizeFrom1080DesignSize:50] - [AITools displaySizeFrom1080DesignSize:23];
    
    
    //
    
    NSString *ctitle = [@"AIMusicTherapyView.helpful" localized];
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
    for (int i = 0; i < _detailModel.service_rating.comment_list.count; i++) {
        
        AIProposalServiceDetailRatingCommentModel *comment = [_detailModel.service_rating.comment_list objectAtIndex:i];

        CGRect frame = CGRectMake(_sideMargin, y, width, 0);
        
        AICommentCell *cell = [[AICommentCell alloc] initWithFrame:frame model:comment];
        [self addSubview:cell];
        
        y += CGRectGetHeight(cell.frame) + [AITools displaySizeFrom1080DesignSize:22];
        
        if (i == _detailModel.service_rating.comment_list.count - 1) {
            [self addLineViewAtY:y];
        } else
        {
            [self addLineViewAtX:_sideMargin y:y width:CGRectGetWidth(self.frame) - _sideMargin*2];
        }
        
        y +=  [AITools displaySizeFrom1080DesignSize:22];
  
    }
    
    
    y -= [AITools displaySizeFrom1080DesignSize:22] -0.5;
    // reset frame
    CGRect myFrame = self.frame;
    myFrame.size.height = y;
    self.frame = myFrame;
    
}

- (AIServiceTypes *) addServiceTypes: (CGRect) frame
{
    AIServiceTypes *serviceTypes;
    
    for (int i = 0; i < _detailModel.service_param_list.count; i++)
    {
        AIProposalServiceDetailParamModel *param = [_detailModel.service_param_list objectAtIndex:i];
        
        if (param.param_type == 2) {
            serviceTypes = [[AIServiceTypes alloc] initWithFrame:frame model:param];
            
        }
    }

    if (serviceTypes != nil) {
        serviceTypes.delegate = self;
        [self addSubview:serviceTypes];
    }
    
    return serviceTypes;
}


#pragma mark - AIBuyerParamsDelegate
- (NSArray *)getSelectedParams
{
    return @[_submitData];
    
}

#pragma mark - AIServiceCoverageDelegate
- (void)didChooseServiceLabelModel:(AIProposalServiceDetailParamValueModel *)labelModel
{
    
}

#pragma mark - AIServiceTypesDelegate
- (void)didSelectServiceTypeAtIndex:(NSInteger)index value:(AIProposalServiceDetailParamValueModel *) model
{
    AIProposalServiceParamRelationModel *m = [AIServiceDetailTool findParamRelated:_detailModel selectedParamValue:model];
    if (m) {
        _submitData = [AIServiceDetailTool createServiceSubmitModel:_detailModel relation:m];
        NSInteger i = index;
    }
    
}



@end

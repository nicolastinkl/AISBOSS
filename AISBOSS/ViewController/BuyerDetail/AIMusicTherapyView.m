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

@property (nonatomic, strong) NSArray *submitData;

@end

@implementation AIMusicTherapyView

- (id)initWithFrame:(CGRect)frame model:(AIProposalServiceDetailModel *)model shouldShowParams:(BOOL)should
{
    self = [super initWithFrame:frame model:model shouldShowParams:should];
    
    if (self) {
        [self makeSubViews];
    }
    
    return self;
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
    CGFloat viewHeight = 0;
    CGFloat y = [AITools displaySizeFrom1080DesignSize:32];
    
    viewHeight = [self addReviewView:y];
    
    y += viewHeight + [AITools displaySizeFrom1080DesignSize:50];
    
    NSArray *models = self.detailModel.service_rating.rating_level_list;
    
    for (AIProposalServiceDetailRatingItemModel *model in models) {
        viewHeight = [self addRatingBarView:y model:model];
        y += viewHeight + [AITools displaySizeFrom1080DesignSize:23];
    }
    
    
    y += [AITools displaySizeFrom1080DesignSize:50] - [AITools displaySizeFrom1080DesignSize:23];
    
    
    viewHeight = [self addCommentTitle:y];
    y += viewHeight;
    
    [self addLineViewAtY:y];
    
    y += 1 + [AITools displaySizeFrom1080DesignSize:22];
    //
    for (int i = 0; i < self.detailModel.service_rating.comment_list.count; i++) {
        
        AIProposalServiceDetailRatingCommentModel *comment = [self.detailModel.service_rating.comment_list objectAtIndex:i];
        
        viewHeight = [self addCommentItemView:y comment:comment];
        y += viewHeight + [AITools displaySizeFrom1080DesignSize:22];
        
        if (i == self.detailModel.service_rating.comment_list.count - 1) {
            [self addLineViewAtY:y];
        } else {
            [self addLineViewAtX:self.sideMargin y:y width:CGRectGetWidth(self.frame) - self.sideMargin*2];
        }
        
        y +=  [AITools displaySizeFrom1080DesignSize:22];
    }
    
    
    y -= [AITools displaySizeFrom1080DesignSize:22] - 0.5;
    
    
    // reset frame
    CGRect myFrame = self.frame;
    myFrame.size.height = y;
    self.frame = myFrame;
    
}

- (CGFloat) addServiceTypes: (CGFloat) positionY
{
    CGFloat viewHeight = 0;
    AIServiceTypes *serviceTypes;
    
    CGFloat width = [self contentViewWidth];
    CGRect frame = CGRectMake(self.sideMargin, positionY, width, 0);
    
    for (int i = 0; i < self.detailModel.service_param_list.count; i++)
    {
        AIProposalServiceDetailParamModel *param = [self.detailModel.service_param_list objectAtIndex:i];
        
        if (param.param_type == 2) {
            serviceTypes = [[AIServiceTypes alloc] initWithFrame:frame model:param];
            
        }
    }

    if (serviceTypes != nil) {
        serviceTypes.delegate = self;
        [self addSubview:serviceTypes];
        viewHeight = CGRectGetHeight(serviceTypes.frame);
    }
    
    return viewHeight;
}

- (CGFloat) addEvaluationTitleView: (CGFloat) positionY
{
    CGFloat width = [self contentViewWidth];
    CGFloat fontSize = [AITools displaySizeFrom1080DesignSize:42];
    CGRect evaluationRect = CGRectMake(self.sideMargin, positionY, width, fontSize);
    UPLabel *evaluationLabel = [AIViews normalLabelWithFrame:evaluationRect text:[@"AIMusicTherapyView.service" localized] fontSize:fontSize color:[UIColor whiteColor]];
    evaluationLabel.font = [AITools myriadSemiCondensedWithSize:fontSize];
    [self addSubview:evaluationLabel];
    
    //
    CGFloat moreFontSize = [AITools displaySizeFrom1080DesignSize:31];
    NSString *moreString = [NSString stringWithFormat:[@"AIMusicTherapyView.moreReviews" localized], self.detailModel.service_rating.reviews - 2];
    UPLabel *moreLabel = [AIViews normalLabelWithFrame:evaluationRect text:moreString fontSize:moreFontSize color:[AITools colorWithR:0x61 g:0xb0 b:0xfa]];
    moreLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:moreLabel];
    
    return fontSize;
}

- (CGFloat) addReviewView: (CGFloat) positionY
{
    CGFloat width = [self contentViewWidth];
    
    CGFloat starSize = [AITools displaySizeFrom1080DesignSize:39];
    
    CGRect starFrame = CGRectMake(self.sideMargin, positionY, 100, starSize);
    AIStarRate *starRate = [[AIStarRate alloc] initWithFrame:starFrame rate:9];
    [self addSubview:starRate];
    
    //
    NSString *reviewStr = [NSString stringWithFormat:[@"AIMusicTherapyView.reviews" localized], self.detailModel.service_rating.reviews];
    CGFloat reFontSize = [AITools displaySizeFrom1080DesignSize:42];
    CGFloat reviewX = CGRectGetMaxX(starRate.frame) + [AITools displaySizeFrom1080DesignSize:40];
    CGSize reviewSize = [reviewStr sizeWithFont:[AITools myriadSemiCondensedWithSize:reFontSize] forWidth:width];
    
    CGRect reviewFrame = CGRectMake(reviewX, positionY, reviewSize.width, reviewSize.height);
    UPLabel *reviewLabel = [AIViews normalLabelWithFrame:reviewFrame text:reviewStr fontSize:[AITools displaySizeFrom1080DesignSize:reFontSize] color:Color_LowWhite];
    reviewLabel.font = [AITools myriadSemiCondensedWithSize:reFontSize];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:reviewStr];
    
    NSRange range = NSMakeRange(4, reviewStr.length - 4);
    
    CGFloat fontSize = [AITools displaySizeFrom1080DesignSize:42];
    
    [attr addAttribute:NSFontAttributeName value:[AITools myriadLightSemiCondensedWithSize:fontSize] range:range];
    reviewLabel.attributedText = attr;
    
    
    
    [self addSubview:reviewLabel];
    
    //
    UIImage *zanImage = [UIImage imageNamed:@"Zan"];
    CGRect zanFrame = CGRectMake(CGRectGetMaxX(reviewLabel.frame)+[AITools displaySizeFrom1080DesignSize:31], positionY, [AITools displaySizeFrom1080DesignSize:42], [AITools displaySizeFrom1080DesignSize:42]);
    UIImageView *zanView = [[UIImageView alloc] initWithImage:zanImage];
    zanView.frame = zanFrame;
    
    [self addSubview:zanView];
    
    NSArray *models = self.detailModel.service_rating.rating_level_list;
    AIProposalServiceDetailRatingItemModel *exmodel = models.firstObject;
    CGFloat percentage = (CGFloat)exmodel.number / (CGFloat)self.detailModel.service_rating.reviews * 100;
    NSString *rateP = [NSString stringWithFormat:@"%.0f%@", percentage, @"%"];
    UPLabel *perLabel = [AIViews normalLabelWithFrame:CGRectMake(CGRectGetMaxX(zanFrame) + 5, positionY, width, [AITools displaySizeFrom1080DesignSize:42]) text:rateP fontSize:[AITools displaySizeFrom1080DesignSize:reFontSize] color:Color_LowWhite];
    perLabel.font = [AITools myriadSemiCondensedWithSize:reFontSize];
    [self addSubview:perLabel];
    
    return starSize;
}

- (CGFloat) addRatingBarView: (CGFloat) positionY model: (AIProposalServiceDetailRatingItemModel *) model
{
    CGFloat height = [AITools displaySizeFrom1080DesignSize:34];
    CGFloat width = [self contentViewWidth];
    
    CGRect frame = CGRectMake(self.sideMargin, positionY, width, height);
    CGFloat rate = (CGFloat)model.number / (CGFloat)self.detailModel.service_rating.reviews;
    AIHorizontalBarChart *chart = [[AIHorizontalBarChart alloc] initWithFrame:frame name:model.name number:model.number rate:rate];
    [self addSubview:chart];
    
    return height;
}

- (CGFloat) addCommentTitle: (CGFloat) positionY
{
    CGFloat fontSize = [AITools displaySizeFrom1080DesignSize:42];
    CGFloat width = [self contentViewWidth];
    
    NSString *ctitle = [@"AIMusicTherapyView.helpful" localized];
    UIFont *cfont = [AITools myriadSemiCondensedWithSize:fontSize];
    CGSize csize = [ctitle sizeWithFont:cfont forWidth:width];
    
    UIImage *cimage = [UIImage imageNamed:@"Comment_Title_BG"];
    cimage = [cimage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    UIImageView *cimageView = [[UIImageView alloc] initWithImage:cimage];
    CGFloat cimageViewHeight = [AITools displaySizeFrom1080DesignSize:73];
    cimageView.frame = CGRectMake(self.sideMargin, positionY, 30 + csize.width, cimageViewHeight);
    
    [self addSubview:cimageView];
    
    
    UPLabel *commentLabel = [AIViews normalLabelWithFrame:CGRectMake(0, 0, cimageView.frame.size.width, [AITools displaySizeFrom1080DesignSize:73]) text:ctitle fontSize:fontSize color:[UIColor whiteColor]];
    commentLabel.font = cfont;
    commentLabel.textAlignment = NSTextAlignmentCenter;
    [cimageView addSubview:commentLabel];
    

    return [AITools displaySizeFrom1080DesignSize:73];
}

- (CGFloat) addCommentItemView: (CGFloat) positionY comment: (AIProposalServiceDetailRatingCommentModel *) model
{
    CGFloat width = [self contentViewWidth];
    
    CGRect frame = CGRectMake(self.sideMargin, positionY, width, 0);
    
    AICommentCell *cell = [[AICommentCell alloc] initWithFrame:frame model:model];
    [self addSubview:cell];
    
    return CGRectGetHeight(cell.frame);
}


#pragma mark - AIBuyerParamsDelegate
- (NSArray *)getSelectedParams
{
    if (_submitData) {
        return _submitData;
    } else {
        return nil;
    }
    
}

#pragma mark - AIServiceCoverageDelegate
- (void)didChooseServiceLabelModel:(AIProposalServiceDetailParamValueModel *)labelModel
{
    
}

#pragma mark - AIServiceTypesDelegate
- (void)didSelectServiceTypeAtIndex:(NSInteger)index value:(AIProposalServiceDetailParamValueModel *) model parentModel:(AIProposalServiceDetailParamModel*) parentModel
{
    AIProposalServiceParamRelationModel *m = [AIServiceDetailTool findParamRelated:self.detailModel selectedParamValue:model];
    if (m) {
        JSONModel *product = [AIServiceDetailTool createServiceSubmitModel:self.detailModel productParam:model productModel:parentModel];
        JSONModel *param = [AIServiceDetailTool createServiceSubmitModel:self.detailModel relation:m];
        _submitData = @[product, param];
    }
    
}


@end

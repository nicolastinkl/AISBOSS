//
//  AIBubblesView.h
//  AIVeris
//
//  Created by 王坜 on 15/10/21.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIBubble.h"

@class AIBuyerBubbleModel;

@interface AIBubblesView : UIView

typedef void (^BubbleBlock)(AIBuyerBubbleModel *model,AIBubble *bubble);

- (id) initWithFrame:(CGRect)frame models:(NSMutableArray *)models;

- (void) addGestureBubbleAction:(BubbleBlock) block;

@end

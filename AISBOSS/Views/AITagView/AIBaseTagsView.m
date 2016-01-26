//
//  AIBaseTagsView.m
//  AIBaseTagsView
//
//  Created by Adnan Nasir on 27/08/2015.
//  Copyright (c) 2015 Adnan Nasir. All rights reserved.
//

#import "AIBaseTagsView.h"

#define TAG_SPACE_HORIZONTAL      10
#define TAG_SPACE_VERTICAL        10
#define DEFAULT_VIEW_HEIGHT       44
#define MAX_TAG_SIZE              300
#define MIN_TAG_SIZE              40
#define DEFAULT_VIEW_WIDTH        320
#define DEFAULT_TAG_CORNER_RADIUS 10
@implementation AIBaseTagsView

- (instancetype)initWithTags:(NSArray *)tagsArray {
    self = [super init];

    if (self) {
        viewWidth = DEFAULT_VIEW_WIDTH;
        tagsToDisplay = tagsArray;
        maxTagSize = DEFAULT_VIEW_WIDTH - TAG_SPACE_HORIZONTAL;
        tagRadius = DEFAULT_TAG_CORNER_RADIUS;
        tagTextColor = [UIColor blueColor];
        _tagNormalColor = [UIColor grayColor];
        _tagSelectedColor = [UIColor redColor];
        [self renderTagsOnView];
    }

    return self;
}

- (instancetype)initWithTags:(NSArray *)tagsArray frame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        viewWidth = frame.size.width;
        tagsToDisplay = tagsArray;
        maxTagSize = DEFAULT_VIEW_WIDTH - TAG_SPACE_HORIZONTAL;
        tagRadius = DEFAULT_TAG_CORNER_RADIUS;
        tagTextColor = [UIColor whiteColor];
        _tagNormalColor = [UIColor grayColor];
        _tagSelectedColor = [UIColor redColor];
        _tagViews = @[].mutableCopy;
        [self renderTagsOnView];
    }

    return self;
}

- (void)renderTagsOnView {
    [self removeAllTags];
    [self.tagViews removeAllObjects];

    tagXPos = TAG_SPACE_HORIZONTAL;
    tagYPos = TAG_SPACE_VERTICAL;
    viewHeight = DEFAULT_VIEW_HEIGHT;

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, viewWidth, viewHeight);

    for (NSString *tag in tagsToDisplay) {
        [self addTagInView:tag index:[tagsToDisplay indexOfObject:tag]];
    }

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + 10, viewWidth, viewHeight);
}

- (void)setTagNormalColor:(UIColor *)tagNormalColor {
    _tagNormalColor = tagNormalColor;

    for (UILabel *label in self.tagViews) {
        label.backgroundColor = label.isHighlighted ? self.tagSelectedColor : _tagNormalColor;
    }
}

- (void)setTagSelectedColor:(UIColor *)tagSelectedColor {
    _tagSelectedColor = tagSelectedColor;

    for (UILabel *label in self.tagViews) {
        label.backgroundColor = label.isHighlighted ? _tagSelectedColor : self.tagNormalColor;
    }
}

- (void)removeAllTags {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)setFrameWidth:(int)width;
{
    viewWidth = width;
    maxTagSize = viewWidth - TAG_SPACE_HORIZONTAL;
    [self renderTagsOnView];
}

- (void)setTagTextColor:(UIColor *)color {
    tagTextColor = color;

    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *tag = (UILabel *)view;
            tag.textColor = tagTextColor;
        }
    }
}

- (void)setTagCornerRadius:(int)radius {
    tagRadius = radius;

    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *tag = (UILabel *)view;
            tag.layer.masksToBounds = YES;
            tag.layer.cornerRadius = tagRadius;
        }
    }
}

- (AITagLabel *)addTagInView:(NSString *)tag index:(NSInteger)index {
    AITagLabel *tagLabel = [[AITagLabel alloc]init];

    tagLabel.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelDidTapped:)];
    [tagLabel addGestureRecognizer:tap];
    tagLabel.tag = index;
    UIFont *tagFont = [UIFont fontWithName:@"Arial" size:26];
    CGSize maximumLabelSize = CGSizeMake(maxTagSize, CGRectGetWidth(self.bounds));
    
    CGSize expectedLabelSize = [tag sizeWithFont:tagFont
                               constrainedToSize:maximumLabelSize
                                   lineBreakMode:[tagLabel lineBreakMode]];

    if (expectedLabelSize.width < MIN_TAG_SIZE) expectedLabelSize.width = MIN_TAG_SIZE;

    NSLog(@"%f", expectedLabelSize.width);

    if ((tagXPos + expectedLabelSize.width) > self.frame.size.width) {
        tagXPos = TAG_SPACE_HORIZONTAL;
        tagYPos += expectedLabelSize.height + TAG_SPACE_VERTICAL;
        viewHeight += expectedLabelSize.height + TAG_SPACE_HORIZONTAL;
    }

    tagLabel.frame = CGRectMake(tagXPos, tagYPos, expectedLabelSize.width, expectedLabelSize.height);
    tagLabel.text = tag;
    tagLabel.textAlignment = NSTextAlignmentCenter;
    tagLabel.backgroundColor = self.tagNormalColor;
    tagLabel.highlightedBackgroundColor = self.tagSelectedColor;
    tagLabel.textColor = tagTextColor;
    tagLabel.layer.masksToBounds = YES;
    tagLabel.layer.cornerRadius = tagRadius;
    [self addSubview:tagLabel];
    [self.tagViews addObject:tagLabel];
    tagXPos += tagLabel.frame.size.width + TAG_SPACE_HORIZONTAL;
    return tagLabel;
}

- (void)labelDidTapped:(UITapGestureRecognizer *)tapG {
    UILabel *label = (UILabel *)tapG.view;
    self.selectedIndex = label.tag;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end

//
//  PKYStepper.m
//  PKYStepper
//
//  Created by Okada Yohei on 1/11/15.
//  Copyright (c) 2015 yohei okada. All rights reserved.
//

// action control: UIControlEventApplicationReserved for increment/decrement?
// delegate: if there are multiple PKYSteppers in one viewcontroller, it will be a hassle to identify each PKYSteppers
// block: watch out for retain cycle

// check visibility of buttons when
// 1. right before displaying for the first time
// 2. value changed

#import "PKYStepper.h"

static const float kButtonWidth = 44.0f;

@interface PKYStepper ()
{
    BOOL _isIncrementBtnInLongTouch;
    BOOL _isDecrementBtnInLongTouch;

    UIVisualEffectView *_effectview;
    UITextView *_inputText;
}

@end


@implementation PKYStepper

#pragma mark initialization
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit {
    _isIncrementBtnInLongTouch = NO;
    _isDecrementBtnInLongTouch = NO;

    _value = 0.0f;
    _stepInterval = 1.0f;
    _minimum = 0.0f;
    _maximum = 100.0f;
    _hidesDecrementWhenMinimum = NO;
    _hidesIncrementWhenMaximum = NO;
    _buttonWidth = kButtonWidth;

    self.clipsToBounds = YES;
    [self setBorderWidth:1.0f];
    [self setCornerRadius:4.0];

    self.countLabel = [[UILabel alloc] init];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.layer.borderWidth = 1.0f;
    self.countLabel.userInteractionEnabled = TRUE;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [self.countLabel addGestureRecognizer:labelTapGestureRecognizer];
    [self addSubview:self.countLabel];

    self.incrementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.incrementButton setTitle:@"+" forState:UIControlStateNormal];
    [self.incrementButton addTarget:self action:@selector(incrementButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *incrementLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(incrementBtnLongTapped:)];
    incrementLongPress.minimumPressDuration = 0.8; //定义按的时间
    [self.incrementButton addGestureRecognizer:incrementLongPress];
    [self addSubview:self.incrementButton];

    self.decrementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.decrementButton setTitle:@"-" forState:UIControlStateNormal];
    [self.decrementButton addTarget:self action:@selector(decrementButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *decrementLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(decrementBtnLongTapped:)];
    decrementLongPress.minimumPressDuration = 0.8; //定义按的时间
    [self.decrementButton addGestureRecognizer:decrementLongPress];
    [self addSubview:self.decrementButton];

    UIColor *defaultColor = [UIColor colorWithRed:(79 / 255.0) green:(161 / 255.0) blue:(210 / 255.0) alpha:1.0];
    [self setBorderColor:defaultColor];
    [self setLabelTextColor:defaultColor];
    [self setButtonTextColor:defaultColor forState:UIControlStateNormal];

    [self setLabelFont:[UIFont fontWithName:@"Avernir-Roman" size:14.0f]];
    [self setButtonFont:[UIFont fontWithName:@"Avenir-Black" size:24.0f]];
}

#pragma mark render
- (void)layoutSubviews {
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;

    self.countLabel.frame = CGRectMake(self.buttonWidth, 0, width - (self.buttonWidth * 2), height);
    self.incrementButton.frame = CGRectMake(width - self.buttonWidth, 0, self.buttonWidth, height);
    self.decrementButton.frame = CGRectMake(0, 0, self.buttonWidth, height);

    self.incrementButton.hidden = (self.hidesIncrementWhenMaximum && [self isMaximum]);
    self.decrementButton.hidden = (self.hidesDecrementWhenMinimum && [self isMinimum]);
}

- (void)setup {
    if (self.valueChangedCallback) {
        self.valueChangedCallback(self, self.value);
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        // if CGSizeZero, return ideal size
        CGSize labelSize = [self.countLabel sizeThatFits:size];
        return CGSizeMake(labelSize.width + (self.buttonWidth * 2), labelSize.height);
    }

    return size;
}

#pragma mark view customization
- (void)setBorderColor:(UIColor *)color {
    self.layer.borderColor = color.CGColor;
    self.countLabel.layer.borderColor = color.CGColor;
}

- (void)setBorderWidth:(CGFloat)width {
    self.layer.borderWidth = width;
}

- (void)setCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
}

- (void)setLabelTextColor:(UIColor *)color {
    self.countLabel.textColor = color;
}

- (void)setLabelFont:(UIFont *)font {
    self.countLabel.font = font;
}

- (void)setButtonTextColor:(UIColor *)color forState:(UIControlState)state {
    [self.incrementButton setTitleColor:color forState:state];
    [self.decrementButton setTitleColor:color forState:state];
}

- (void)setButtonFont:(UIFont *)font {
    self.incrementButton.titleLabel.font = font;
    self.decrementButton.titleLabel.font = font;
}

#pragma mark setter
- (void)setValue:(float)value {
    _value = value;

    if (self.hidesDecrementWhenMinimum) {
        self.decrementButton.hidden = [self isMinimum];
    }

    if (self.hidesIncrementWhenMaximum) {
        self.incrementButton.hidden = [self isMaximum];
    }

    if (self.valueChangedCallback) {
        self.valueChangedCallback(self, _value);
    }
}

#pragma mark event handler
- (void)incrementButtonTapped:(id)sender {
    if (self.value < self.maximum) {
        self.value += self.stepInterval;

        if (self.incrementCallback) {
            self.incrementCallback(self, self.value);
        }
    }
}

- (void)decrementButtonTapped:(id)sender {
    if (self.value > self.minimum) {
        self.value -= self.stepInterval;

        if (self.decrementCallback) {
            self.decrementCallback(self, self.value);
        }
    }
}

- (void)incrementBtnLongTapped:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _isIncrementBtnInLongTouch = YES;

        [self incrementBtnLongTappedHandle];
    } else {
        _isIncrementBtnInLongTouch = NO;
    }
}

- (void)incrementBtnLongTappedHandle {
    if (self.value < self.maximum) {
        self.value += self.stepInterval;

        if (self.incrementCallback) {
            self.incrementCallback(self, self.value);
        }
    }

    if (_isIncrementBtnInLongTouch) {
        double delayInSeconds = 0.08;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)); // 1
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [self incrementBtnLongTappedHandle];
        });
    }
}

- (void)decrementBtnLongTapped:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _isDecrementBtnInLongTouch = YES;

        [self decrementBtnLongTappedHandle];
    } else {
        _isDecrementBtnInLongTouch = NO;
    }
}

- (void)decrementBtnLongTappedHandle {
    if (self.value > self.minimum) {
        self.value -= self.stepInterval;

        if (self.decrementCallback) {
            self.decrementCallback(self, self.value);
        }
    }

    if (_isDecrementBtnInLongTouch) {
        double delayInSeconds = 0.08;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)); // 1
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [self decrementBtnLongTappedHandle];
        });
    }
}

#pragma mark private helpers
- (BOOL)isMinimum {
    return self.value == self.minimum;
}

- (BOOL)isMaximum {
    return self.value == self.maximum;
}

- (void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer {
    [self addInputView];
}

- (void)addInputView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    if (_effectview == NULL) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

        _effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        _effectview.userInteractionEnabled = YES;

        UITapGestureRecognizer *inputTextTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inputTextUpInside:)];
        [_effectview addGestureRecognizer:inputTextTapGestureRecognizer];

        _effectview.frame = window.bounds;

        CGFloat textWidth = window.bounds.size.width / 2;
        CGFloat textHeight = 30;
        CGFloat x = (window.bounds.size.width - textWidth) / 2;
        CGFloat y = (window.bounds.size.height - textHeight) / 2;

        _inputText = [[UITextView alloc] initWithFrame:CGRectMake(x, y, textWidth, textHeight)];
        _inputText.keyboardType = UIKeyboardTypeNumberPad;

        [_effectview addSubview:_inputText];
    }

    _inputText.text = [NSString stringWithFormat:@"%@", @(_value)];

    if (_value == 0) {
        _inputText.text = @"";
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"kStepperIsEditing" object:@(1)];
    [_inputText becomeFirstResponder];
    [window addSubview:_effectview];
}

- (void)inputTextUpInside:(UITapGestureRecognizer *)recognizer {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kStepperIsEditing" object:@(0)];

    [_effectview removeFromSuperview];
    [_inputText resignFirstResponder];
    float inputValue = [_inputText.text floatValue];

    if (inputValue > _maximum) {
        inputValue = _maximum;
    } else if (inputValue < _minimum) {
        inputValue = _minimum;
    }

    _value = inputValue;

    self.countLabel.text = [NSString stringWithFormat:@"%@", @(_value)];
}

@end

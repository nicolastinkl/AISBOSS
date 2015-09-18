//
//  UILabel+FlickerNumber.m
//  FlickerNumber
//
//  Created by Diaoshu on 15-2-1.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "UILabel+FlickerNumber.h"
#import <objc/runtime.h>
// 每次变化的数量
#define OnceChangedNumberKey @"RangeKey"
#define MultipleKey @"MultipleKey"
#define BeginNumberKey @"BeginNumberKey"
#define EndNumberKey @"EndNumberKey"
#define ResultNumberKey @"ResultNumberKey"

#define AttributeKey @"AttributeKey"
#define FormatKey @"FormatStringKey"

#define Interval 1.0/10.0f

#define DictArrtributeKey @"attribute"
#define DictRangeKey @"range"


@interface UILabel ()

@property (nonatomic, strong) NSNumber *flickerNumber;
@property (nonatomic, strong) NSNumber *oldNumber;
@property (nonatomic, strong) NSNumberFormatter *flickerNumberFormatter;
@property (nonatomic, strong) NSTimer *currentTimer;

@end

static char oldNumberKey;
static char flickerNumberKey;
static char flickerNumberFormatterKey;
static char flikcerNumberCurrentTimer;

@implementation UILabel (FlickerNumber)

#pragma mark - runtime methods


- (void)setOldNumber:(NSNumber *)oldNumber{
    objc_setAssociatedObject(self, &oldNumberKey, oldNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)oldNumber{
    return objc_getAssociatedObject(self, &oldNumberKey);
}

- (void)setFlickerNumber:(NSNumber *)flickerNumber{
    objc_setAssociatedObject(self, &flickerNumberKey, flickerNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)flickerNumber{
    return objc_getAssociatedObject(self, &flickerNumberKey);
}

- (void)setFlickerNumberFormatter:(NSNumberFormatter *)flickerNumberFormatter{
    objc_setAssociatedObject(self, &flickerNumberFormatterKey, flickerNumberFormatter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumberFormatter *)flickerNumberFormatter{
    return objc_getAssociatedObject(self, &flickerNumberFormatterKey);
}

- (void)setCurrentTimer:(NSTimer *)currentTimer{
    objc_setAssociatedObject(self, &flikcerNumberCurrentTimer, currentTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *)currentTimer{
    return objc_getAssociatedObject(self, &flikcerNumberCurrentTimer);
}

#pragma mark - flicker methods(public)

- (void)setNumber:(NSNumber *)number{
    [self setNumber:number duration:1.0 format:nil attributes:nil];
}

- (void)setNumber:(NSNumber *)number formatter:(NSNumberFormatter *)formatter{
    if(!formatter)
        formatter = [self defaultFormatter];
    [self setNumber:number duration:1.0 format:nil numberFormatter:formatter attributes:nil];
}

- (void)setNumber:(NSNumber *)number format:(NSString *)formatStr{
    [self setNumber:number duration:1.0 format:formatStr attributes:nil];
}

- (void)setNumber:(NSNumber *)number format:(NSString *)formatStr formatter:(NSNumberFormatter *)formatter{
    if(!formatter)
        formatter = [self defaultFormatter];
    [self setNumber:number duration:1.0 format:formatStr numberFormatter:formatter attributes:nil];
}

- (void)setNumber:(NSNumber *)number attributes:(id)attrs{
    [self setNumber:number duration:1.0 format:nil attributes:attrs];
}


- (void)setNumber:(NSNumber *)number formatter:(NSNumberFormatter *)formatter attributes:(id)attrs{
    if(!formatter)
        formatter = [self defaultFormatter];
    [self setNumber:number duration:1.0 format:nil numberFormatter:formatter attributes:attrs];
}

- (void)setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(NSString *)formatStr{
    [self setNumber:number duration:duration format:formatStr attributes:nil];
}

- (void)setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(NSString *)formatStr numberFormatter:(NSNumberFormatter *)formatter{
    if(!formatter)
        formatter = [self defaultFormatter];
    [self setNumber:number duration:duration format:formatStr numberFormatter:formatter attributes:nil];
}

- (void)setNumber:(NSNumber *)number duration:(NSTimeInterval)duration{
    [self setNumber:number duration:duration format:nil attributes:nil];
}

- (void)setNumber:(NSNumber *)number duration:(NSTimeInterval)duration formatter:(NSNumberFormatter *)formatter{
    if(!formatter)
        formatter = [self defaultFormatter];
    [self setNumber:number duration:duration format:nil numberFormatter:formatter attributes:nil];
}

- (void)setNumber:(NSNumber *)number duration:(NSTimeInterval)duration attributes:(id)attrs{
    [self setNumber:number duration:duration format:nil attributes:attrs];
}

- (void)setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(NSString *)formatStr formatter:(NSNumberFormatter *)formatter{
    if(!formatter)
        formatter = [self defaultFormatter];
    [self setNumber:number duration:duration format:formatStr formatter:formatter];
}

- (void)setNumber:(NSNumber *)number duration:(NSTimeInterval)duration formatter:(NSNumberFormatter *)formatter attributes:(id)attrs{
    if(!formatter)
        formatter = [self defaultFormatter];
    [self setNumber:number duration:duration format:nil numberFormatter:formatter attributes:attrs];
}

- (void)setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(NSString *)formatStr attributes:(id)attrs{
    [self setNumber:number duration:duration format:formatStr numberFormatter:nil attributes:attrs];
}

- (void)setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(NSString *)formatStr numberFormatter:(NSNumberFormatter *)formatter attributes:(id)attrs {
    
    if (self.oldNumber == nil) {
        self.oldNumber = [NSNumber numberWithInt:0];
  //      [self setOldNumber:@(0)];
    }
    
    [self changeNumberFrom:self.oldNumber toNumber:number duration:duration format:formatStr numberFormatter:formatter attributes:attrs];
    }

- (void)changeNumberFrom:(NSNumber *) fromNumber toNumber:(NSNumber *)toNumber  duration:(NSTimeInterval)duration format:(NSString *)formatStr numberFormatter:(NSNumberFormatter *)formatter attributes:(id)attrs {
    /**
     *  check the number type
     */
    NSAssert([fromNumber isKindOfClass:[NSNumber class]], @"Number Type is not matched , exit");
    NSAssert([toNumber isKindOfClass:[NSNumber class]], @"Number Type is not matched , exit");
    
    self.oldNumber = toNumber;
    
    [self.currentTimer invalidate];
    self.currentTimer = nil;
    
    //initialize useinfo dict
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if(formatStr)
        [userInfo setObject:formatStr forKey:FormatKey];
    
    [userInfo setObject:toNumber forKey:ResultNumberKey];
    
    //initialize variables
    [userInfo setObject:fromNumber forKey:BeginNumberKey];
    
    int endIntNum = 0;
    
    //get multiple if number is float & double type
    int multiple = [self multipleForNumber:toNumber formatString:formatStr];
    endIntNum = multiple > 0 ? [toNumber floatValue] * multiple : [toNumber intValue];
    int beginIntNum = multiple > 0 ? [fromNumber floatValue] * multiple : [fromNumber intValue];
    self.flickerNumber = [NSNumber numberWithInt:beginIntNum];
    [userInfo setObject:@(multiple) forKey:MultipleKey];
    [userInfo setObject:@(endIntNum) forKey:EndNumberKey];
    
    CGFloat everyTimeChangedNumber = [self everyTimeChangedNumber:(endIntNum - beginIntNum) interval:Interval duration:duration];
    
    if (fabs(everyTimeChangedNumber) < 1) {
        duration = duration * 0.3;
    }
    
    CGFloat changeNumber = [self everyTimeChangedNumber:(endIntNum - beginIntNum) interval:Interval duration:duration];
    
    [userInfo setObject:@(changeNumber) forKey:OnceChangedNumberKey];
    
    if(attrs)
        [userInfo setObject:attrs forKey:AttributeKey];
    
    self.flickerNumberFormatter = nil;
    if(formatter)
        self.flickerNumberFormatter = formatter;
    
    self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:Interval target:self selector:@selector(flickerAnimation:) userInfo:userInfo repeats:YES];
}



#pragma mark - private methods
/**
 * 计算出每次变化的数字
 *
 */
- (CGFloat) everyTimeChangedNumber: (int) numberRange interval:(float)interval duration:(float)duration {
    return (numberRange * interval)/duration;
}
/**
 *  flicker number animation
 *
 *  @param timer schedule timer
 */
- (void)flickerAnimation:(NSTimer *)timer{
    float everyTimeChangedNumber = [timer.userInfo[OnceChangedNumberKey] floatValue];
   
    self.flickerNumber = @([self.flickerNumber floatValue] + everyTimeChangedNumber);
    
    int multiple = [timer.userInfo[MultipleKey] intValue];
 
    NSString *formatStr;
    
    if (multiple == 0) { // handle number is int
        formatStr = timer.userInfo[FormatKey]?:(self.flickerNumberFormatter?@"%@":@"%.0f");
        
        self.text = [self finalString:@([self.flickerNumber integerValue]) stringFormat:formatStr andFormatter:self.flickerNumberFormatter];
    } else {
        formatStr = timer.userInfo[FormatKey]?:(self.flickerNumberFormatter?@"%@":[NSString stringWithFormat:@"%%.%df",(int)log10(multiple)]);
        
        self.text = [self finalString:@([self.flickerNumber floatValue]/multiple) stringFormat:formatStr andFormatter:self.flickerNumberFormatter];
    }
    
    if(timer.userInfo[AttributeKey]){
        [self attributedHandler:timer.userInfo[AttributeKey]];
    }
    
    int currentNumber = [self.flickerNumber intValue];
    int endNumber = [timer.userInfo[EndNumberKey] intValue];
    
    BOOL changeNumberIsDone = NO;
    
    if (everyTimeChangedNumber > 0) {
        if(currentNumber >= endNumber){
            changeNumberIsDone = TRUE;
        }
    } else {
        if(currentNumber <= endNumber){
            changeNumberIsDone = TRUE;   
        }
    }
    
    if (changeNumberIsDone) {
        self.text = [self finalString:timer.userInfo[ResultNumberKey] stringFormat:formatStr andFormatter:self.flickerNumberFormatter];
        if(timer.userInfo[AttributeKey]){
            [self attributedHandler:timer.userInfo[AttributeKey]];
        }
        [timer invalidate];
    }
}

/**
 *  attributes string handle methods
 *
 *  @param attributes attributes variable
 */
- (void)attributedHandler:(id)attributes{
    if([attributes isKindOfClass:[NSDictionary class]]){
        NSRange range = [attributes[DictRangeKey] rangeValue];
        [self addAttributes:attributes[DictArrtributeKey] range:range];
    }else if([attributes isKindOfClass:[NSArray class]]){
        for (NSDictionary *attribute in attributes) {
            NSRange range = [attribute[DictRangeKey] rangeValue];
            [self addAttributes:attribute[DictArrtributeKey] range:range];
        }
    }
}

/**
 *  attributes string result methods
 *
 *  @param attri attribute
 *  @param range range
 */
- (void)addAttributes:(NSDictionary *)attri range:(NSRange)range{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    // handler the out range exception
    if(range.location+range.length <= str.length){
        [str addAttributes:attri range:range];
    }
    self.attributedText = str;
}

/**
 *  get muliple from number
 *
 *  @param number past number
 *
 *  @return mulitple
 */
- (int)multipleForNumber:(NSNumber *)number formatString:(NSString *)formatStr{
    if([formatStr rangeOfString:@"%@"].location == NSNotFound){
        formatStr = [self regexNumberFormat:formatStr];
        NSString *formatNumberString = [NSString stringWithFormat:formatStr,[number floatValue]];
        if([formatNumberString rangeOfString:@"."].location != NSNotFound){
            NSUInteger length = [[formatNumberString substringFromIndex:[formatNumberString rangeOfString:@"."].location +1] length];
            float padding = log10f(length<6? length:6);
            number = @([formatNumberString floatValue] + padding);
        }
    }
    
    NSString *str = [NSString stringWithFormat:@"%@",number];
    if([str rangeOfString:@"."].location != NSNotFound){
        NSUInteger length = [[str substringFromIndex:[str rangeOfString:@"."].location +1] length];
        // Max Multiple is 6
        return  length >= 6 ? pow(10, 6): pow(10, (int)length);
    }
    return 0;
}

- (NSString *)stringFromNumber:(NSNumber *)number numberFormatter:(NSNumberFormatter *)formattor{
    if(!formattor){
        formattor = [[NSNumberFormatter alloc] init];
        formattor.formatterBehavior = NSNumberFormatterBehavior10_4;
        formattor.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return [formattor stringFromNumber:number];
}

- (NSString *)finalString:(NSNumber *)number stringFormat:(NSString *)formatStr andFormatter:(NSNumberFormatter *)formatter{
    NSString *finalString = nil;
    if(formatter){
        finalString = [NSString stringWithFormat:formatStr,[self stringFromNumber:number numberFormatter:formatter]];
    }else{
        NSAssert([formatStr rangeOfString:@"%@"].location == NSNotFound, @"string format type is not matched,please check your format type");
        finalString = [NSString stringWithFormat:formatStr,[number floatValue]];
    }
    return finalString;
}

- (NSNumberFormatter *)defaultFormatter{
    NSNumberFormatter *formattor = [[NSNumberFormatter alloc] init];
    formattor.formatterBehavior = NSNumberFormatterBehavior10_4;
    formattor.numberStyle = NSNumberFormatterDecimalStyle;
    return formattor;
}

- (NSString *)regexNumberFormat:(NSString *)formatString{
    NSError *regexError = nil;
    NSRegularExpression *regex =
    [NSRegularExpression regularExpressionWithPattern:@"^%((\\d+.\\d+)|(\\d+).|(.\\d+))f$"
                                              options:NSRegularExpressionCaseInsensitive
                                                error:&regexError];
    if (!regexError) {
        NSTextCheckingResult *match = [regex firstMatchInString:formatString
                                                        options:0
                                                          range:NSMakeRange(0, [formatString length])];
        if (match) {
            NSString *result = [formatString substringWithRange:match.range];
            return result;
        }
    } else {
        NSLog(@"error - %@", regexError);
    }
    return @"%f";
}

- (NSNumber *) convertTo: (NSString *) numberString {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    return [f numberFromString: numberString];
}

//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
}

@end

@implementation NSDictionary(FlickerNumber)

+ (instancetype)dictionaryWithAttribute:(NSDictionary *)attribute andRange:(NSRange)range{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:attribute forKey:DictArrtributeKey];
    [dict setObject:[NSValue valueWithRange:range] forKey:DictRangeKey];
    return dict;
}

@end

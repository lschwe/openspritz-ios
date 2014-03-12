//
//  OSSpritzLabel.m
//  OpenSpritzDemo
//
//  Created by Francesco Mattia on 08/03/14.
//  Copyright (c) 2014 Fr4ncis. All rights reserved.
//

#import "OSSpritzLabel.h"
#import "OSSpritz.h"

#define kInterspace 2.0f
#define maxWordLength 18
#define pivotChar 9

@implementation OSSpritzLabel {
    UIFont *font;
    NSArray *labelViews;
    NSArray *spritzedText;
    int currentWord;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    font = [UIFont fontWithName:@"CourierNewPSMT" size:20.0f];
    float charWidth = [@"m" sizeWithAttributes:@{NSFontAttributeName:font}].width;
    for (int i = 0; i < 18; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*(charWidth+kInterspace), 0, charWidth, self.frame.size.height)];
        
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        if (i==pivotChar) label.textColor = [UIColor redColor];
        label.alpha = 0;
        label.text = @"m";
        [self addSubview:label];
    }
    self.wordsPerMinute = 250;
    labelViews = [self.subviews copy];
    currentWord = 0;
    [self drawGuideLines];
}

- (void)drawGuideLines
{
    {
        float guideX = ((UIView*)labelViews[pivotChar]).center.x;
        float guideHeight = 9;
        //// Abstracted Attributes
        UIBezierPath* upperLinePath = [UIBezierPath bezierPathWithRect:CGRectMake(0,  0, self.frame.size.width, 1)];
        UIBezierPath* upperGuidePath = [UIBezierPath bezierPathWithRect:CGRectMake(guideX, 0, 1, guideHeight)];
        UIBezierPath* downLinePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
        UIBezierPath* downGuidePath = [UIBezierPath bezierPathWithRect:CGRectMake(guideX, self.frame.size.height-1-guideHeight, 1, guideHeight)];
        
        NSArray *paths = @[upperLinePath, upperGuidePath, downGuidePath, downLinePath];

        
        for (UIBezierPath *path in paths)
        {
            CAShapeLayer *line = [CAShapeLayer layer];
            line.path=path.CGPath;
            line.fillColor = [UIColor blackColor].CGColor;
            line.opacity = 1.0;
            line.strokeColor = nil;
            [self.layer addSublayer:line];
        }
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    spritzedText = [OSSpritz spritzString:text];
}

- (void)start
{
    if (currentWord >= [spritzedText count]) {
        currentWord = 0;
        return;
    }
    [self placeInLabels:spritzedText[currentWord]];
    float timeMod = [OSSpritz timeForWord:spritzedText[currentWord]];
    currentWord++;
    NSTimeInterval interval = 60.0 / (float)self.wordsPerMinute * timeMod;
    [self performSelector:@selector(start) withObject:nil afterDelay:interval];
}

- (void)placeInLabels:(NSString*)word
{
    int offset = [OSSpritz offsetForWord:word];
    for (int i = 0; i < [labelViews count]; i++)
    {
        UILabel *label = ((UILabel*)labelViews[i]);
        if (i < offset)
        {
        label.alpha = 0;
        }
        else if (i >= offset && i < word.length + offset)
        {
            label.alpha = 1;
            label.text = [word substringWithRange:(NSRange){i-offset,1}];
        }
        else
        {
            label.alpha = 0;
        }
    }
}

- (void)pause
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}



@end

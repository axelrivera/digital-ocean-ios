//
//  LoginInputView.m
//  DigitalOcean
//
//  Created by Axel Rivera on 9/9/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DoubleInputView.h"

#import <UIView+AutoLayout.h>

@implementation DoubleInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        _borderColor = [UIColor blackColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGSize contentSize = rect.size;
    
    // Draw Outer Rectangle
    [self.borderColor setFill];
    UIRectFill(rect);

    [self.backgroundColor setFill];

    CGRect topRect = CGRectMake(1.0,
                                1.0,
                                contentSize.width - 2.0,
                                kDoubleInputCellHeight);

    CGRect topIntersection = CGRectIntersection(topRect, rect);

    UIRectFill(topIntersection);

    CGRect bottomRect = CGRectMake(1.0,
                                   1.0 + kDoubleInputCellHeight + 1.0,
                                   contentSize.width - 2.0,
                                   kDoubleInputCellHeight);

    CGRect bottomIntersection = CGRectIntersection(bottomRect, rect);

    UIRectFill(bottomIntersection);
}

- (void)setBorderColor:(UIColor *)borderColor
{
    if (borderColor == nil) {
        borderColor = [UIColor blackColor];
    }

    _borderColor = borderColor;
    [self setNeedsDisplay];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (backgroundColor == nil) {
        backgroundColor = [UIColor whiteColor];
    }

    [super setBackgroundColor:backgroundColor];
}

- (void)setTopTextField:(UITextField *)topTextField
{
    if (_topTextField) {
        [_topTextField removeFromSuperview];
        _topTextField = nil;
    }
    
    _topTextField = topTextField;
    _topTextField.translatesAutoresizingMaskIntoConstraints = NO;
    //_topTextField.backgroundColor = [UIColor clearColor];
    [self addSubview:_topTextField];
    
    [_topTextField autoSetDimension:ALDimensionHeight toSize:kDoubleInputCellHeight];
    [_topTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:1.0];
    [_topTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];
    [_topTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0];
    
    [self setNeedsDisplay];
}

- (void)setBottomTextField:(UITextField *)bottomTextField
{
    if (_bottomTextField) {
        [_bottomTextField removeFromSuperview];
        _bottomTextField = nil;
    }
    
    _bottomTextField = bottomTextField;
    _bottomTextField.translatesAutoresizingMaskIntoConstraints = NO;
    //_bottomTextField.backgroundColor = [UIColor clearColor];
    [self addSubview:_bottomTextField];
    
    [_bottomTextField autoSetDimension:ALDimensionHeight toSize:kDoubleInputCellHeight];
    [_bottomTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];
    [_bottomTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0];
    [_bottomTextField autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:1.0];
    
    [self setNeedsDisplay];
}

@end

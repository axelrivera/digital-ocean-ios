//
//  LoginInputView.h
//  DigitalOcean
//
//  Created by Axel Rivera on 9/9/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDoubleInputViewHeight 87.0
#define kDoubleInputCellHeight 42.0

@interface DoubleInputView : UIView

@property (strong, nonatomic) UITextField *topTextField;
@property (strong, nonatomic) UITextField *bottomTextField;

@property (strong, nonatomic) UIColor *borderColor;

@end

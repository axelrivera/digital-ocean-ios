//
//  LoginViewController.h
//  DigitalOcean
//
//  Created by Axel Rivera on 9/5/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DoubleInputView;

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UILabel *detailTextLabel;

@property (strong, nonatomic) DoubleInputView *inputView;
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UITextField *passwordTextField;

@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *manualButton;

@property (copy, nonatomic) NSString *emailString;
@property (copy, nonatomic) NSString *passwordString;

@end

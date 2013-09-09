//
//  LoginViewController.h
//  DigitalOcean
//
//  Created by Axel Rivera on 9/5/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) UIButton *loginButton;

@property (copy, nonatomic) NSString *emailString;
@property (copy, nonatomic) NSString *passwordString;

@end

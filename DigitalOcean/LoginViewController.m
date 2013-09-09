//
//  LoginViewController.m
//  DigitalOcean
//
//  Created by Axel Rivera on 9/5/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "LoginViewController.h"

#import "UIButton+Color.h"

#import <UIView+AutoLayout.h>

@interface LoginViewController () <UITextFieldDelegate>

@property (assign, nonatomic) BOOL isBusy;

@end

@implementation LoginViewController

- (id)init
{
    self = [super initWithNibName:@"LoginViewController" bundle:nil];
    if (self) {
        self.title = @"Login";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.loginButton = [UIButton solidButtonWithBackgroundColor:[UIColor do_blueColor]];
    self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];

    [self.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.loginButton];

    // Setup AutoLayout

    [self.loginButton autoSetDimension:ALDimensionHeight toSize:44.0];
    [self.loginButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.passwordTextField withOffset:10.0];
    [self.loginButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.passwordTextField];
    [self.loginButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.passwordTextField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Public Methods

- (void)loginAction:(id)sender
{
    [self.view endEditing:YES];
    
    self.loginButton.enabled = NO;
    self.isBusy = YES;
    [[MaritimoAPIClient sharedClient] authenticateWithEmail:self.emailString
                                                   password:self.passwordString
                                                 completion:^(BOOL success, NSError *error)
     {
         self.loginButton.enabled = YES;
         self.isBusy = NO;
         
         if (!success) {
             self.passwordString = self.passwordTextField.text = @"";
             
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Digital Ocean"
                                                                 message:@"Error authenticating user"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
             [alertView show];
             return;
         }
         
         self.emailString = self.emailTextField.text = @"";
         self.passwordString = self.passwordTextField.text = @"";
         
         [[NSNotificationCenter defaultCenter] postNotificationName:DOUserDidLoginNotification object:nil];
     }];
}

#pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.emailTextField) {
        self.emailString = textField.text;
    } else {
        self.passwordString = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (!self.isBusy) {
        [self loginAction:textField];
    }
    
    return NO;
}

@end

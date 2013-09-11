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
#import "DoubleInputView.h"
#import "CredentialsViewController.h"

@interface LoginViewController () <UITextFieldDelegate, UIScrollViewDelegate>

@property (assign, nonatomic) BOOL isBusy;

@end

@implementation LoginViewController

- (id)init
{
    self = [super initWithNibName:@"LoginViewController" bundle:nil];
    if (self) {
        self.title = @"Maritimo";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.textLabel.font = [UIFont systemFontOfSize:18.0];
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.text = @"Digital Ocean Credentials";
    
    [self.scrollView addSubview:self.textLabel];
    
    self.detailTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
    self.detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    self.detailTextLabel.numberOfLines = 0;
    self.detailTextLabel.preferredMaxLayoutWidth = self.scrollView.bounds.size.width - 20.0;
    self.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;

    NSDictionary *attributes = @{ NSForegroundColorAttributeName : [UIColor colorWithWhite:0.6 alpha:1.0] };

    NSMutableAttributedString *detailStr = [[NSMutableAttributedString alloc]
                                            initWithString:@"The app will login to your Digital Ocean account and save your Client ID and API Key locally.\n\n" attributes:attributes];

    NSString *str = @"Warning! This will override your current API Key.";
    
    attributes = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:12.0],
                    NSForegroundColorAttributeName : [UIColor blackColor] };
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str attributes:attributes];
    [detailStr appendAttributedString:attrStr];
    
    self.detailTextLabel.attributedText = detailStr;
    
    [self.scrollView addSubview:self.detailTextLabel];
    
    self.emailTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.emailTextField.delegate = self;
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.placeholder = @"E-mail Address";
    self.emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.passwordTextField.delegate = self;
    self.passwordTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.passwordTextField.placeholder = @"Password";
    self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.inputView = [[DoubleInputView alloc] initWithFrame:CGRectZero];
    self.inputView.translatesAutoresizingMaskIntoConstraints = NO;
    self.inputView.borderColor = [UIColor lightGrayColor];
    self.inputView.topTextField = self.emailTextField;
    self.inputView.bottomTextField = self.passwordTextField;
    
    [self.scrollView addSubview:self.inputView];

    self.loginButton = [UIButton solidButtonWithBackgroundColor:[UIColor do_blueColor]];
    self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.loginButton setTitle:@"Log In" forState:UIControlStateNormal];

    [self.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.scrollView addSubview:self.loginButton];
    
    self.manualButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.manualButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.manualButton.tintColor = [UIColor do_blueColor];
    [self.manualButton setTitle:@"Don't want to reset your API Key?" forState:UIControlStateNormal];

    [self.manualButton addTarget:self action:@selector(manualAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:self.manualButton];

    // Setup AutoLayout
    
    [self.textLabel autoSetDimension:ALDimensionHeight toSize:22.0];
    [self.textLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0];
    [self.textLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];
    [self.textLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0];
    
    [self.detailTextLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.textLabel withOffset:10.0];
    [self.detailTextLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];
    [self.detailTextLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0];
    
    [self.inputView autoSetDimension:ALDimensionHeight toSize:kDoubleInputViewHeight];
    
    [self.inputView autoSetDimension:ALDimensionWidth
                              toSize:self.scrollView.frame.size.width - 40.0
                            relation:NSLayoutRelationGreaterThanOrEqual];

    [self.inputView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.detailTextLabel withOffset:15.0];;
    [self.inputView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0];
    [self.inputView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0];

    [self.loginButton autoSetDimension:ALDimensionHeight toSize:44.0];
    [self.loginButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.inputView withOffset:20.0];
    [self.loginButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.inputView];
    [self.loginButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.inputView];
    
    [self.manualButton autoSetDimension:ALDimensionHeight toSize:44.0];
    [self.manualButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.loginButton withOffset:5.0];
    [self.manualButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.loginButton];
    [self.manualButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.loginButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHidden:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    CGSize contentSize = self.view.bounds.size;
    contentSize.height -= self.topLayoutGuide.length;

    self.scrollView.contentSize = contentSize;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark Selector Methods

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

- (void)manualAction:(id)sender
{
    CredentialsViewController *credentialsController = [[CredentialsViewController alloc] init];
    [self.navigationController pushViewController:credentialsController animated:YES];
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

#pragma mark - Notification Methods

- (void)keyboardShown:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }];
}

- (void)keyboardHidden:(NSNotification *)notification
{
    CGFloat offset = 0.0;
    if (![UIApplication sharedApplication].statusBarHidden) {
        offset = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    
    if (self.navigationController && !self.navigationController.navigationBarHidden) {
        offset += self.navigationController.navigationBar.frame.size.height;
    }
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(offset, 0.0, 0.0, 0.0);
    CGPoint contentOffset = CGPointMake(0.0, -offset);
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.scrollView setContentOffset:contentOffset animated:NO];
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }];
}

@end

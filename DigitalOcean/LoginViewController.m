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
    
    self.clientTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.clientTextField.delegate = self;
    self.clientTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.clientTextField.placeholder = @"Client ID";
    self.clientTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.clientTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.clientTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.clientTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.apiTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.apiTextField.delegate = self;
    self.apiTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.apiTextField.placeholder = @"API Key";
    self.apiTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.apiTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.apiTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.apiTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.inputView = [[DoubleInputView alloc] initWithFrame:CGRectZero];
    self.inputView.translatesAutoresizingMaskIntoConstraints = NO;
    self.inputView.borderColor = [UIColor lightGrayColor];
    self.inputView.topTextField = self.clientTextField;
    self.inputView.bottomTextField = self.apiTextField;
    
    [self.scrollView addSubview:self.inputView];

    self.validateButton = [UIButton solidButtonWithBackgroundColor:[UIColor do_blueColor]];
    self.validateButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.validateButton setTitle:@"Validate Credentials" forState:UIControlStateNormal];

    [self.validateButton addTarget:self action:@selector(validateAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.scrollView addSubview:self.validateButton];

    // Setup AutoLayout
    
    [self.textLabel autoSetDimension:ALDimensionHeight toSize:22.0];
    [self.textLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0];
    [self.textLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];
    [self.textLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0];
    
    [self.inputView autoSetDimension:ALDimensionHeight toSize:kDoubleInputViewHeight];
    
    [self.inputView autoSetDimension:ALDimensionWidth
                              toSize:self.scrollView.frame.size.width - 40.0
                            relation:NSLayoutRelationEqual];

    [self.inputView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.textLabel withOffset:15.0];;
    [self.inputView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0];
    [self.inputView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0];

    [self.validateButton autoSetDimension:ALDimensionHeight toSize:44.0];
    [self.validateButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.inputView withOffset:20.0];
    [self.validateButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.inputView];
    [self.validateButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.inputView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    CGSize contentSize = self.view.bounds.size;
    contentSize.height -= self.topLayoutGuide.length;

    self.scrollView.contentSize = contentSize;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSString *clientID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsDraftClientIDKey];
    NSString *APIKey = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsDraftAPIKeyKey];

    if (!IsEmpty(clientID)) {
        self.clientTextField.text = clientID;
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUserDefaultsDraftClientIDKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        self.clientTextField.text = [[DigitalOceanAPIClient sharedClient] clientID];
    }

    if (!IsEmpty(APIKey)) {
        self.apiTextField.text = APIKey;
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUserDefaultsDraftAPIKeyKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Selector Methods

- (void)validateAction:(id)sender
{
    [self.view endEditing:YES];

    NSString *clientID = self.clientTextField.text;
    NSString *apiKey = self.apiTextField.text;

    [[DigitalOceanAPIClient sharedClient] validateClientID:clientID
                                                    APIKey:apiKey
                                                completion:^(BOOL success, NSError *error)
     {
         if (success) {
             [[DigitalOceanAPIClient sharedClient] setClientID:clientID];
             [[DigitalOceanAPIClient sharedClient] setAPIKey:apiKey];
             [[NSNotificationCenter defaultCenter] postNotificationName:DOUserDidLoginNotification object:nil];
             return;
         }

         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"API Credentials"
                                                             message:@"Error validating API credentials."
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
         [alertView show];
     }];
}

@end

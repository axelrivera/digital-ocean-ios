//
//  CredentialsViewController.h
//  DigitalOcean
//
//  Created by Axel Rivera on 9/10/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DoubleInputView;

@interface CredentialsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UILabel *detailTextLabel;

@property (strong, nonatomic) DoubleInputView *inputView;
@property (strong, nonatomic) UITextField *clientTextField;
@property (strong, nonatomic) UITextField *apiTextField;

@property (strong, nonatomic) UIButton *validateButton;

@end

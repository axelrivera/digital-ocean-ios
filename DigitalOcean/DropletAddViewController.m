//
//  DropletAddViewController.m
//  DigitalOcean
//
//  Created by Axel Rivera on 9/16/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DropletAddViewController.h"

#import "DropletSizeViewController.h"
#import "DropletRegionViewController.h"
#import "DropletImageViewController.h"
#import "DropletOptionalViewController.h"

@interface DropletAddViewController ()
<UITextFieldDelegate, DropletSizeViewControllerDelegate, DropletRegionViewControllerDelegate, DropletImageViewControllerDelegate>

@end

@implementation DropletAddViewController

- (id)init
{
    self = [super initWithNibName:@"DropletAddViewController" bundle:nil];
    if (self) {
        self.title = @"Create Droplet";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(dismissAction:)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(saveAction:)];

    CGRect fieldRect = CGRectMake(0.0, 0.0, self.tableView.frame.size.width - 30.0, 30.0);
    self.hostnameTextField = [[UITextField alloc] initWithFrame:fieldRect];
    self.hostnameTextField.font = [UIFont systemFontOfSize:16.0];
    self.hostnameTextField.placeholder = @"Enter Hostname";
    self.hostnameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.hostnameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.hostnameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.hostnameTextField.returnKeyType = UIReturnKeyDone;
    self.hostnameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.hostnameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.hostnameTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Selector Methods

- (void)saveAction:(id)sender
{
    [self.delegate dropletAddViewControllerDidFinish:self];
}

- (void)dismissAction:(id)sender
{
    [self.delegate dropletAddViewControllerDidCancel:self];
}

#pragma mark - UIViewControllerDelegate Methods

- (void)dropletSizeViewControllerDidFinish:(DropletSizeViewController *)controller
{
    
}

- (void)dropletRegionViewControllerDidFinish:(DropletRegionViewController *)controller
{
    
}

- (void)dropletImageViewControllerDidFinish:(DropletImageViewController *)controller
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HostnameCell = @"HostnameCell";
    static NSString *CellIdentifier = @"Cell";

    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HostnameCell];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HostnameCell];
            cell.accessoryView = self.hostnameTextField;
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }

    NSString *textStr = nil;

    if (indexPath.section == 1) {
        textStr = @"Required";
    } else if (indexPath.section == 2) {
        textStr = @"Required";
    } else if (indexPath.section == 3) {
        textStr = @"Required";
    } else if (indexPath.section == 4) {
        textStr = @"Optional";
    }

    cell.textLabel.text = textStr;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == 0) {
        title = @"Droplet Hostname";
    } else if (section == 1) {
        title = @"Select Size";
    } else if (section == 2) {
        title = @"Select Region";
    } else if (section == 3) {
        title = @"Select Image";
    } else if (section == 4) {
        title = @"Settings & Options";
    }
    return title;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *controller = nil;
    
    if (indexPath.section == 1) {
        DropletSizeViewController *sizeController = [[DropletSizeViewController alloc] initWithSizes:[DOData sharedData].sizesArray];
        sizeController.delegate = self;
        controller = sizeController;
    } else if (indexPath.section == 2) {
        DropletRegionViewController *regionController = [[DropletRegionViewController alloc] initWithRegions:[DOData sharedData].regionsArray];
        regionController.delegate = self;
        controller = regionController;
    } else if (indexPath.section == 3) {
        DropletImageViewController *imageController = [[DropletImageViewController alloc] initWithImages:[DOData sharedData].imagesArray];
        imageController.delegate = self;
        controller = imageController;
    } else if (indexPath.section == 4) {
        DropletOptionalViewController *optionalController = [[DropletOptionalViewController alloc] init];
        controller = optionalController;
    }
    
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.currentHostname = textField.text;
}

@end

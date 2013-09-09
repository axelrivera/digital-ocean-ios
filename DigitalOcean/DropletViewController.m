//
//  DropletViewController.m
//  DigitalOcean
//
//  Created by Axel Rivera on 9/1/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DropletViewController.h"

#import "ARActivityView.h"
#import "DropletActionView.h"
#import "SnapshotsViewController.h"

@interface DropletViewController ()
<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, DropletActionViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) ARActivityView *activityView;

- (void)reloadTableData;

@end

@implementation DropletViewController

- (id)init
{
    self = [super initWithNibName:@"DropletViewController" bundle:nil];
    if (self) {
        self.title = @"Droplet";
        _droplet = nil;
        _dataSource = @[];
    }
    return self;
}

- (id)initWithDroplet:(DODroplet *)droplet
{
    self = [self init];
    if (self) {
        _droplet = droplet;
        _dataSource = [droplet tableArray];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.activityView = [[ARActivityView alloc] init];
    [self.view addSubview:self.activityView];
    
    [self reloadTableData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[DigitalOceanAPIClient sharedClient].operationQueue cancelAllOperations];
}

#pragma mark - Private Methods

- (void)reloadTableData
{
    self.dataSource = [self.droplet tableArray];
    
    CGRect rect = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, 0.0);
    
    DropletActionViewType viewType = [self.droplet isActive] ? DropletActionViewTypeActive : DropletActionViewTypeInactive;
    DropletActionView *dropletView = [[DropletActionView alloc] initWithType:viewType frame:rect];
    
    if (self.droplet.backupsActive) {
        [dropletView enableBackups];
    } else {
        [dropletView disableBackups];
    }
    
    dropletView.delegate = self;
    
    NSTimeInterval duration = [self isViewLoaded] ? 1.0 : 0.0;
    [UIView transitionWithView:self.tableView.tableHeaderView
                      duration:duration
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^
    {
        self.tableView.tableHeaderView = dropletView;
    }
                    completion:nil];
    
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
    }

    NSDictionary *dictionary = self.dataSource[indexPath.section][indexPath.row];

    cell.textLabel.text = dictionary[kLabelDictionaryKey];
    cell.detailTextLabel.text = dictionary[kValueDictionaryKey];

    UIColor *detailColor = dictionary[kColorDictionaryKey];
    if (detailColor) {
        cell.detailTextLabel.textColor = detailColor;
    } else {
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    }

    BOOL hasNavigation = [dictionary[kNavigationDictionaryKey] boolValue];
    if (hasNavigation) {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 1 && indexPath.row == 0) {
        SnapshotsViewController *snapshotController = [[SnapshotsViewController alloc] initWithDroplet:self.droplet];
        [self.navigationController pushViewController:snapshotController animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == 0) {
        title = self.droplet.name;
    }
    return title;
}

#pragma mark - DropletActionViewDelegate Methods

- (void)actionView:(DropletActionView *)actionView didSelectDropletAction:(DODropletActionType)dropletAction
{
    NSString *name = nil;
    DODropletActionType action = DODropletActionTypeNone;
    switch (dropletAction) {
        case DODropletActionTypeBoot:
            name = @"Boot";
            action = DODropletActionTypeBoot;
            break;
        case DODropletActionTypeReboot:
            name = @"Reboot";
            action = DODropletActionTypeReboot;
            break;
        case DODropletActionTypeShutDown:
            name = @"Shut Down";
            action = DODropletActionTypeShutDown;
            break;
        case DODropletActionTypeResetPassword:
            name = @"Reset Password";
            action = DODropletActionTypeResetPassword;
            break;
        default:
            break;
    }
    
    if (action != DODropletActionTypeNone) {
        NSString *titleStr = nil;
        
        if (action == DODropletActionTypeResetPassword) {
            titleStr = @"This will shut down your droplet and a new root password will be set and emailed to you.";
        } else {
            titleStr = [NSString stringWithFormat:@"Are you sure you want to %@ %@?", name, self.droplet.name];
        }

        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:titleStr
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Continue", nil];
        actionSheet.tag = actionSheet.tag = action;
        [actionSheet showInView:self.view];
    }
    
    if (dropletAction == DODropletActionTypeTakeSnapshot) {
        if ([self.droplet isActive]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Digital Ocean"
                                                                message:@"Please Shut Down your droplet before saving a snapshot."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        } else {
            NSString *messageStr = @"Snapshots can take up to one hour depending the droplet's size.";
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Snapshot Name (Optional)"
                                                                message:messageStr
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Continue", nil];
            
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            
            [alertView show];
        }
    }
}

- (void)actionView:(DropletActionView *)actionView didEnableBackups:(BOOL)enabled
{
    NSString *titleStr = nil;
    DODropletActionType action;
    if (enabled) {
        titleStr = @"Are you sure you want to enable backups? Additional charges may apply.";
        action = DODropletActionTypeEnableBackups;
    } else {
        titleStr = @"Are you sure you want to disable backups?";
        action = DODropletActionTypeDisableBackups;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:titleStr
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Continue", nil];
    actionSheet.tag = actionSheet.tag = action;
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.activityView setTitle:[DODropletAction titleForActionType:actionSheet.tag] indicator:YES];
        [self.activityView showAnimated:YES];
        
        [[DigitalOceanAPIClient sharedClient] dropletAction:actionSheet.tag
                                                  dropletID:self.droplet.objectID
                                                 checkEvent:YES
                                                       wait:YES
                                                 completion:^(BOOL success, NSError *error)
         {
             if (success) {
                 [[DOData sharedData] reloadDropletWithID:self.droplet.objectID
                                               completion:^(DODroplet *droplet, NSError *error)
                  {
                      [self.activityView hideAnimated:YES];
                      if (droplet) {
                          self.droplet = droplet;
                          [self reloadTableData];
                      }
                  }];
             } else {
                 [self.activityView hideAnimated:YES];
             }
         }];
    }
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *name = @"";
        UITextField *textField = [alertView textFieldAtIndex:0];
        if (textField) {
            name = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        
        NSDictionary *options = nil;
        if (!IsEmpty(name)) {
            options = @{ @"name": name };
        }
        
        [self.activityView setTitle:[DODropletAction titleForActionType:DODropletActionTypeTakeSnapshot] indicator:YES];
        [self.activityView showAnimated:YES];
        
        [[DigitalOceanAPIClient sharedClient] dropletAction:DODropletActionTypeTakeSnapshot
                                                  dropletID:self.droplet.objectID
                                                    options:options
                                                 checkEvent:NO
                                                       wait:NO
                                                 completion:^(BOOL success, NSError *error)
        {
            if (success) {
                [self.activityView hideAnimated:YES];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Take Snapshot"
                                                                    message:@"Your snapshot was scheduled successfully."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Take Snapshot"
                                                                  message:@"There was an error while taking the snapshot."
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }
}

@end

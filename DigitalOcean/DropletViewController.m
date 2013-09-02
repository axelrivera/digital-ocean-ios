//
//  DropletViewController.m
//  DigitalOcean
//
//  Created by Axel Rivera on 9/1/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DropletViewController.h"

#import "ARActivityView.h"

@interface DropletViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) ARActivityView *activityView;

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
        _dataSource = [droplet availableActions];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.activityView = [[ARActivityView alloc] init];
    [self.view addSubview:self.activityView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[DOAPIClient sharedClient].operationQueue cancelAllOperations];
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }

    DODropletAction *action = self.dataSource[indexPath.row];

    cell.textLabel.text = [action name];

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    DODropletAction *action = self.dataSource[indexPath.row];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[action name]
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Continue", nil];
    actionSheet.tag = actionSheet.tag = action.actionType;
    [actionSheet showInView:self.view];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.droplet.name;
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.activityView setTitle:[DODropletAction titleForActionType:actionSheet.tag] indicator:YES];
        [self.activityView showAnimated:YES];
        
        [[DOAPIClient sharedClient] dropletAction:actionSheet.tag
                                        dropletID:self.droplet.objectID
                                       checkEvent:YES
                                             wait:YES
                                       completion:^(BOOL success, NSError *error)
         {
             [self.activityView hideAnimated:YES];
             DLog(@"Succedded: %@, Error: %@", NSStringFromBOOL(success), error);
         }];
    }
}

@end

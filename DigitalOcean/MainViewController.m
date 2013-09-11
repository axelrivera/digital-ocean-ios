//
//  MainViewController.m
//  DigitalOcean
//
//  Created by Axel Rivera on 7/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "MainViewController.h"

#import "DropletViewCell.h"
#import "DropletViewController.h"
#import "SettingsViewController.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableViewController *tableViewController;

@end

@implementation MainViewController

- (id)init
{
    self = [super initWithNibName:@"MainViewController" bundle:nil];
    if (self) {
        self.title = @"My Droplets";
        _dataSource = @[];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self action:@selector(settingsAction:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.tableView.rowHeight = 63.0;

    self.tableViewController = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:self.tableViewController];

    self.tableViewController.refreshControl = [[UIRefreshControl alloc] init];

    [self.tableViewController.refreshControl addTarget:self
                                                action:@selector(reloadAction:)
                                      forControlEvents:UIControlEventValueChanged];

    self.tableViewController.tableView = self.tableView;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dropletsUpdated:)
                                                 name:DODropletsUpdatedNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.title = @"Digital Ocean";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //self.title = @"Back";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DODropletsUpdatedNotification object:nil];
}

#pragma mark - Public Methods

- (void)reloadDroplets
{
    [self reloadAction:nil];
}

#pragma mark - Selector Methods

- (void)settingsAction:(id)sender
{
    SettingsViewController *settingsController = [[SettingsViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];

    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

- (void)reloadAction:(id)sender
{
    [[DOData sharedData] reloadInitialDataWithCompletion:^{
        self.dataSource = [DOData sharedData].droplets;
        [self.tableView reloadData];
        if ([sender isKindOfClass:[UIRefreshControl class]]) {
            [sender endRefreshing];
        }
    }];
}

- (void)dropletsUpdated:(NSNotification *)notification
{
    NSArray *droplets = notification.userInfo[kUserInfoDropletsKey];
    if (droplets) {
        self.dataSource = droplets;
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource Methods

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
    static NSString *CellIdentifier = @"CellIdentifier";
    
    DropletViewCell *cell = (DropletViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DropletViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    DODroplet *droplet = self.dataSource[indexPath.row];

    cell.nameLabel.text = droplet.name;
    cell.statusLabel.text = [droplet formattedStatus];
    cell.statusLabel.textColor = [droplet statusColor];
    cell.ipLabel.text = droplet.ipAddress;
    cell.regionLabel.text = [droplet regionName];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    DODroplet *droplet = self.dataSource[indexPath.row];

    DropletViewController *dropletController = [[DropletViewController alloc] initWithDroplet:droplet];
    [self.navigationController pushViewController:dropletController animated:YES];
}

@end

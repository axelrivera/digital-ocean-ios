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

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MainViewController

- (id)init
{
    self = [super initWithNibName:@"MainViewController" bundle:nil];
    if (self) {
        self.title = @"Digital Ocean";
        _dataSource = @[];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                          target:self
                                                                                          action:@selector(reloadAction:)];
    
    self.tableView.rowHeight = [DropletView dropletViewHeight] + 20.0;
    
    [self reloadAction:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Selector Methods

- (void)reloadAction:(id)sender
{
    [[DOData sharedData] reloadInitialDataWithCompletion:^{
        self.dataSource = [DOData sharedData].droplets;
        [self.tableView reloadData];
    }];
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

    cell.dropletView.statusView.contentColor = [droplet statusColor];
    cell.dropletView.nameLabel.text = droplet.name;
    cell.dropletView.ipLabel.text = droplet.ipAddress;
    cell.dropletView.regionLabel.text = [[DOData sharedData] regionNameForIDString:[droplet regionIDString]];
    cell.dropletView.distroLabel.text = [[DOData sharedData] imageNameForIDString:[droplet imageIDString]];
    cell.dropletView.memoryLabel.text = [[DOData sharedData] sizeNameForIDString:[droplet sizeIDString]];

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

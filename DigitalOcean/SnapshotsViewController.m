//
//  SnapshotsViewController.m
//  DigitalOcean
//
//  Created by Axel Rivera on 9/8/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "SnapshotsViewController.h"

@interface SnapshotsViewController ()

- (NSArray *)items;

@end

@implementation SnapshotsViewController

- (id)init
{
    self = [super initWithNibName:@"SnapshotsViewController" bundle:nil];
    if (self) {
        self.title = @"Snapshots & Backups";
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *segmentedItems = @[ @"Snapshots", @"Backups" ];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedItems];
    [self.segmentedControl setWidth:150.0 forSegmentAtIndex:0];
    [self.segmentedControl setWidth:150.0 forSegmentAtIndex:1];

    [self.segmentedControl addTarget:self
                              action:@selector(segmentedControlChanged:)
                    forControlEvents:UIControlEventValueChanged];

    self.toolbarItems = [self items];

    [[DigitalOceanAPIClient sharedClient] fetchDropletWithID:self.droplet.objectID
                                                  completion:^(DODroplet *droplet, NSError *error)
    {
        self.droplet = droplet;
        self.segmentedControl.selectedSegmentIndex = 0;
        [self segmentedControlChanged:self.segmentedControl];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (NSArray *)items
{
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];

    UIBarButtonItem *segmentedItem = [[UIBarButtonItem alloc] initWithCustomView:self.segmentedControl];

    NSArray *array = @[ flexibleItem, segmentedItem, flexibleItem ];

    return array;
}

#pragma mark - Selector Methods

- (void)segmentedControlChanged:(UISegmentedControl *)segmentedControl
{
    NSInteger index = segmentedControl.selectedSegmentIndex;
    if (index == -1) {
        index = 0;
    }

    if (index == 0) {
        self.dataSource = self.droplet.snapshots;
    } else {
        self.dataSource = self.droplet.backups;
    }

    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    id item = self.dataSource[indexPath.row];

    cell.textLabel.text = [item name];
    cell.detailTextLabel.text = [item distribution];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.droplet.name;
}

@end

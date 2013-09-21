//
//  DropletRegionViewController.m
//  DigitalOcean
//
//  Created by Axel Rivera on 9/16/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DropletRegionViewController.h"

@interface DropletRegionViewController ()

@end

@implementation DropletRegionViewController

- (id)init
{
    self = [super initWithNibName:@"DropletRegionViewController" bundle:nil];
    if (self) {
        self.title = @"Select Region";
    }
    return self;
}

- (id)initWithRegions:(NSArray *)regions
{
    self = [self init];
    if (self) {
        _dataSource = regions;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    
    DORegion *region = self.dataSource[indexPath.row];
    
    cell.textLabel.text = region.name;
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DORegion *region = self.dataSource[indexPath.row];
    self.currentRegion = region;
    [self.delegate dropletRegionViewControllerDidFinish:self];
}

@end

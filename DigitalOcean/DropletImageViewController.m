//
//  DropletImageViewController.m
//  DigitalOcean
//
//  Created by Axel Rivera on 9/16/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "DropletImageViewController.h"

@interface DropletImageViewController ()

@end

@implementation DropletImageViewController

- (id)init
{
    self = [super initWithNibName:@"DropletImageViewController" bundle:nil];
    if (self) {
        self.title = @"Select Image";
    }
    return self;
}

- (id)initWithImages:(NSArray *)images
{
    self = [self init];
    if (self) {
        NSMutableArray *public = [@[] mutableCopy];
        NSMutableArray *private = [@[] mutableCopy];
        
        for (DOImage *image in images) {
            if (image.isPublic) {
                [public addObject:image];
            } else {
                [private addObject:image];
            }
        }
        
        _dataSource = @[ public, private ];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    
    DOImage *image = self.dataSource[indexPath.section][indexPath.row];
    
    cell.textLabel.text = image.name;
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == 0) {
        title = @"Public";
    } else {
        title = @"Private";
    }
    return title;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DOImage *image = self.dataSource[indexPath.section][indexPath.row];
    self.currentImage = image;
    [self.delegate dropletImageViewControllerDidFinish:self];
}

@end

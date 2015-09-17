//
//  ViewController.m
//  SPRefresh
//
//  Created by sy2036 on 2015-09-17.
//  Copyright (c) 2015 Roselifeye. All rights reserved.
//

#import "ViewController.h"
#import "SPRefresh.h"

@interface ViewController () {
    SPRefresh *refreshHeader;
    SPRefresh *refreshFooter;
    int total;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    total = 16;
    
    __weak UITableView *weakTable = self.tableView;
    
    refreshHeader = [[SPRefresh alloc] initWithScrollView:self.tableView withHeader:YES];
    __weak SPRefresh *weakHeader = refreshHeader;
    refreshHeader.refreshBlockEnd = ^(){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(2);
            dispatch_async(dispatch_get_main_queue(), ^{
                // Main Queue refresh the UI.
                total += 20;
                [weakTable reloadData];
                [weakHeader endRefresh];
                
                NSLog(@"Stop Refresh");
            });
        });
    };
    
    refreshFooter = [[SPRefresh alloc] initWithScrollView:self.tableView withHeader:NO];
    __weak SPRefresh *weakFooter = refreshFooter;
    refreshFooter.refreshBlockEnd = ^(){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(2);
            dispatch_async(dispatch_get_main_queue(), ^{
                // Main Queue refresh the UI.
                total += 20;
                [weakTable reloadData];
                [weakFooter endRefresh];
                
                NSLog(@"Stop Refresh");
            });
        });
    };
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return total;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
    }
    cell.textLabel.text=[NSString stringWithFormat:@"（%ld）Refresh Successful!", indexPath.row+1];
    // Configure the cell...
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  CategoryViewController.m
//  takestok
//
//  Created by Artem on 6/1/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "CategoryViewController.h"
#import "Category.h"

@implementation CategoryViewController
@synthesize delegate;

-(void)viewDidLoad{
    [super viewDidLoad];
    _categories = [Category getAll];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
    Category* category = [_categories objectAtIndex:indexPath.row];
    cell.textLabel.text = category.title;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate categorySelected:[_categories objectAtIndex:indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

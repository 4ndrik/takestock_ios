//
//  CategoryViewController.m
//  takestok
//
//  Created by Artem on 6/1/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "CategoryViewController.h"
#import "AdvertServiceManager.h"
#import "TSAdvertCategory.h"
#import "TSAdvertSubCategory.h"

@implementation CategoryViewController
@synthesize delegate;

-(void)setCategory:(TSAdvertCategory*)category{
    if (category){
        _subCategories = YES;
        _items = category.subCategories;
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    if (!_subCategories){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
        _items = [[AdvertServiceManager sharedManager] getCategories];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _items.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
    NSString* title = @"All";
    if (indexPath.row > 0){
        TSBaseDictionaryEntity* category = [_items objectAtIndex:indexPath.row - 1];
        title = category.title;
    }
    cell.textLabel.text = title;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TSBaseDictionaryEntity* selectedCategory = nil;
    if (indexPath.row > 0){
        selectedCategory = [_items objectAtIndex:indexPath.row - 1];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CategoryViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CategoryVC"];
        [vc setCategory:(TSAdvertCategory*)selectedCategory];
        vc.delegate = self.delegate;
        [self.navigationController pushViewController:vc animated:YES];
        return;

    }else{
        TSBaseDictionaryEntity* selectedSubCategory = [_items objectAtIndex:0];
        if ([selectedSubCategory isKindOfClass:[TSAdvertSubCategory class]]){
            selectedCategory = [[AdvertServiceManager sharedManager] getCategoyWithId:((TSAdvertSubCategory*)selectedSubCategory).parentIdent];
        }
    }
    
    [self.delegate categorySelected:selectedCategory];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)close:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end

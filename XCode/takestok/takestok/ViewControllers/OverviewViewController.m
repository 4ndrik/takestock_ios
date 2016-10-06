//
//  OverviewViewController.m
//  takestok
//
//  Created by Artem on 10/6/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "OverviewViewController.h"

@interface OverviewViewController ()

@end

@implementation OverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [_sourceSegmentedControl setSelectedSegmentIndex:_sourceScrollView.contentOffset.x / _sourceScrollView.bounds.size.width];
}

- (IBAction)sourceChanged:(id)sender {
    [_sourceScrollView setContentOffset:CGPointMake(_sourceScrollView.bounds.size.width * _sourceSegmentedControl.selectedSegmentIndex, 0) animated:YES];
}
@end

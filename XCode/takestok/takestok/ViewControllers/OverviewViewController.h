//
//  OverviewViewController.h
//  takestok
//
//  Created by Artem on 10/6/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"

@interface OverviewViewController : BaseViewController<UIScrollViewDelegate>{
    
    __weak IBOutlet UISegmentedControl *_sourceSegmentedControl;
    __weak IBOutlet UIScrollView *_sourceScrollView;
}

- (IBAction)sourceChanged:(id)sender;

@end

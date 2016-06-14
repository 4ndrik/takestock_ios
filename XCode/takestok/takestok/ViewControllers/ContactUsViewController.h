//
//  AboutUsViewController.h
//  takestok
//
//  Created by Artem on 6/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"

@interface ContactUsViewController : BaseViewController<UIWebViewDelegate>{
    
    __weak IBOutlet UIWebView *_webView;
}

@end

//
//  QAViewController.m
//  takestok
//
//  Created by Artem on 5/6/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "QAViewController.h"
#import "Advert.h"
#import "QATableViewCell.h"
#import "AskQuestionView.h"
#import "UIView+NibLoadView.h"

@interface QAViewController ()

@end

@implementation QAViewController

-(void)setAdvert:(Advert*)advert{
    _advert = advert;
    _qaData = [NSMutableArray array];
    if (self.isViewLoaded){
        [self loadQA];
    }
}

- (IBAction)hideKeyboard:(id)sender {
    if ([_askQuestionView.questionTextView isFirstResponder]){
        [_askQuestionView.questionTextView resignFirstResponder];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}

-(void)loadQA{
    
}

#pragma mark - Handle keyboard

- (void)keyboardWillHide:(NSNotification *)n
{
    _askTableView.contentInset = UIEdgeInsetsZero;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    _keyboardFrame = keyboardSize.height;
    _askTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QATableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QATableViewCell"];
    
    NSMutableAttributedString *buyerText = [[NSMutableAttributedString alloc] initWithString:@"Buyer: Some question."];
    [buyerText addAttribute:NSFontAttributeName
                  value:ArialBold14
                  range:NSMakeRange(0, 6)];
    
    [buyerText addAttribute:NSFontAttributeName
                  value:ArialItalic14
                  range:NSMakeRange(6, buyerText.length - 6)];
    
    
    
    
    cell.questionLabel.attributedText = buyerText;
    
    
    NSMutableAttributedString *sellerText = [[NSMutableAttributedString alloc] initWithString:@"Seller: Some question."];
    [sellerText addAttribute:NSFontAttributeName
                      value:ArialBold14
                      range:NSMakeRange(0, 7)];
    
    [sellerText addAttribute:NSFontAttributeName
                      value:ArialItalic14
                      range:NSMakeRange(7, sellerText.length - 7)];
    
    cell.answerLabel.attributedText = sellerText;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return [AskQuestionView defaultHeight];
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!_askQuestionView){
        _askQuestionView = [AskQuestionView loadFromXib];
    }
    return _askQuestionView;
}

@end

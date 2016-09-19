//
//  ShippingInfoActionView.m
//  takestok
//
//  Created by Artem on 7/1/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "ShippingInfoActionView.h"
#import "PaddingTextField.h"


@implementation ShippingInfoActionView

-(void)awakeFromNib{
    [super awakeFromNib];
    UIDatePicker* datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 303)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    self.dateShippedTextField.inputView = datePicker;
    [datePicker addTarget:self action:@selector(setShippedDate:) forControlEvents:UIControlEventValueChanged];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 303)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    self.dateArrivedTextField.inputView = datePicker;
    [datePicker addTarget:self action:@selector(setArrivalDate:) forControlEvents:UIControlEventValueChanged];
}

-(void)setShippedDate:(UIDatePicker*)owner{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    self.dateShippedTextField.text = [formatter stringFromDate:owner.date];
}

-(void)setArrivalDate:(UIDatePicker*)owner{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    self.dateArrivedTextField.text = [formatter stringFromDate:owner.date];
}

@end

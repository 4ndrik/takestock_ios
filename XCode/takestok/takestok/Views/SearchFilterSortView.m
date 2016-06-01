//
//  SearchHeaderView.m
//  takestok
//
//  Created by Artem on 4/8/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "SearchFilterSortView.h"
#import "SortData.h"

#define DefaultHeight 44

#define FilterItemXMargin 10.
#define FilterItemYMargin 13.
#define FilterItemHeight 24.

#define SortPanelHeight 200.

@implementation SearchFilterSortView
@synthesize delegate = _delegate;

-(void)setDelegate:(id<SearchFilterSortDelegate>)delegate{
    _delegate = delegate;
    [_sortButton setTitle:[NSString stringWithFormat:@"%@ ▼", [_delegate getSelectedSortItem].title] forState:UIControlStateNormal];
    [_filterButton setTitle:@"Filter ▼" forState:UIControlStateNormal];
}

+(float)defaultHeight{
    return DefaultHeight;
}

-(float)height{
    if (_paneltype == kNone){
        return  DefaultHeight;
    }
    else{
        return height + _contentView.frame.origin.y;
    }
}

-(void)customizeLabel:(UILabel*)label withText:(NSString*)filterItem isSelected:(BOOL)isSelected{
    label.text = [NSString stringWithFormat:@"%@ %@", filterItem, isSelected ? @"-" : @"+"];
    label.backgroundColor = isSelected ? OliveMainColor : GrayColor;
}

-(void)paneltypeChanged:(PanelType)paneltype{
    _paneltype = paneltype;
    switch (_paneltype) {
        case kFilter:{
            [_filterButton setTitle:@"Filter ▲" forState:UIControlStateNormal];
            [_sortButton setTitle:[NSString stringWithFormat:@"%@ ▼", [_delegate getSelectedSortItem].title] forState:UIControlStateNormal];
            [[_contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            float x = FilterItemXMargin;
            float y = FilterItemYMargin;
            height = y + FilterItemHeight + FilterItemYMargin;
            NSSet* selectedSet = [_delegate selectedFilterData];
            
            for (NSString* filterItem in [_delegate filterData]){
                UILabel* label = [[UILabel alloc] init];
                label.font = [UIFont fontWithName:@"Helvetice" size:14.];
                label.textColor = [UIColor whiteColor];
                [self customizeLabel:label withText:filterItem isSelected:[selectedSet containsObject:filterItem]];
                label.textAlignment = NSTextAlignmentCenter;
                label.layer.cornerRadius = 2.;
                label.clipsToBounds = YES;
                [_contentView addSubview:label];
                [label sizeToFit];
                float width = label.frame.size.width + 20;
                if (x + label.frame.size.width + FilterItemXMargin > _contentView.frame.size.width){
                    x = FilterItemXMargin;
                    y += FilterItemHeight + FilterItemYMargin;
                    height = y + FilterItemHeight + FilterItemYMargin;
                }
                if (label.frame.size.width + FilterItemXMargin *2 > _contentView.frame.size.width){
                    width = _contentView.frame.size.width - FilterItemXMargin *2;
                }
                label.frame = CGRectMake(x, y, width, FilterItemHeight);
                x += width + FilterItemXMargin;
                
                UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sortItemSelected:)];
                [label addGestureRecognizer:tapGesture];
                label.userInteractionEnabled = YES;
            }
            break;
        }
        case kSort:{
            [_sortButton setTitle:[NSString stringWithFormat:@"%@ ▲", [_delegate getSelectedSortItem].title] forState:UIControlStateNormal];
            [_filterButton setTitle:@"Filter ▼" forState:UIControlStateNormal];
            [[_contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            UIPickerView* picker = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 0, _contentView.frame.size.width - 40, SortPanelHeight)];
            picker.delegate = self;
            picker.dataSource = self;
            picker.showsSelectionIndicator = YES;
            [_contentView addSubview:picker];
            height = SortPanelHeight;
            
            UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedToSelectRow:)];
            tapToSelect.delegate = self;
            [picker addGestureRecognizer:tapToSelect];
            
//            [picker reloadAllComponents];
//            
//            NSUInteger index = [_pickerData indexOfObjectPassingTest:^BOOL(Dictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                return obj.ident == textField.tag;
//            }];
//            [picker selectRow:index == NSNotFound ? 0 : index inComponent:0 animated:NO];
            
            break;
        }
        default:{
            [_sortButton setTitle:[NSString stringWithFormat:@"%@ ▼", [_delegate getSelectedSortItem].title] forState:UIControlStateNormal];
            [_filterButton setTitle:@"Filter ▼" forState:UIControlStateNormal];
            height = 0;
            break;
        }
    }
    [_delegate panelTypeChanged];
}

#pragma mark - Actions

- (void)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        UIPickerView* picker = (UIPickerView*)tapRecognizer.view;
        CGFloat rowHeight = [picker rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(picker.bounds, 0.0, (CGRectGetHeight(picker.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:picker]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [picker selectedRowInComponent:0];
            [_delegate sortItemSelected:[[_delegate sortItems] objectAtIndex:selectedRow]];
            [self paneltypeChanged:kNone];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_delegate sortItems].count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = ((SortData*)[[_delegate sortItems] objectAtIndex:row]).title;
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:GrayColor}];
    
    return attString;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.;
}

#pragma mark - Helpers

-(void)sortItemSelected:(UITapGestureRecognizer*)owner{
    UILabel* label = (UILabel*)owner.view;
    NSString* filterItem = [label.text substringToIndex:[label.text length] - 2];
    
    NSSet* selectedSet = [_delegate selectedFilterData];
    BOOL isSelected = [selectedSet containsObject:filterItem];
    
    [_delegate filterItem:filterItem selected:!isSelected];
    [self customizeLabel:label withText:filterItem isSelected:!isSelected];
}

#pragma mark - IBActions

- (IBAction)showFilterPanelAction:(id)sender {
    if (_paneltype == kFilter){
        [self paneltypeChanged:kNone];
    }else{
        [self paneltypeChanged:kFilter];
    }
}

- (IBAction)showSortPanelAction:(id)sender {
    if (_paneltype == kSort){
        [self paneltypeChanged:kNone];
    }else{
        [self paneltypeChanged:kSort];
    }
}

@end

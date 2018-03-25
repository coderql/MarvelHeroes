//
//  MSHSearchView.m
//  MarvelHeroes
//
//  Created by qian zhao on 2018/3/25.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MSHSearchView.h"

static CGFloat const kCancelButtonWidth = 60.f;
static CGFloat const kPadding = 16.f;
static CGFloat const kTextFieldHeight = 34.f;

@interface MSHSearchView() <UITextFieldDelegate>
@property (nonatomic, strong) UIButton *cancelButton;
@end

@implementation MSHSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        _searchActive = NO;
    }
    return self;
}

- (void)setupViews {
//    self.backgroundColor = kSearchBarTintColor;
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(kPadding, 5, self.frame.size.width - kPadding * 2, kTextFieldHeight)];
    _searchTextField.placeholder = @"Search by name";
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    leftView.contentMode = UIViewContentModeRight;
    leftView.image = [UIImage imageNamed:@"search"];
    _searchTextField.leftView = leftView;
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.backgroundColor = kBackgroundColor;
    _searchTextField.delegate = self;
    _searchTextField.returnKeyType = UIReturnKeySearch;
    [self addSubview:self.searchTextField];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelButton.frame = CGRectMake(0, 0, kCancelButtonWidth, kDefaultHeight);
    _cancelButton.center = CGPointMake(CGRectGetWidth(self.frame) - kPadding - kCancelButtonWidth / 2, CGRectGetHeight(self.frame) / 2);
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(searchCancelled:) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.hidden = YES;
    [self addSubview:self.cancelButton];
}

- (void)searchCancelled:(UIButton *)sennder {
    self.searchTextField.text = @"";
    self.searchActive = NO;
    [self updateTextFieldWithEditingState:NO];
    if (self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(searchView:cancelButtonClicked:)]) {
        [self.searchDelegate searchView:self cancelButtonClicked:sennder];
    }
}

- (void)updateTextFieldWithEditingState:(BOOL)isEditing {
    __block CGRect finalFrame = self.searchTextField.frame;
//    self.cancelButton.hidden = !isEditing;
    if (!isEditing) {
        [self.searchTextField resignFirstResponder];
        self.cancelButton.hidden = YES;
    }
    [UIView animateWithDuration:0.3f animations:^{
        if (isEditing) {
            finalFrame.size.width = CGRectGetWidth(self.frame) - 2 * kPadding - kCancelButtonWidth;
        } else {
            finalFrame.size.width = CGRectGetWidth(self.frame) - 2 * kPadding;
        }
        self.searchTextField.frame = finalFrame;
    } completion:^(BOOL finished) {
        if (isEditing) {
            self.cancelButton.hidden = NO;
        }
    }];
}

- (void)endSearching {
    [self.searchTextField resignFirstResponder];
    [self searchCancelled:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.searchActive = YES;
    [self updateTextFieldWithEditingState:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"should triggle search");
    [self updateTextFieldWithEditingState:NO];
    if (![MSHUtils isEmptyString:textField.text]) {
        if (self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(searchView:didEndEditing:)]) {
            [self.searchDelegate searchView:self didEndEditing:textField.text];
        }
    }
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

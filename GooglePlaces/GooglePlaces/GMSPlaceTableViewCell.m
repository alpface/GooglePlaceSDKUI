//
//  GMSPlaceTableViewCell.m
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/24.
//  Copyright © 2018 alpface. All rights reserved.
//

#import "GMSPlaceTableViewCell.h"

static CGFloat kTypeIconWidth = 35.0;

@interface GMSPlaceTableViewCell ()

@property (weak, nonatomic) UILabel  *distanceAndTimeLabel;
@property (nonatomic, strong) UIView *textContentView;
@property (nonatomic, weak) NSLayoutConstraint *primaryTextLabelTopConstraint;
@property (nonatomic, weak) NSLayoutConstraint *secondaryTextLabelConstraint;
@property (nonatomic, weak) NSLayoutConstraint *distanceAndTimeLabelConstraint;
@property (nonatomic, weak) NSLayoutConstraint *navButtonWidthConstraint;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGes;
@property (nonatomic, copy) void (^longPressGestureRecognizerBlock)(UILongPressGestureRecognizer *longPressGes);
@property (nonatomic, weak) NSLayoutConstraint *contentTopCons;
@property (nonatomic, weak) NSLayoutConstraint *contentBottomCons;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) NSLayoutConstraint *typeIconViewWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *textContentViewLeftConstraint1;
@property (nonatomic, strong) NSLayoutConstraint *textContentViewLeftConstraint2;

@end

@implementation GMSPlaceTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)identifier
{
    return [self initWithReuseIdentifier:identifier withVerticalTextPadding:0];
}

- (instancetype)initWithReuseIdentifier:(NSString *)identifier withVerticalTextPadding:(float)padding
{
    if (self = [super initWithStyle:0x0 reuseIdentifier:identifier]) {

        [self setupViews];
    }
    return self;
   
}
////////////////////////////////////////////////////////////////////////
#pragma mark - UI
////////////////////////////////////////////////////////////////////////
- (void)setupViews {
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.primaryTextLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.secondaryTextLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.distanceAndTimeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.primaryTextLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.secondaryTextLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.distanceAndTimeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [NSLayoutConstraint constraintWithItem:self.bottomLineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.bottomLineView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.bottomLineView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.bottomLineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.typeIconView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:16.0].active = true;
    _typeIconViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.typeIconView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kTypeIconWidth];
    _typeIconViewWidthConstraint.active = YES;
    [NSLayoutConstraint constraintWithItem:self.typeIconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.typeIconView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0].active = true;
    [NSLayoutConstraint constraintWithItem:self.typeIconView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0].active = true;
    
    [NSLayoutConstraint constraintWithItem:self.typeIconView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:5.0].active = true;
    [NSLayoutConstraint constraintWithItem:self.typeIconView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5.0].active = true;
    
   _textContentViewLeftConstraint1 = [NSLayoutConstraint constraintWithItem:self.textContentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.typeIconView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10.0];
    _textContentViewLeftConstraint1.active = YES;
    _textContentViewLeftConstraint2 = [NSLayoutConstraint constraintWithItem:self.textContentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.typeIconView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    [NSLayoutConstraint constraintWithItem:self.textContentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0].active = true;
    [NSLayoutConstraint constraintWithItem:self.textContentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-16.0].active = YES;
    
    NSLayoutConstraint *textContentViewTop = [NSLayoutConstraint constraintWithItem:self.textContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    _contentTopCons = textContentViewTop;
    textContentViewTop.active = YES;
    NSLayoutConstraint *textContentViewBottom = [NSLayoutConstraint constraintWithItem:self.textContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    textContentViewBottom.active = YES;
    _contentBottomCons = textContentViewBottom;
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(6.0)-[primaryTextLabel]-(6.0)-[secondaryTextLabel]-(6.0)-[distanceAndTimeLabel]-(6.0)-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:@{@"primaryTextLabel": self.primaryTextLabel, @"secondaryTextLabel": self.secondaryTextLabel, @"distanceAndTimeLabel": self.distanceAndTimeLabel}]];
    [NSLayoutConstraint constraintWithItem:self.primaryTextLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.textContentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0].active = true;
    [NSLayoutConstraint constraintWithItem:self.primaryTextLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.textContentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0].active = true;
    [NSLayoutConstraint constraintWithItem:self.secondaryTextLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.textContentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0].active = true;
    [NSLayoutConstraint constraintWithItem:self.distanceAndTimeLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.textContentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0].active = true;
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////
- (UILabel *)primaryTextLabel {
    if (!_primaryTextLabel ) {
        UILabel *label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = false;
        _primaryTextLabel = label;
        label.font = [UIFont systemFontOfSize:16.0];
        label.numberOfLines = 2;
        [self.textContentView addSubview:label];
    }
    return _primaryTextLabel;
}

- (UILabel *)secondaryTextLabel {
    if (!_secondaryTextLabel ) {
        UILabel *label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = false;
        _secondaryTextLabel = label;
        label.font = [UIFont systemFontOfSize:13.0];
        label.numberOfLines = 2;
        [self.textContentView addSubview:label];
    }
    return _secondaryTextLabel;
}

- (UILabel *)distanceAndTimeLabel {
    if (_distanceAndTimeLabel == nil) {
        UILabel *label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = false;
        _distanceAndTimeLabel = label;
        label.font = [UIFont systemFontOfSize:13.0];
        label.numberOfLines = 1;
        [self.textContentView addSubview:label];
    }
    return _distanceAndTimeLabel;
}

- (UIView *)textContentView {
    if (!_textContentView) {
        UIView *textContentView = [UIView new];
        _textContentView = textContentView;
        _textContentView.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:_textContentView];
    }
    return _textContentView;
}

- (UIImageView *)typeIconView {
    if (!_typeIconView) {
        UIImageView *imageView = [UIImageView new];
        _typeIconView = imageView;
        _typeIconView.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:imageView];
    }
    return _typeIconView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [UIView new];
        _bottomLineView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f];
        _bottomLineView.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:_bottomLineView];
    }
    return _bottomLineView;
}

- (NSLayoutConstraint *)secondaryTextLabelConstraint {
    if (!_secondaryTextLabelConstraint) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstItem==%@ AND firstAttribute==%ld AND secondItem==%@ AND secondAttribute==%ld", self.secondaryTextLabel, NSLayoutAttributeTop, self.primaryTextLabel, NSLayoutAttributeBottom];
        NSLayoutConstraint *constraint = [self.textContentView.constraints filteredArrayUsingPredicate:predicate].firstObject;
        _secondaryTextLabelConstraint = constraint;
    }
    return _secondaryTextLabelConstraint;
}

- (NSLayoutConstraint *)primaryTextLabelTopConstraint {
    if (!_primaryTextLabelTopConstraint) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstItem==%@ AND firstAttribute==%ld AND secondItem==%@ AND secondAttribute==%ld", self.primaryTextLabel, NSLayoutAttributeTop, self.textContentView, NSLayoutAttributeTop];
        NSLayoutConstraint *constraint = [self.textContentView.constraints filteredArrayUsingPredicate:predicate].firstObject;
        _primaryTextLabelTopConstraint = constraint;
    }
    return _primaryTextLabelTopConstraint;
}

- (NSLayoutConstraint *)distanceAndTimeLabelConstraint {
    if (!_distanceAndTimeLabelConstraint) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstItem==%@ AND firstAttribute==%ld AND secondItem==%@ AND secondAttribute==%ld", self.distanceAndTimeLabel, NSLayoutAttributeTop, self.secondaryTextLabel, NSLayoutAttributeBottom];
        NSLayoutConstraint *constraint = [self.textContentView.constraints filteredArrayUsingPredicate:predicate].firstObject;
        _distanceAndTimeLabelConstraint = constraint;
    }
    return _distanceAndTimeLabelConstraint;
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////

- (void)updateConstraints
{
    [super updateConstraints];
    const CGFloat padding = 6.0;
    if (self.primaryTextLabel.text.length == 0) {
        self.primaryTextLabelTopConstraint.constant = 0.0;
    }
    else {
        self.primaryTextLabelTopConstraint.constant = padding;
    }
    if (self.secondaryTextLabel.text.length == 0) {
        self.secondaryTextLabelConstraint.constant = 0.0;
    }
    else {
        self.secondaryTextLabelConstraint.constant = padding;
    }
    if (self.distanceAndTimeLabel.text.length == 0) {
        self.distanceAndTimeLabelConstraint.constant = 0.0;
    }
    else {
        self.distanceAndTimeLabelConstraint.constant = padding;
    }
    if (self.typeIconView.image) {
        self.typeIconViewWidthConstraint.constant = kTypeIconWidth;
        _textContentViewLeftConstraint1.active = YES;
        _textContentViewLeftConstraint2.active = NO;
    }
    else {
        self.typeIconViewWidthConstraint.constant = 0.0;
        _textContentViewLeftConstraint1.active = NO;
        _textContentViewLeftConstraint2.active = YES;
    }
    self.contentTopCons.constant = 15.0;
    self.contentBottomCons.constant = -15.0;
}

@end

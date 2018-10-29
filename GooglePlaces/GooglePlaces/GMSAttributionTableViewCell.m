//
//  GMSAttributionTableViewCell.m
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/24.
//  Copyright © 2018 alpface. All rights reserved.
//

#import "GMSAttributionTableViewCell.h"
#import "GMSPlacesResources.h"

@interface GMSAttributionTableViewCell ()
{
    UIImageView *_attributionImageView;
    UIActivityIndicatorView *_activityIndicator;
    UIView *_UITableViewCellSeparatorView;
}

@property(readonly, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation GMSAttributionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithReuseIdentifier:(NSString *)identifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]) {
        [self setSelectionStyle:0x0];
        [self setAccessibilityElementsHidden:0x1];
        self.contentView.backgroundColor = [UIColor clearColor];
        UIImage *logoImage = [GMSPlacesResources bundleImageNamed:@"powered-by-google-dark"];
        NSParameterAssert(logoImage);
        _attributionImageView = [[UIImageView alloc] initWithImage:logoImage];
        [self.contentView addSubview:_attributionImageView];
         [_attributionImageView setAccessibilityIdentifier:@"powered-by-google-dark"];
        _attributionImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint constraintWithItem:_attributionImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:20.0].active = YES;
        [NSLayoutConstraint constraintWithItem:_attributionImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0].active = YES;
        [NSLayoutConstraint constraintWithItem:_attributionImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20.0].active = YES;
        [NSLayoutConstraint constraintWithItem:_attributionImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(20.0/logoImage.size.height * logoImage.size.width)].active = YES;
        [NSLayoutConstraint constraintWithItem:_attributionImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20.0].active = YES;
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:0x2];
        [self.contentView addSubview:_activityIndicator];
        _activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_activityIndicator];
        [NSLayoutConstraint constraintWithItem:_activityIndicator attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_attributionImageView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:5.0].active = YES;
        [NSLayoutConstraint constraintWithItem:_activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_attributionImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0].active = YES;
        _activityIndicator.hidden = YES;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self _UITableViewCellSeparatorView].hidden = YES;
}

- (UIView *)_UITableViewCellSeparatorView {
    if (_UITableViewCellSeparatorView) {
        return _UITableViewCellSeparatorView;
    }
    __block UIView *view = nil;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")]) {
            view = obj;
            *stop = YES;
        }
    }];
    NSParameterAssert(view);
    return _UITableViewCellSeparatorView = view;
}

@end

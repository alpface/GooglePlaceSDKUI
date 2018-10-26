//
//  GMSPlaceTableViewCell.h
//  GooglePlaceSDKUI
//
//  Created by xiaoyuan on 2018/10/24.
//  Copyright © 2018 alpface. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMSPlaceTableViewCell : UITableViewCell

@property (weak, nonatomic) UILabel  *primaryTextLabel;
@property (weak, nonatomic) UILabel  *secondaryTextLabel;
@property (weak, nonatomic) UIImageView  *typeIconView;
- (instancetype)initWithReuseIdentifier:(NSString *)identifier;
- (instancetype)initWithReuseIdentifier:(NSString *)identifier withVerticalTextPadding:(float)padding;
@end

NS_ASSUME_NONNULL_END
